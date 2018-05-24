#!/usr/bin/env bash

set -e
set -u

pkg_name=$(jq -r '.name' package.json)
pkg_version=$(jq -r '.version' package.json)

if [[ "$(git log -1 --pretty='%s')" == "${pkg_version}" ]]; then
  repo=$DRONE_REPO
  deploy_target="${pkg_name}:${pkg_version}"

  build_num="$(drone build ls $repo \
    --format="{{ .Number }} {{ .Ref }}" \
    | grep -m 1 'refs/heads/deploy' | cut -d' ' -f1)"

  drone deploy $repo $build_num $deploy_target
fi
