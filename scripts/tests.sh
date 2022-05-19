#!/usr/bin/env bash

# only exit with zero if all commands of the pipeline exit successfully
set -uf -o pipefail

find tests -type f -name "*.jsonnet" | xargs -I {} jsonnet -J vendor -J lib {}
