#!/usr/bin/env bash

set -e
set -u

help () {
  echo
  echo '# This will set all required environment variables on the CircleCI project.'
  echo
  echo '# Supply values to set when prompted.'
  echo '# Values left blank will not be updated.'
  echo
  echo 'Values may also be provided via' \
       'the corresponding environment variable (prefixed with CI_).'
  echo 'Optionally, set NONINTERACTIVE=true to skip all prompts.'
  echo
  echo 'For example, assuming CIRCLE_TOKEN is set in your environment,' \
       'update NPM_TOKEN with'
  echo
  echo '    $ NONINTERACTIVE=true CI_NPM_TOKEN=token .circleci/envvars.sh'
}

help_circleci () {
  echo
  echo '> Get a personal CircleCI API Token at' \
       'https://circleci.com/account/api'
}

help_npm_token () {
  echo
  echo '> Use a valid token for the meltwater-mlabs user'
}

help_npm_team () {
  echo
  echo '> Use meltwater:read-only'
}

help_codecov () {
  echo
  echo '> Get the Repository Upload Token at' \
       "https://codecov.io/gh/${circle_repo}/settings"
}

help_heroku () {
  echo
  echo '> Push to Heroku by setting the following environment variables.'
  echo
}

help_bintray () {
  echo
  echo '> Push to Bintray by setting the following environment variables.'
  echo
}

help_bintray_registry () {
  echo '> If unsure, use meltwater-docker-registry'
}

help_bintray_password () {
  echo
  echo '> Your Bintray API key.'
}

help_aws_ecr () {
  echo
  echo '> Push to Amazon ECR by setting the following environment variables.'
  echo
}

help_drone () {
  echo
  echo '> Trigger deploys with Drone by setting the following environment variables.'
}

help_drone_repo () {
  echo
  echo '> Use meltwater/k8s-site-oi'
}

help_drone_server () {
  echo
  echo '> Use https://drone.meltwater.io'
}

help_drone_token () {
  echo
  echo '> Use a valid token for the meltwater-mlabs GitHub user'
}

command -v jq >/dev/null 2>&1 || \
  (echo 'jq required: https://stedolan.github.io/jq/' && exit 2)

envvar () {
  name=$1
  value=${2:-}
  if [[ -n $value ]]; then
    if [[ -z $circle_token ]]; then
      echo
      echo 'Error: missing CircleCI token.'
      exit 2
    fi

    curl -X POST \
      --header 'Content-Type: application/json' \
      -u "${circle_token}:" \
      -d '{"name": "'$name'", "value": "'$value'"}' \
      "https://circleci.com/api/v1.1/project/github/${circle_repo}/envvar"
  fi
}

