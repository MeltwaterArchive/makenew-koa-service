#!/usr/bin/env sh

set -e
set -u

find_replace () {
  git grep --cached -Il '' | xargs sed -i.sedbak -e "$1"
  find . -name "*.sedbak" -exec rm {} \;
}

sed_insert () {
  sed -i.sedbak -e "$2\\"$'\n'"$3"$'\n' $1
  rm $1.sedbak
}

sed_delete () {
  sed -i.sedbak -e "$2" $1
  rm $1.sedbak
}

check_env () {
  test -d .git || (echo 'This is not a Git repository. Exiting.' && exit 1)
  for cmd in ${1}; do
    command -v ${cmd} >/dev/null 2>&1 || \
      (echo "Could not find '$cmd' which is required to continue." && exit 2)
  done
  echo
  echo 'Ready to bootstrap your new project!'
  echo
}

stage_env () {
  echo
  echo 'Removing origin and tags.'
  git tag | xargs git tag -d
  git branch --unset-upstream
  git remote rm origin
  echo
  git rm -f makenew.sh
  echo
  echo 'Staging changes.'
  git add --all
  echo
  echo 'Done!'
  echo
}

help_bintray () {
  echo
  echo "For example, if the Bintray page for the project is"
  echo
  echo "  https://bintray.com/meltwater/mlabs-registry/my-service"
  echo
  echo "the registry name is 'mlabs-registry'" \
       "and the repository name is 'my-service'."
  echo
}

help_circleci () {
  repo=$1
  url_edit="https://circleci.com/gh/${repo}/edit"
  url_api="${url_edit}#api"
  echo
  echo "1. Go to ${url_edit}"
  echo '2. Follow the project'
  echo "3. Go to ${url_api}"
  echo '4. Create a new token with scope "Status" and name "badge"'
  echo '5. Copy and paste it below'
  echo
}

help_codecov () {
  repo=$1
  url_settings="https://codecov.io/gh/${repo}/settings"
  echo
  echo "1. Go to ${url_settings}"
  echo '2. Copy and paste the Repository Graphing Token below'
  echo
}

makenew () {
  echo 'Answer all prompts.'
  echo 'There are no defaults: examples shown in parentheses.'
  echo
  read -p '> Package title (My Package): ' mk_title
  read -p '> Package name (my-package): ' mk_slug
  read -p '> Short package description (Foos and bars.): ' mk_description
  read -p '> Author name (Linus Torvalds): ' mk_author
  read -p '> Author email (linus@example.com): ' mk_email
  read -p '> GitHub repository name (my-repo): ' mk_repo
  help_bintray
  read -p '> Bintray registry name (mlabs-registry): ' mk_bintray_registry
  read -p '> Bintray repository name (my-repository): ' mk_bintray_repo
  help_circleci "meltwater/${mk_repo}"
  read -p '> CircleCI status token: ' mk_circleci
  help_codecov "meltwater/${mk_repo}"
  read -p '> Codecov status token: ' mk_codecov

  sed_delete README.md '11,145d'
  sed_insert README.md '11i' "${mk_description}"

  find_replace "s/\"version\": \".*\"/\"version\": \"0.0.0\"/g"
  find_replace "s/0\.0\.0\.\.\./0.0.1.../g"
  find_replace "s/Node\.js Koa Microservice Skeleton/${mk_title}/g"
  find_replace "s/Koa skeleton for Meltwater Node\.js microservices\./${mk_description}/g"
  find_replace "s/Evan Sosenko/${mk_author}/g"
  find_replace "s/evan.sosenko@meltwater\.com/${mk_email}/g"
  find_replace "s/meltwater-docker-registry\.bintray\.io\/makenew-koa-service/meltwater-docker-${mk_bintray_registry}.bintray.io\/${mk_bintray_repo}/g"
  find_replace "s/registry\/makenew-koa-service/${mk_bintray_registry}\/${mk_bintray_repo}/g"
  find_replace "s/@meltwater\/makenew-koa-service/@meltwater\/${mk_slug}/g"
  find_replace "s/meltwater\/makenew-koa-service/meltwater\/${mk_repo}/g"
  find_replace "s/makenew-koa-service/${mk_repo}/g"
  find_replace "s/makenew--koa--service/$(echo ${mk_slug} | sed 's/-/--/g')/g"
  find_replace "s/e53ca6f402372b0142f6748a90670a4295f4b8d8/${mk_circleci}/g"
  find_replace "s/VFHOFyfAmt/${mk_codecov}/g"

  echo
  echo 'Replacing boilerplate.'
}

check_env 'git read sed xargs'
makenew
stage_env
exit
