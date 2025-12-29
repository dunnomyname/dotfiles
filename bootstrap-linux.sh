#!/bin/bash
set -euo pipefail

# ----------------------------
# Resolve script directory
# ----------------------------
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

# ----------------------------
# Resolve real user & home
# ----------------------------
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"

if [[ -z "${REAL_HOME}" || ! -d "${REAL_HOME}" ]]; then
  echo "Could not resolve home directory for user: ${REAL_USER}" >&2
  exit 1
fi

# ----------------------------
# Update repo safely
# ----------------------------
git pull --ff-only

# ----------------------------
# rsync options
# ----------------------------
RSYNC_OPTS=(
  -avh
  --no-perms
  --itemize-changes
)

# Exclusions
RSYNC_EXCLUDES=(
  --exclude ".git/"
  --exclude ".DS_Store"
  --exclude "bootstrap-*.sh"
  --exclude "setup-*.sh"
  --exclude "README.md"
  --exclude "LICENSE-MIT.txt"
)

# ----------------------------
# Sync function
# ----------------------------
updateConfig() {
  rsync \
    "${RSYNC_OPTS[@]}" \
    "${RSYNC_EXCLUDES[@]}" \
    .zshrc \
    .config \
    "${REAL_HOME}/"
}

# ----------------------------
# Argument handling
# ----------------------------
case "${1:-}" in
  --dry-run|-n)
    echo "Running DRY RUN (no files will be modified)"
    RSYNC_OPTS+=(-n)
    updateConfig
    ;;
  --force|-f)
    updateConfig
    ;;
  *)
    read -r -p "This will update .zshrc and .config in ${REAL_HOME}. Continue? (y/n) " -n 1 reply
    echo
    if [[ "$reply" =~ ^[Yy]$ ]]; then
      updateConfig
    else
      echo "Aborted."
    fi
    ;;
esac