main () {
  noninteractive=$1
  circle_repo=$(jq -r .repository package.json)

  circle_token=${CIRCLE_TOKEN:-}
  [[ -n "${circle_token}" || $noninteractive == 'true' ]] || help_circleci
  if [[ -z $circle_token && $noninteractive != 'true' ]]; then
    read -p '> CircleCI API token (CIRCLE_TOKEN): ' circle_token
  fi

  npm_token=${CI_NPM_TOKEN:-}
  [[ -n "${npm_token}" || $noninteractive == 'true' ]] || help_npm_token
  if [[ -z $npm_token && $noninteractive != 'true' ]]; then
    read -p '> NPM token (NPM_TOKEN): ' npm_token
  fi

  npm_team=${CI_NPM_TEAM:-}
  [[ -n "${npm_team}" || $noninteractive == 'true' ]] || help_npm_team
  if [[ -z $npm_team && $noninteractive != 'true' ]]; then
    read -p '> NPM team (NPM_TEAM): ' npm_team
  fi

  codecov_token=${CI_CODECOV_TOKEN:-}
  [[ -n "${codecov_token}" || $noninteractive == 'true' ]] || help_codecov
  if [[ -z $codecov_token && $noninteractive != 'true' ]]; then
    read -p '> Codecov token (CODECOV_TOKEN): ' codecov_token
  fi

  [[ $noninteractive == 'true' ]] || help_heroku

  heroku_app=${CI_HEROKU_APP:-}
  if [[ -z $heroku_app && $noninteractive != 'true' ]]; then
    read -p '> Heroku app name (HEROKU_APP): ' heroku_app
  fi

  heroku_token=${CI_HEROKU_TOKEN:-}
  if [[ -z $heroku_token && $noninteractive != 'true' ]]; then
    read -p '> Heroku authentication token (HEROKU_TOKEN): ' heroku_token
  fi

  [[ $noninteractive == 'true' ]] || help_bintray

  bintray_registry=${CI_BINTRAY_REGISTRY:-}
  [[ -n "${bintray_registry}" || $noninteractive == 'true' ]] || help_bintray_registry
  if [[ -z $bintray_registry && $noninteractive != 'true' ]]; then
    read -p '> Bintray registry name (BINTRAY_REGISTRY): ' bintray_registry
  fi

  bintray_repository=${CI_BINTRAY_REPOSITORY:-}
  if [[ -z $bintray_repository && $noninteractive != 'true' ]]; then
    read -p '> Bintray repository name (BINTRAY_REPOSITORY): ' bintray_repository
  fi

  bintray_username=${CI_BINTRAY_USERNAME:-}
  if [[ -z $bintray_username && $noninteractive != 'true' ]]; then
    read -p '> Bintray username (BINTRAY_USERNAME): ' bintray_username
  fi

  bintray_password=${CI_BINTRAY_PASSWORD:-}
  [[ -n "${bintray_password}" || $noninteractive == 'true' ]] || help_bintray_password
  if [[ -z $bintray_password && $noninteractive != 'true' ]]; then
    read -p '> Bintray password (BINTRAY_PASSWORD): ' bintray_password
  fi

  [[ $noninteractive == 'true' ]] || help_aws_ecr

  aws_ecr_repository=${CI_AWS_ECR_REPOSITORY:-}
  if [[ -z $aws_ecr_repository && $noninteractive != 'true' ]]; then
    read -p '> AWS ECR repository (AWS_ECR_REPOSITORY): ' aws_ecr_repository
  fi

  aws_account_id=${CI_AWS_ACCOUNT_ID:-}
  if [[ -z $aws_account_id && $noninteractive != 'true' ]]; then
    read -p '> AWS account id (AWS_ACCOUNT_ID): ' aws_account_id
  fi

  aws_default_region=${CI_AWS_DEFAULT_REGION:-}
  if [[ -z $aws_default_region && $noninteractive != 'true' ]]; then
    read -p '> AWS default region (AWS_DEFAULT_REGION): ' aws_default_region
  fi

  aws_access_key_id=${CI_AWS_ACCESS_KEY_ID:-}
  if [[ -z $aws_access_key_id && $noninteractive != 'true' ]]; then
    read -p '> AWS access key id (AWS_ACCESS_KEY_ID): ' aws_access_key_id
  fi

  aws_secret_access_key=${CI_AWS_SECRET_ACCESS_KEY:-}
  if [[ -z $aws_secret_access_key && $noninteractive != 'true' ]]; then
    read -p '> AWS secret access key (AWS_SECRET_ACCESS_KEY): ' aws_secret_access_key
  fi

  [[ $noninteractive == 'true' ]] || help_drone

  drone_repo=${CI_DRONE_REPO:-}
  [[ -n "${drone_repo}" || $noninteractive == 'true' ]] || help_drone_repo
  if [[ -z $drone_repo && $noninteractive != 'true' ]]; then
    read -p '> Drone deploy repo (DRONE_REPO): ' drone_repo
  fi

  drone_server=${CI_DRONE_SERVER:-}
  [[ -n "${drone_server}" || $noninteractive == 'true' ]] || help_drone_server
  if [[ -z $drone_server && $noninteractive != 'true' ]]; then
    read -p '> Drone server (DRONE_SERVER): ' drone_server
  fi

  drone_token=${CI_DRONE_TOKEN:-}
  [[ -n "${drone_token}" || $noninteractive == 'true' ]] || help_drone_token
  if [[ -z $drone_token && $noninteractive != 'true' ]]; then
    read -p '> Drone token (DRONE_TOKEN): ' drone_token
  fi

  envvar 'NPM_TOKEN' "${npm_token}"
  envvar 'NPM_TEAM' "${npm_team}"
  envvar 'CODECOV_TOKEN' "${codecov_token}"
  envvar 'HEROKU_APP' "${heroku_app}"
  envvar 'HEROKU_TOKEN' "${heroku_token}"
  envvar 'BINTRAY_REGISTRY' "${bintray_registry}"
  envvar 'BINTRAY_REPOSITORY' "${bintray_repository}"
  envvar 'BINTRAY_USERNAME' "${bintray_username}"
  envvar 'BINTRAY_PASSWORD' "${bintray_password}"
  envvar 'AWS_ECR_REPOSITORY' "${aws_ecr_repository}"
  envvar 'AWS_ACCOUNT_ID' "${aws_account_id}"
  envvar 'AWS_DEFAULT_REGION' "${aws_default_region}"
  envvar 'AWS_ACCESS_KEY_ID' "${aws_access_key_id}"
  envvar 'AWS_SECRET_ACCESS_KEY' "${aws_secret_access_key}"
  envvar 'DRONE_REPO' "${drone_repo}"
  envvar 'DRONE_SERVER' "${drone_server}"
  envvar 'DRONE_TOKEN' "${drone_token}"
}

noninteractive=${NONINTERACTIVE:-false}
if [[ $noninteractive != 'true' ]]; then
  help
fi
main $noninteractive
