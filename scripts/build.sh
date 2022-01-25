#!/usr/bin/env bash

# only exit with zero if all commands of the pipeline exit successfully
set -uf -o pipefail

# Clean up broken build flag
rm -f BUILD_IS_BROKEN

errfile=$(mktemp)

function buildCommandFromFile() {
  FILE="${1:?File name not set or empty}"
  PATH=$(sed -n -e "s#clusters/\(.*\)\.jsonnet#\1#p" <<< $FILE)
  echo "
    set -uf -o pipefail ; 
    rm -fr manifests/${PATH} ; 
    mkdir -p manifests/${PATH} ; 
    mkdir -p manifests/${PATH}/setup ; 
    jsonnet --jpath lib --jpath vendor --multi manifests/${PATH} ${FILE} | \
        grep -v .out$ | \
        xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml' -- {}
  "
}

function applyDir() {
  find $@ -name "*.jsonnet" -print0 | 
    while IFS= read -r -d '' file; do 
      echo $(buildCommandFromFile "$file")
    done
}

jobs=6

while getopts "j:" opt; do
  case ${opt} in
    j )
      jobs=$OPTARG
    ;;
  esac
done
shift $((OPTIND -1))

DEFAULT_DIRECTORIES=( "clusters" )
DIRECTORIES=${@:-"${DEFAULT_DIRECTORIES}"}

find lib $DIRECTORIES -type f -name "*.jsonnet" -o -name "*.libsonnet" | xargs -I {} jsonnetfmt --indent 4 --string-style d --comment-style s --in-place {}

applyDir "${DIRECTORIES}" | parallel -j $jobs --halt soon,fail=1 2>${errfile}

if [[ $? -ne 0 ]];
then
  stderr=$(<${errfile})
  echo "YOU HAVE ERRORS!"
  echo "${stderr}"
  echo
  echo "Please do not commit this."
  # The pre-commit script should check for this and fail
  touch BUILD_IS_BROKEN
  exit 1
fi

rm $errfile

# Make sure to remove intermediate files
find manifests -type f \
  ! -name '*.yaml' \
  ! -name '*.json' \
  ! -name '*.yaml.ignore' \
  ! -name '*.json.ignore' \
  -delete
