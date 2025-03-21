#!/bin/bash -l
set -xeEuo pipefail

if [[ -z "${1:-}" ]]; then
  echo "Usage: $0 REMOTE_URL" >&2
  exit 1
fi

REMOTE_URL=$1
REMOTE=upstream-$(date +%s)

trap "git remote rm $REMOTE" ERR SIGHUP SIGINT SIGTERM

declare -A EXTRA_ARGS
function join_by { local IFS="$1"; shift; echo "$*"; }

if [[ ${SKIP_HOOKS:-} == "true" ]]; then
  EXTRA_ARGS+="--no-verify"
fi

if [[ ${FORCE_PUSH:-} == "true" ]]; then
  EXTRA_ARGS+="--force"
fi

git remote add $REMOTE $REMOTE_URL
git push $(join_by " " $EXTRA_ARGS) $REMOTE HEAD:refs/heads/master
