#!/usr/bin/env bash
# host-change.sh — the single sanctioned path for a host mutation on the NUC.
#
#   snapshot -> apply -> verify -> revert on failure
#
# The declared paths are snapshotted BEFORE anything is applied, verified AFTER,
# and rolled back automatically when verification fails. The apply step runs only
# with an explicit approval flag, so this cannot mutate the host by accident.
#
# Usage:
#   host-change.sh --name NAME --apply 'CMD' [options]
#
# Options:
#   --name NAME          short slug for the change (required)
#   --apply 'CMD'        command that performs the change (required)
#   --verify 'CMD'       command that proves the change worked (default: docker ps)
#   --paths 'P1:P2:...'  files/dirs to snapshot (default: compose, systemd user units, ~/bin)
#   --description TEXT   why the change is being made
#   --approved           run the apply step (human gate; or HOST_CHANGE_APPROVED=1)
#   --dry-run            snapshot and print the plan, never apply
#   --list               list snapshots
#   --revert ID          restore a snapshot by id
#
# Exit codes: 0 ok | 1 error | 2 apply failed | 3 verify failed, reverted | 4 not approved
set -euo pipefail

STATE_DIR="${HOST_CHANGE_STATE_DIR:-/home/ozzo/.local/state/host-change}"
DEFAULT_PATHS="/home/ozzo/data-hub/docker-compose.yml:/home/ozzo/.config/systemd/user:/home/ozzo/bin"
DEFAULT_VERIFY="docker ps --format '{{.Names}}' >/dev/null"

NAME=""
APPLY=""
VERIFY=""
PATHS=""
DESC=""
APPROVED=0
DRY_RUN=0
MODE="run"
REVERT_ID=""

die() { echo "error: $*" >&2; exit 1; }
usage() { sed -n '2,26p' "$0"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --name)        NAME="${2:-}"; shift 2 ;;
    --apply)       APPLY="${2:-}"; shift 2 ;;
    --verify)      VERIFY="${2:-}"; shift 2 ;;
    --paths)       PATHS="${2:-}"; shift 2 ;;
    --description) DESC="${2:-}"; shift 2 ;;
    --approved)    APPROVED=1; shift ;;
    --dry-run)     DRY_RUN=1; shift ;;
    --list)        MODE="list"; shift ;;
    --revert)      MODE="revert"; REVERT_ID="${2:-}"; shift 2 ;;
    -h|--help)     usage; exit 0 ;;
    *)             die "unknown argument: $1" ;;
  esac
done

[ "${HOST_CHANGE_APPROVED:-0}" = "1" ] && APPROVED=1

mkdir -p "$STATE_DIR"

