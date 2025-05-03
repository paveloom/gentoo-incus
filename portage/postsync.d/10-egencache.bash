#!/usr/bin/env bash

set -x

NPROC=$(nproc)
LOAD_AVERAGE=$((NPROC + 1))

for repo in gentoo guru; do
    egencache --jobs="$NPROC" --load-average=$LOAD_AVERAGE \
        --repo $repo --update --update-pkg-desc-index --update-use-local-desc
done
