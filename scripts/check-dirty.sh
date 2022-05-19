#!/usr/bin/env bash

_DIRTY=$(git status --porcelain)
if [[ -z "$_DIRTY" ]] ; then
   echo "✅ Git workspace is clean"
else
   echo "🚨 Git workspace has unexpected changes:"
   echo "$_DIRTY"
   echo "=== ✏️ Changed files ==="
   git diff
   exit 1
fi
