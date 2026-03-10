#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)

DEFAULT_TARBALL_URL="https://github.com/rmalan99/skills/archive/refs/heads/main.tar.gz"
MARKER_FILE=".qa-skills-suite-install"

install_opencode=true
install_codex=true
dry_run=false
target_selected=false
cleanup_paths=()

usage() {
  cat <<'EOF'
Install qa-skills-suite into local OpenCode and Codex skill directories.

Usage:
  install-qa-skill.sh [--opencode] [--codex] [--dry-run]

Options:
  --opencode   Install only into OpenCode.
  --codex      Install only into Codex.
  --dry-run    Print planned actions without changing files.
  --help       Show this help.

Environment:
  OPENCODE_HOME                 Override OpenCode config root.
  CODEX_HOME                    Override Codex config root.
  XDG_CONFIG_HOME               Used for OpenCode when OPENCODE_HOME is unset.
  QA_SKILLS_SUITE_TARBALL_URL   Override the fallback tarball URL.

Notes:
  - When run inside this repository, the local skills source is used.
  - When the local source is unavailable, the script downloads the suite tarball.
  - Existing unrelated skills are preserved.
EOF
}

log() {
  printf '[%s] %s\n' "$SCRIPT_NAME" "$*"
}

warn() {
  printf '[%s] warning: %s\n' "$SCRIPT_NAME" "$*" >&2
}

die() {
  printf '[%s] error: %s\n' "$SCRIPT_NAME" "$*" >&2
  exit 1
}

cleanup() {
  local path
  for path in "${cleanup_paths[@]:-}"; do
    if [ -n "$path" ] && [ -e "$path" ]; then
      rm -rf "$path"
    fi
  done
}

trap cleanup EXIT

require_command() {
  local cmd=$1
  command -v "$cmd" >/dev/null 2>&1 || die "Required command not found: $cmd"
}

make_temp_dir() {
  local dir
  dir=$(mktemp -d)
  cleanup_paths+=("$dir")
  printf '%s\n' "$dir"
}

resolve_source_dir() {
  local local_source_dir extracted_root archive temp_dir tarball_url

  local_source_dir="$REPO_ROOT/skills/qa-skills-suite"
  if [ -d "$local_source_dir" ]; then
    printf '%s\n' "$local_source_dir"
    return 0
  fi

  require_command curl
  require_command tar

  tarball_url=${QA_SKILLS_SUITE_TARBALL_URL:-$DEFAULT_TARBALL_URL}
  temp_dir=$(make_temp_dir)
  archive="$temp_dir/qa-skills-suite.tar.gz"

  log "Downloading qa-skills-suite from $tarball_url"
  curl -fsSL "$tarball_url" -o "$archive"
  tar -xzf "$archive" -C "$temp_dir"

  set -- "$temp_dir"/*/skills/qa-skills-suite
  if [ "$#" -ne 1 ] || [ ! -d "$1" ]; then
    die "Could not locate skills/qa-skills-suite inside downloaded tarball"
  fi

  extracted_root=$1
  printf '%s\n' "$extracted_root"
}

safe_replace_managed_dir() {
  local dest_dir stage_dir
  dest_dir=$1
  stage_dir=$2

  if [ -e "$dest_dir" ] && [ ! -f "$dest_dir/$MARKER_FILE" ]; then
    die "Refusing to replace unmanaged directory: $dest_dir"
  fi

  if [ "$dry_run" = true ]; then
    log "Would replace managed directory $dest_dir"
    return 0
  fi

  rm -rf "$dest_dir"
  mv "$stage_dir" "$dest_dir"
}

ensure_dir() {
  local dir=$1
  if [ "$dry_run" = true ]; then
    log "Would ensure directory $dir"
    return 0
  fi
  mkdir -p "$dir"
}

ensure_symlink() {
  local link_path target_path label current_target
  link_path=$1
  target_path=$2
  label=$3

  if [ -L "$link_path" ]; then
    current_target=$(readlink "$link_path")
    if [ "$current_target" = "$target_path" ]; then
      log "$label already points to $target_path"
      return 0
    fi
  elif [ -e "$link_path" ]; then
    warn "$label already exists and is not managed: $link_path"
    return 0
  fi

  if [ "$dry_run" = true ]; then
    log "Would link $label: $link_path -> $target_path"
    return 0
  fi

  rm -f "$link_path"
  ln -s "$target_path" "$link_path"
  log "Linked $label: $link_path -> $target_path"
}

stage_suite_copy() {
  local source_dir stage_root staged_dir
  source_dir=$1
  stage_root=$(make_temp_dir)
  staged_dir="$stage_root/qa-skills-suite"

  mkdir -p "$staged_dir"
  cp -R "$source_dir"/. "$staged_dir"/

  cat >"$staged_dir/$MARKER_FILE" <<EOF
managed_by=$SCRIPT_NAME
source_dir=$source_dir
installed_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF

  printf '%s\n' "$staged_dir"
}

install_skill_links() {
  local skills_dir managed_dir child_dir skill_name alias_path
  skills_dir=$1
  managed_dir=$2

  for child_dir in "$managed_dir"/*; do
    if [ ! -d "$child_dir" ] || [ ! -f "$child_dir/SKILL.md" ]; then
      continue
    fi

    skill_name=$(basename "$child_dir")
    alias_path="$skills_dir/$skill_name"

    if [ -e "$alias_path" ] && [ ! -L "$alias_path" ]; then
      warn "Keeping existing unmanaged skill in place: $alias_path"
      continue
    fi

    ensure_symlink "$alias_path" "$child_dir" "$skill_name skill alias"
  done
}

install_target() {
  local label root_dir skills_dir source_dir managed_dir staged_dir qa_dir qa_skills_link
  label=$1
  root_dir=$2
  source_dir=$3

  skills_dir="$root_dir/skills"
  managed_dir="$skills_dir/qa-skills-suite"
  qa_dir="$skills_dir/qa"
  qa_skills_link="$qa_dir/skills"

  log "Preparing $label install at $root_dir"
  ensure_dir "$skills_dir"

  staged_dir=$(stage_suite_copy "$source_dir")
  safe_replace_managed_dir "$managed_dir" "$staged_dir"

  ensure_dir "$qa_dir"
  ensure_symlink "$qa_skills_link" "$managed_dir" "$label compatibility tree"
  install_skill_links "$skills_dir" "$managed_dir"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --opencode)
      if [ "$target_selected" = false ]; then
        install_opencode=false
        install_codex=false
        target_selected=true
      fi
      install_opencode=true
      ;;
    --codex)
      if [ "$target_selected" = false ]; then
        install_opencode=false
        install_codex=false
        target_selected=true
      fi
      install_codex=true
      ;;
    --dry-run)
      dry_run=true
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      die "Unknown argument: $1"
      ;;
  esac
  shift
done

source_dir=$(resolve_source_dir)
opencode_root=${OPENCODE_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}/opencode}
codex_root=${CODEX_HOME:-$HOME/.codex}

if [ "$install_opencode" = true ]; then
  install_target "OpenCode" "$opencode_root" "$source_dir"
fi

if [ "$install_codex" = true ]; then
  install_target "Codex" "$codex_root" "$source_dir"
fi

log "Done"
