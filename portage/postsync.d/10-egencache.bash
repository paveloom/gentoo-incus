#!/usr/bin/env bash

set -x

NPROC=$(nproc)
LOAD_AVERAGE=$(($NPROC + 1))

for repo in gentoo guru
do
    egencache -v --jobs=$NPROC --load-average=$LOAD_AVERAGE --update --repo $repo
done