list_snapshots() {
  if [ -z "$(ls -A "$STATE_DIR" 2>/dev/null | grep -v '^ledger.jsonl$' || true)" ]; then
    echo "no snapshots in $STATE_DIR"
    return 0
  fi
  for d in "$STATE_DIR"/*/; do
    [ -d "$d" ] || continue
    local id meta
    id="$(basename "$d")"
    meta="$d/meta.json"
    if [ -f "$meta" ]; then
      python3 - "$meta" "$id" <<'PY'
import json, sys
m = json.load(open(sys.argv[1]))
print(f"  {sys.argv[2]}  applied={m.get('applied')} reverted={m.get('reverted')}  {m.get('description','')[:60]}")
PY
    else
      echo "  $id"
    fi
  done
}

restore_snapshot() {
  local snap="$1" manifest="$1/manifest.tsv" restored=0
  [ -d "$snap" ] || die "no such snapshot: $snap"
  [ -f "$manifest" ] || die "snapshot has no manifest: $manifest"
  while IFS=$'\t' read -r kind original stored; do
    [ -n "${kind:-}" ] || continue
    [ -e "$snap/$stored" ] || { echo "  missing in snapshot: $stored" >&2; continue; }
    if [ "$kind" = "dir" ]; then
      tar xzf "$snap/$stored" -C /
    else
      cp -a "$snap/$stored" "$original"
    fi
    echo "  restored $original"
    restored=$((restored + 1))
  done < "$manifest"
  echo "  $restored path(s) restored"
}

ledger() {
  python3 - "$STATE_DIR/ledger.jsonl" "$1" "$2" "$3" "$4" "$5" "$6" "$7" <<'PY'
import json, sys
path, ts, name, desc, apply_cmd, verify_cmd, rc, snapshot = sys.argv[1:9]
with open(path, "a") as fh:
    fh.write(json.dumps({
        "ts": ts, "name": name, "description": desc,
        "apply": apply_cmd, "verify": verify_cmd, "result": rc, "snapshot": snapshot,
    }, ensure_ascii=False) + "\n")
PY
}

case "$MODE" in
  list)
    list_snapshots
    exit 0
    ;;
  revert)
    [ -n "$REVERT_ID" ] || die "--revert needs a snapshot id (see --list)"
    echo "== reverting $REVERT_ID =="
    restore_snapshot "$STATE_DIR/$REVERT_ID"
    echo
    echo "reverted. Verify by hand: docker ps ; systemctl --user status hermes-gateway"
    exit 0
    ;;
esac

[ -n "$NAME" ] || die "--name is required"
[ -n "$APPLY" ] || die "--apply is required"
[ -n "$VERIFY" ] || VERIFY="$DEFAULT_VERIFY"
[ -n "$PATHS" ] || PATHS="$DEFAULT_PATHS"

ID="$(date +%Y%m%d-%H%M%S)-$NAME"
SNAP="$STATE_DIR/$ID"
mkdir -p "$SNAP"
: > "$SNAP/manifest.tsv"

echo "== 1. snapshot =="
echo "  id:     $ID"
echo "  paths:  $PATHS"
IFS=':' read -r -a path_list <<< "$PATHS"
for p in "${path_list[@]}"; do
  [ -e "$p" ] || { echo "  skip (missing): $p"; continue; }
  stored="$(echo "$p" | tr '/' '_')"
  if [ -d "$p" ]; then
    tar czf "$SNAP/$stored.tgz" -C / "${p#/}"
    printf 'dir\t%s\t%s\n' "$p" "$stored.tgz" >> "$SNAP/manifest.tsv"
    echo "  snapshotted dir  $p"
  else
    cp -a "$p" "$SNAP/$stored"
    printf 'file\t%s\t%s\n' "$p" "$stored" >> "$SNAP/manifest.tsv"
    echo "  snapshotted file $p"
  fi
done

docker ps --format '{{.Names}}\t{{.Status}}' > "$SNAP/docker-ps.before.txt" 2>/dev/null || echo "  (docker ps unavailable)" > "$SNAP/docker-ps.before.txt"
docker compose -f /home/ozzo/data-hub/docker-compose.yml config > "$SNAP/compose.before.yaml" 2>/dev/null || true
{
  echo "### ~/.hermes"; git -C /home/ozzo/.hermes status --short 2>&1 || true
  echo "### ~/data-hub"; git -C /home/ozzo/data-hub status --short 2>&1 || true
} > "$SNAP/git-status.before.txt" 2>&1 || true

python3 - "$SNAP/meta.json" "$ID" "$NAME" "$DESC" "$APPLY" "$VERIFY" <<'PY'
import json, sys, datetime
path, sid, name, desc, apply_cmd, verify_cmd = sys.argv[1:7]
json.dump({
    "id": sid, "name": name, "description": desc,
    "apply": apply_cmd, "verify": verify_cmd,
    "created": datetime.datetime.now().astimezone().isoformat(timespec="seconds"),
    "applied": False, "reverted": False,
}, open(path, "w"), indent=2, ensure_ascii=False)
PY

echo
echo "  apply:  $APPLY"
echo "  verify: $VERIFY"

if [ "$DRY_RUN" = "1" ]; then
  echo
  echo "dry run: snapshot only, nothing applied. Snapshot: $SNAP"
  exit 0
fi

if [ "$APPROVED" != "1" ]; then
  echo
  echo "NOT APPLIED — approval required."
  echo "  Re-run with --approved (or HOST_CHANGE_APPROVED=1) to apply, or --revert $ID to discard."
  exit 4
fi

echo
echo "== 2. apply =="
set +e
bash -lc "$APPLY" 2>&1 | tee "$SNAP/apply.log"
APPLY_RC="${PIPESTATUS[0]}"
set -e
echo "  apply exit code: $APPLY_RC"
if [ "$APPLY_RC" -ne 0 ]; then
  echo
  echo "apply FAILED — nothing was changed by this script; inspect $SNAP/apply.log" >&2
  ledger "$(date -Is)" "$NAME" "$DESC" "$APPLY" "$VERIFY" "apply-failed:$APPLY_RC" "$SNAP"
  exit 2
fi

python3 - "$SNAP/meta.json" <<'PY'
import json, sys
p = sys.argv[1]; m = json.load(open(p)); m["applied"] = True
json.dump(m, open(p, "w"), indent=2, ensure_ascii=False)
PY

echo
echo "== 3. verify =="
set +e
bash -lc "$VERIFY" 2>&1 | tee "$SNAP/verify.log"
VERIFY_RC="${PIPESTATUS[0]}"
set -e
echo "  verify exit code: $VERIFY_RC"

if [ "$VERIFY_RC" -ne 0 ]; then
  echo
  echo "== 4. verify FAILED — reverting ==" >&2
  restore_snapshot "$SNAP" || true
  python3 - "$SNAP/meta.json" <<'PY'
import json, sys
p = sys.argv[1]; m = json.load(open(p)); m["reverted"] = True
json.dump(m, open(p, "w"), indent=2, ensure_ascii=False)
PY
  ledger "$(date -Is)" "$NAME" "$DESC" "$APPLY" "$VERIFY" "verify-failed:reverted" "$SNAP"
  echo
  echo "reverted from $SNAP. Check service state by hand; the apply log is $SNAP/apply.log" >&2
  exit 3
fi

ledger "$(date -Is)" "$NAME" "$DESC" "$APPLY" "$VERIFY" "ok" "$SNAP"
echo
echo "done. snapshot kept at $SNAP (undo later with: host-change.sh --revert $ID)"
