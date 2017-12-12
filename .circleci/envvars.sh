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

  envvar 'NPM_TOKEN' "${npm_token}"
  envvar 'NPM_TEAM' "${npm_team}"
  envvar 'CODECOV_TOKEN' "${codecov_token}"
  envvar 'BINTRAY_REGISTRY' "${bintray_registry}"
  envvar 'BINTRAY_REPOSITORY' "${bintray_repository}"
  envvar 'BINTRAY_USERNAME' "${bintray_username}"
  envvar 'BINTRAY_PASSWORD' "${bintray_password}"
  envvar 'AWS_ECR_REPOSITORY' "${aws_ecr_repository}"
  envvar 'AWS_ACCOUNT_ID' "${aws_account_id}"
  envvar 'AWS_DEFAULT_REGION' "${aws_default_region}"
  envvar 'AWS_ACCESS_KEY_ID' "${aws_access_key_id}"
  envvar 'AWS_SECRET_ACCESS_KEY' "${aws_secret_access_key}"
}

noninteractive=${NONINTERACTIVE:-false}
if [[ $noninteractive != 'true' ]]; then
  help
fi
main $noninteractive
