#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

ROOT="${1:-.}"
ALLOW_EXTRA_EVERYWHERE=0
STRICT_ROOT=0
SPEC_BASENAME='.dirc'

IGNORE_BASENAMES=('.git' '.dirc')

if [[ "${1:-}" != "" ]] && [[ ! -d "$ROOT" ]]; then
  ROOT="."
fi

fail() {
  echo "dirc: $*" >&2
  exit 1
}

basename_safe() {
  local p="$1"
  echo "${p##*/}"
}

matches_any() {
  local name="$1"; shift
  local pat
  for pat in "$@"; do
    [[ "$name" == $pat ]] && return 0
  done
  return 1
}

is_ignored() {
  local base="$1"
  matches_any "$base" "${IGNORE_BASENAMES[@]}"
}

check_dir() {
  local rel="$1"
  local allowed_dirs_var="$2"
  local allowed_files_var="$3"
  local required_dirs_var="$4"
  local required_files_var="$5"
  local allow_extra="$6"

  local path="$ROOT/$rel"
  [[ -d "$path" ]] || fail "missing directory: $rel"

  local allowed_dirs allowed_files required_dirs required_files
  eval "allowed_dirs=(\"\${${allowed_dirs_var}[@]}\")"
  eval "allowed_files=(\"\${${allowed_files_var}[@]}\")"
  eval "required_dirs=(\"\${${required_dirs_var}[@]}\")"
  eval "required_files=(\"\${${required_files_var}[@]}\")"

  local req
  for req in "${required_dirs[@]}"; do
    [[ -d "$path/$req" ]] || fail "missing required directory: ${rel%/}/$req"
  done

  for req in "${required_files[@]}"; do
    [[ -f "$path/$req" ]] || fail "missing required file: ${rel%/}/$req"
  done

  shopt -s nullglob dotglob
  local entries=("$path"/*)
  shopt -u dotglob

  local entry base
  for entry in "${entries[@]}"; do
    base="$(basename_safe "$entry")"
    is_ignored "$base" && continue

    if [[ -d "$entry" ]]; then
      if matches_any "$base" "${allowed_dirs[@]}"; then
        :
      elif [[ "$allow_extra" == "1" ]]; then
        :
      else
        fail "unexpected directory: ${rel%/}/$base"
      fi
    else
      if matches_any "$base" "${allowed_files[@]}"; then
        :
      elif [[ "$allow_extra" == "1" ]]; then
        :
      else
        fail "unexpected file: ${rel%/}/$base"
      fi
    fi
  done
}

ALLOWED_DIRS_1=('.github' 'applications' 'scripts')
ALLOWED_FILES_1=()
REQUIRED_DIRS_1=('.github' 'applications' 'scripts')
REQUIRED_FILES_1=()

rule_1() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_1 ALLOWED_FILES_1 REQUIRED_DIRS_1 REQUIRED_FILES_1 "$allow_extra"
  rule_2 "${rel%/}/.github"
  rule_4 "${rel%/}/applications"
  rule_23 "${rel%/}/scripts"
}

ALLOWED_DIRS_2=('workflows')
ALLOWED_FILES_2=()
REQUIRED_DIRS_2=('workflows')
REQUIRED_FILES_2=()

rule_2() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_2 ALLOWED_FILES_2 REQUIRED_DIRS_2 REQUIRED_FILES_2 "$allow_extra"
  rule_3 "${rel%/}/workflows"
}

ALLOWED_DIRS_3=()
ALLOWED_FILES_3=('*.yaml')
REQUIRED_DIRS_3=()
REQUIRED_FILES_3=()

rule_3() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_3 ALLOWED_FILES_3 REQUIRED_DIRS_3 REQUIRED_FILES_3 "$allow_extra"
}

ALLOWED_DIRS_4=('monitoring-content')
ALLOWED_FILES_4=()
REQUIRED_DIRS_4=('monitoring-content')
REQUIRED_FILES_4=()

rule_4() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_4 ALLOWED_FILES_4 REQUIRED_DIRS_4 REQUIRED_FILES_4 "$allow_extra"
  rule_5 "${rel%/}/monitoring-content"
}

ALLOWED_DIRS_5=('components' 'overlays')
ALLOWED_FILES_5=()
REQUIRED_DIRS_5=('components' 'overlays')
REQUIRED_FILES_5=()

rule_5() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_5 ALLOWED_FILES_5 REQUIRED_DIRS_5 REQUIRED_FILES_5 "$allow_extra"
  rule_6 "${rel%/}/components"
  rule_18 "${rel%/}/overlays"
}

ALLOWED_DIRS_6=('alerts' 'targets')
ALLOWED_FILES_6=()
REQUIRED_DIRS_6=('alerts' 'targets')
REQUIRED_FILES_6=()

rule_6() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_6 ALLOWED_FILES_6 REQUIRED_DIRS_6 REQUIRED_FILES_6 "$allow_extra"
  rule_7 "${rel%/}/alerts"
  rule_14 "${rel%/}/targets"
}

ALLOWED_DIRS_7=('packs' 'targets')
ALLOWED_FILES_7=()
REQUIRED_DIRS_7=('packs' 'targets')
REQUIRED_FILES_7=()

rule_7() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_7 ALLOWED_FILES_7 REQUIRED_DIRS_7 REQUIRED_FILES_7 "$allow_extra"
  rule_8 "${rel%/}/packs"
  rule_10 "${rel%/}/targets"
}

ALLOWED_DIRS_8=('*')
ALLOWED_FILES_8=()
REQUIRED_DIRS_8=()
REQUIRED_FILES_8=()

rule_8() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_8 ALLOWED_FILES_8 REQUIRED_DIRS_8 REQUIRED_FILES_8 "$allow_extra"
  local path="$ROOT/$rel"
  shopt -s nullglob dotglob
  local dirs=("$path"/*)
  shopt -u dotglob
  local entry base
  for entry in "${dirs[@]}"; do
    [[ -d "$entry" ]] || continue
    base="$(basename_safe "$entry")"
    is_ignored "$base" && continue
    local matched=0
    if [[ "$base" == * ]]; then
      if [[ "$matched" == "1" ]]; then
        fail "ambiguous directory rule for: ${rel%/}/$base"
      fi
      matched=1
      rule_9 "${rel%/}/$base"
    fi
  done
}

ALLOWED_DIRS_9=()
ALLOWED_FILES_9=('*.yaml' 'kustomization.yaml')
REQUIRED_DIRS_9=()
REQUIRED_FILES_9=('kustomization.yaml')

rule_9() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_9 ALLOWED_FILES_9 REQUIRED_DIRS_9 REQUIRED_FILES_9 "$allow_extra"
}

ALLOWED_DIRS_10=('*')
ALLOWED_FILES_10=()
REQUIRED_DIRS_10=()
REQUIRED_FILES_10=()

rule_10() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_10 ALLOWED_FILES_10 REQUIRED_DIRS_10 REQUIRED_FILES_10 "$allow_extra"
  local path="$ROOT/$rel"
  shopt -s nullglob dotglob
  local dirs=("$path"/*)
  shopt -u dotglob
  local entry base
  for entry in "${dirs[@]}"; do
    [[ -d "$entry" ]] || continue
    base="$(basename_safe "$entry")"
    is_ignored "$base" && continue
    local matched=0
    if [[ "$base" == * ]]; then
      if [[ "$matched" == "1" ]]; then
        fail "ambiguous directory rule for: ${rel%/}/$base"
      fi
      matched=1
      rule_11 "${rel%/}/$base"
    fi
  done
}

ALLOWED_DIRS_11=('experimental' 'stable')
ALLOWED_FILES_11=()
REQUIRED_DIRS_11=('experimental' 'stable')
REQUIRED_FILES_11=()

rule_11() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_11 ALLOWED_FILES_11 REQUIRED_DIRS_11 REQUIRED_FILES_11 "$allow_extra"
  rule_12 "${rel%/}/experimental"
  rule_13 "${rel%/}/stable"
}

ALLOWED_DIRS_12=()
ALLOWED_FILES_12=('*.yaml' 'kustomization.yaml')
REQUIRED_DIRS_12=()
REQUIRED_FILES_12=('kustomization.yaml')

rule_12() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_12 ALLOWED_FILES_12 REQUIRED_DIRS_12 REQUIRED_FILES_12 "$allow_extra"
}

ALLOWED_DIRS_13=()
ALLOWED_FILES_13=('*.yaml' 'kustomization.yaml')
REQUIRED_DIRS_13=()
REQUIRED_FILES_13=('kustomization.yaml')

rule_13() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_13 ALLOWED_FILES_13 REQUIRED_DIRS_13 REQUIRED_FILES_13 "$allow_extra"
}

ALLOWED_DIRS_14=('*')
ALLOWED_FILES_14=()
REQUIRED_DIRS_14=()
REQUIRED_FILES_14=()

rule_14() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_14 ALLOWED_FILES_14 REQUIRED_DIRS_14 REQUIRED_FILES_14 "$allow_extra"
  local path="$ROOT/$rel"
  shopt -s nullglob dotglob
  local dirs=("$path"/*)
  shopt -u dotglob
  local entry base
  for entry in "${dirs[@]}"; do
    [[ -d "$entry" ]] || continue
    base="$(basename_safe "$entry")"
    is_ignored "$base" && continue
    local matched=0
    if [[ "$base" == * ]]; then
      if [[ "$matched" == "1" ]]; then
        fail "ambiguous directory rule for: ${rel%/}/$base"
      fi
      matched=1
      rule_15 "${rel%/}/$base"
    fi
  done
}

ALLOWED_DIRS_15=('resources')
ALLOWED_FILES_15=('values.yaml')
REQUIRED_DIRS_15=('resources')
REQUIRED_FILES_15=('values.yaml')

rule_15() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_15 ALLOWED_FILES_15 REQUIRED_DIRS_15 REQUIRED_FILES_15 "$allow_extra"
  rule_16 "${rel%/}/resources"
}

ALLOWED_DIRS_16=('secrets')
ALLOWED_FILES_16=('*.yaml')
REQUIRED_DIRS_16=('secrets')
REQUIRED_FILES_16=()

rule_16() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_16 ALLOWED_FILES_16 REQUIRED_DIRS_16 REQUIRED_FILES_16 "$allow_extra"
  rule_17 "${rel%/}/secrets"
}

ALLOWED_DIRS_17=()
ALLOWED_FILES_17=('*.yaml')
REQUIRED_DIRS_17=()
REQUIRED_FILES_17=()

rule_17() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_17 ALLOWED_FILES_17 REQUIRED_DIRS_17 REQUIRED_FILES_17 "$allow_extra"
}

ALLOWED_DIRS_18=('*')
ALLOWED_FILES_18=()
REQUIRED_DIRS_18=()
REQUIRED_FILES_18=()

rule_18() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_18 ALLOWED_FILES_18 REQUIRED_DIRS_18 REQUIRED_FILES_18 "$allow_extra"
  local path="$ROOT/$rel"
  shopt -s nullglob dotglob
  local dirs=("$path"/*)
  shopt -u dotglob
  local entry base
  for entry in "${dirs[@]}"; do
    [[ -d "$entry" ]] || continue
    base="$(basename_safe "$entry")"
    is_ignored "$base" && continue
    local matched=0
    if [[ "$base" == * ]]; then
      if [[ "$matched" == "1" ]]; then
        fail "ambiguous directory rule for: ${rel%/}/$base"
      fi
      matched=1
      rule_19 "${rel%/}/$base"
    fi
  done
}

ALLOWED_DIRS_19=('include')
ALLOWED_FILES_19=('kustomization.yaml')
REQUIRED_DIRS_19=('include')
REQUIRED_FILES_19=('kustomization.yaml')

rule_19() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_19 ALLOWED_FILES_19 REQUIRED_DIRS_19 REQUIRED_FILES_19 "$allow_extra"
  rule_20 "${rel%/}/include"
}

ALLOWED_DIRS_20=('*')
ALLOWED_FILES_20=()
REQUIRED_DIRS_20=()
REQUIRED_FILES_20=()

rule_20() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_20 ALLOWED_FILES_20 REQUIRED_DIRS_20 REQUIRED_FILES_20 "$allow_extra"
  local path="$ROOT/$rel"
  shopt -s nullglob dotglob
  local dirs=("$path"/*)
  shopt -u dotglob
  local entry base
  for entry in "${dirs[@]}"; do
    [[ -d "$entry" ]] || continue
    base="$(basename_safe "$entry")"
    is_ignored "$base" && continue
    local matched=0
    if [[ "$base" == * ]]; then
      if [[ "$matched" == "1" ]]; then
        fail "ambiguous directory rule for: ${rel%/}/$base"
      fi
      matched=1
      rule_21 "${rel%/}/$base"
    fi
  done
}

ALLOWED_DIRS_21=('*targets.d')
ALLOWED_FILES_21=('*.yaml' 'kustomization.yaml')
REQUIRED_DIRS_21=()
REQUIRED_FILES_21=('kustomization.yaml')

rule_21() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_21 ALLOWED_FILES_21 REQUIRED_DIRS_21 REQUIRED_FILES_21 "$allow_extra"
  local path="$ROOT/$rel"
  shopt -s nullglob dotglob
  local dirs=("$path"/*)
  shopt -u dotglob
  local entry base
  for entry in "${dirs[@]}"; do
    [[ -d "$entry" ]] || continue
    base="$(basename_safe "$entry")"
    is_ignored "$base" && continue
    local matched=0
    if [[ "$base" == *targets.d ]]; then
      if [[ "$matched" == "1" ]]; then
        fail "ambiguous directory rule for: ${rel%/}/$base"
      fi
      matched=1
      rule_22 "${rel%/}/$base"
    fi
  done
}

ALLOWED_DIRS_22=()
ALLOWED_FILES_22=('*.json')
REQUIRED_DIRS_22=()
REQUIRED_FILES_22=()

rule_22() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_22 ALLOWED_FILES_22 REQUIRED_DIRS_22 REQUIRED_FILES_22 "$allow_extra"
}

ALLOWED_DIRS_23=()
ALLOWED_FILES_23=('validate_structure.sh')
REQUIRED_DIRS_23=()
REQUIRED_FILES_23=('validate_structure.sh')

rule_23() {
  local rel="$1"
  local allow_extra=0
  if [[ "$ALLOW_EXTRA_EVERYWHERE" == "1" ]] || ([[ "$rel" == "." ]] && [[ "$STRICT_ROOT" != "1" ]]); then allow_extra=1; fi
  check_dir "$rel" ALLOWED_DIRS_23 ALLOWED_FILES_23 REQUIRED_DIRS_23 REQUIRED_FILES_23 "$allow_extra"
}

rule_1 "."

echo "dirc: ok"
