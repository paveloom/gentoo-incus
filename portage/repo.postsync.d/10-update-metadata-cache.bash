#!/usr/bin/env bash

repository_name="${1}"

source /lib/gentoo/functions.sh

parallel_jobs="$(nproc)"

ebegin "Updating metadata cache for ${repository_name}"
egencache --jobs="${parallel_jobs}" --repo="${repository_name}" --update --update-use-local-desc
eend $?
