#!/usr/bin/env bash

repository_name="${1}"
repository_path="${3}"

[[ ${repository_name} == "gentoo" ]] || exit 0

source /lib/gentoo/functions.sh

NEWSDIR="${repository_path}"/metadata/news
ebegin "Updating news items"
if [[ -e ${NEWSDIR} ]]; then
    git -C "${NEWSDIR}" pull -q --ff-only
else
    git clone -q https://anongit.gentoo.org/git/data/gentoo-news.git "${NEWSDIR}"
fi
eend $? "Try to remove ${NEWSDIR}"
