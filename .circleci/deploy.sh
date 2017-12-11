#!/usr/bin/env bash

set -e
set -u

pkg_version=$(jq -r '.version' package.json)

if [[ "$(git log -1 --pretty='%s')" == "${pkg_version}" ]]; then
  echo "> Deployed v${pkg_version}"
fi
