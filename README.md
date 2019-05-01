# Node.js Koa Microservice Skeleton

[![npm](https://img.shields.io/badge/npm-%40meltwater%2Fmakenew--koa--service-blue.svg)](https://www.npmjs.com/package/@meltwater/makenew-koa-service)
[![Bintray](https://img.shields.io/badge/bintray-docker-blue.svg)](https://bintray.com/meltwater/registry/makenew-koa-service)
[![GitHub](https://img.shields.io/badge/github-repo-blue.svg)](https://github.com/meltwater/makenew-koa-service)
[![Codecov](https://img.shields.io/codecov/c/token/VFHOFyfAmt/github/meltwater/makenew-koa-service.svg)](https://codecov.io/gh/meltwater/makenew-koa-service)
[![CircleCI](https://circleci.com/gh/meltwater/makenew-koa-service.svg?style=shield&circle-token=e53ca6f402372b0142f6748a90670a4295f4b8d8)](https://circleci.com/gh/meltwater/makenew-koa-service)

Bootstrap a new [Node.js] [Koa] microservice in five minutes or less.

[Koa]: https://koajs.com/
[Node.js]: https://nodejs.org/

### Features

- [Node.js]'s [npm] package structure.
- Fast, reliable, and secure dependency management with [Yarn].
- [Alpine Linux] based multi-stage [Docker] builds for optimized production images.
- Images tagged using package version and commit checksum.
- Images pushed to [Heroku], [Bintray] and the [Amazon EC2 Container Registry (ECR)].
- Configurable application lifecycle and middleware suite with [mlabs-koa].
- Standardized JSON logging with [mlabs-logger].
- Hierarchical application configuration with [confit].
- Centralized dependency injection with [Awilix].
- Health monitoring with [mlabs-health].
- Next generation JavaScript with [Babel].
- Write debuggable examples with configurable options and arguments.
- Linting with the [JavaScript Standard Style] and [JSON Lint].
- Automatically lint on changes with [gulp].
- Futuristic debuggable unit testing with [AVA].
- Code coverage reporting with [Istanbul], [nyc], and [Codecov].
- Continuous unit and smoke testing and deployment with [CircleCI].
- Profiling with [0x].
- [Keep a CHANGELOG].
- Consistent coding with [EditorConfig].
- Badges from [Shields.io].

[0x]: https://github.com/davidmarkclements/0x
[AVA]: https://github.com/avajs/ava
[Alpine Linux]: https://alpinelinux.org/
[Amazon EC2 Container Registry (ECR)]: https://aws.amazon.com/ecr/
[Awilix]: https://github.com/jeffijoe/awilix
[Babel]: https://babeljs.io/
[Bintray]: https://bintray.com/
[Heroku]: https://www.heroku.com/
[CircleCI]: https://circleci.com/
[Codecov]: https://codecov.io/
[Docker]: https://www.docker.com/
[EditorConfig]: https://editorconfig.org/
[Istanbul]: https://istanbul.js.org/
[JSON Lint]: https://github.com/zaach/jsonlint
[JavaScript Standard Style]: https://standardjs.com/
[Keep a CHANGELOG]: https://keepachangelog.com/
[Node.js]: https://nodejs.org/
[Shields.io]: https://shields.io/
[Yarn]: https://yarnpkg.com/
[confit]: https://github.com/krakenjs/confit
[gulp]: https://gulpjs.com/
[mlabs-health]: https://github.com/meltwater/mlabs-health
[mlabs-koa]: https://github.com/meltwater/mlabs-koa
[mlabs-logger]: https://github.com/meltwater/mlabs-logger
[npm]: https://www.npmjs.com/
[nyc]: https://github.com/istanbuljs/nyc

### License

This repository is released into the public domain through [CC0].
The other copyright notices for this project
are for the purpose of demonstrating the licensing of derived projects.

To the extent possible under law, the person who associated CC0
with this work has waived all copyright and related
or neighboring rights to this work.

[CC0]: https://creativecommons.org/share-your-work/public-domain/cc0/

### Bootstrapping a new project

1. Clone the master branch of this repository with

   ```
   $ git clone --single-branch git@github.com:meltwater/makenew-koa-service.git <new-koa-service>
   $ cd <new-koa-service>
   ```

   Optionally, reset to the latest version with

   ```
   $ git reset --hard <version-tag>
   ```

2. Create an empty (**non-initialized**) repository on GitHub.

3. Run

   ```
   $ ./makenew.sh
   ```

   This will replace the boilerplate, delete itself,
   remove the git remote, remove upstream tags,
   and stage changes for commit.

4. Create the required CircleCI environment variables with

   ```
   $ .circleci/envvars.sh
   ```

5. Review, commit, and push the changes to GitHub with

   ```
   $ git diff --cached
   $ git commit -m "Replace makenew boilerplate"
   $ git remote add origin git@github.com:meltwater/<new-koa-service>.git
   $ git push -u origin master
   ```

6. Ensure the CircleCI build passes,
   then publish the initial version of the package with

   ```
   $ nvm install
   $ yarn
   $ npm version patch
   ```

7. Update the GitHub branch protection options for `master`
   to require all status checks to pass.
   Disable the GitHub repository projects and wiki options (unless desired).
   Add any required GitHub teams or collaborators to the repository.
   Enable GitHub data services for dependency analysis.
   Enable Codecov.

### Updating from this skeleton

If you want to pull in future updates from this skeleton,
you can fetch and merge in changes from this repository.

Add this as a new remote with

```
$ git remote add upstream git@github.com:meltwater/makenew-koa-service.git
```

You can then fetch and merge changes with

```
$ git fetch --no-tags upstream
$ git merge upstream/master
```

#### Changelog for this skeleton

Note that `CHANGELOG.md` is just a template for this skeleton.
The actual changes for this project are documented in the commit history
and summarized under [Releases].

[Releases]: https://github.com/meltwater/makenew-koa-service/releases

## Description

TODO

## Usage

### Docker container

The service is distributed as a Docker container on Bintray and ECR.

To run locally, for example, authenticate with Bintray,
add local configuration to `config/local.json`,
then pull and run the image with

```
$ docker run --read-only --init --publish 80:8080 \
  --volume "$(pwd)/config/local.json:/usr/src/app/config/local.json" \
  meltwater-docker-registry.bintray.io/makenew-koa-service
```

### Configuration

All available configuration options and their defaults are
defined in `config/default.json`.
Additionally, all configuration options
provided by [mlabs-koa][mlabs-koa config] are supported.

#### Config files

Configuration is loaded using [confit]
and available in `lib/dependencies.js` via `confit.get('foo:bar')`.
All static configuration is defined under `config`
and dynamic configuration in `server/config.js`.

The files `config/env.json` and `config/local.json`,
and the paths `config/env.d` and `config/local.d`
are excluded from version control.
The load order is `env.d/*.json`, `env.json`, `local.d/*.json`, and `local.json`.
Hidden files (dotfiles) are ignored.
In development, use these for local overrides and secrets.
In production, mount these inside the container to inject configuration.

#### Secrets

The (whitespace-trimmed) contents of each file in `config/secret.d` is
added to the config under the property `secret`
with a key equal to the filename.
Filenames should not contain a `.` and
hidden files (dotfiles) are ignored.

For example, to use the secret in `config/secret.d/foobar`,
reference it from another property like

```json
{
  "api": {
    "key": "config:secret.foobar"
  }
}
```

#### Environment variables

File-based configuration should always be preferred over environment variables,
however all environment variables are loaded into the config.

The only officially supported environment variables are
`LOG_ENV`, `LOG_SYSTEM`, `LOG_SERVICE`, and `LOG_LEVEL`.

[confit]: https://github.com/krakenjs/confit
[mlabs-koa config]: https://github.com/meltwater/mlabs-koa/tree/master/docs#config-and-middleware

## Development Quickstart

```
$ git clone https://github.com/meltwater/makenew-koa-service.git
$ cd makenew-koa-service
$ nvm install
$ yarn
```

Run each command below in a separate terminal window:

```
$ yarn run watch
$ yarn run test:watch
$ yarn run server:watch
```

## Development and Testing

### Source code

The [makenew-koa-service source] is hosted on GitHub.
Clone the project with

```
$ git clone git@github.com:meltwater/makenew-koa-service.git
```

[makenew-koa-service source]: https://github.com/meltwater/makenew-koa-service

### Requirements

You will need [Node.js] with [npm], [Yarn],
and a [Node.js debugging] client.

Be sure that all commands run under the correct Node version, e.g.,
if using [nvm], install the correct version with

```
$ nvm install
```

Set the active version for each shell session with

```
$ nvm use
```

Install the development dependencies with

```
$ yarn
```

[Node.js]: https://nodejs.org/
[Node.js debugging]: https://nodejs.org/en/docs/guides/debugging-getting-started/
[npm]: https://www.npmjs.com/
[nvm]: https://github.com/creationix/nvm
[Yarn]: https://yarnpkg.com/

#### CircleCI

_CircleCI should already be configured: this section is for reference only._

The following environment variables must be set on [CircleCI].
These may be set manually or by running the script `./circleci/envvars.sh`.

##### npm

- `NPM_TOKEN`: npm token for installing and publishing packages.
- `NPM_TEAM`: npm team to grant read-only package access
  (format `org:team`, optional).

##### Codecov

If set, [CircleCI] will send code coverage reports to [Codecov].

- `CODECOV_TOKEN`: Codecov token for uploading coverage reports.

##### Heroku

If set, [CircleCI] will deploy images built from master directly to [Heroku].

- `HEROKU_APP`: Heroku application name.
- `HEROKU_TOKEN`: Heroku authentication token.

##### Bintray

If set, [CircleCI] will build, tag, and push images to [Bintray].

- `BINTRAY_REGISTRY`: Bintray registry name.
- `BINTRAY_REPOSITORY`: Bintray repository name.
- `BINTRAY_USERNAME`: Bintray username.
- `BINTRAY_PASSWORD`: Bintray password (your API key).

##### Amazon EC2 Container Registry (ECR)

If set, [CircleCI] will build, tag, and push images to [Amazon ECR].

- `AWS_ECR_REPOSITORY`: Amazon ECR repository name.
- `AWS_ACCOUNT_ID`: Amazon account ID.
- `AWS_DEFAULT_REGION`: AWS region.
- `AWS_ACCESS_KEY_ID`: AWS access key ID.
- `AWS_SECRET_ACCESS_KEY`: AWS secret access key.

[Amazon ECR]: https://aws.amazon.com/ecr/
[Bintray]: https://bintray.com/
[CircleCI]: https://circleci.com/
[Codecov]: https://codecov.io/
[Heroku]: https://www.heroku.com/

### Development tasks

Primary development tasks are defined under `scripts` in `package.json`
and available via `yarn run`.
View them with

```
$ yarn run
```

#### Production build

Lint, test, and transpile the production build to `dist` with

```
$ yarn run dist
```

##### Publishing a new release

Release a new version using [`npm version`][npm version].
This will run all tests, update the version number,
create and push a tagged commit,
trigger CircleCI to publish the new version to npm,
and build and push a tagged container to all configured registries.

- **Update the CHANGELOG before each new release after version 1.**
- New versions are released when the commit message is a valid version number.
- Versions are only published on release branches:
  `master` branch or any branch matching `ver/*`.
- If branch protection options are enabled,
  you must first run `npm version` on a separate branch,
  wait for the commit to pass any required checks,
  then merge and push the changes to a release branch.
- **Do not use the GitHub pull request button to merge version commits**
  as the commit tagged with the new version number will not match after merging.

[npm version]: https://docs.npmjs.com/cli/version

#### Server

Run the server locally with

```
$ yarn run server
```

Run a server that will restart on changes with

```
$ yarn run server:watch
```

##### Development logging

Logging output may be configured according to the
[`log` config](https://github.com/meltwater/mlabs-koa/tree/master/docs#log)
and [koa `logger` config](https://github.com/meltwater/mlabs-koa/tree/master/docs#logger).

- Use `koa.logger.useDev` to toggle between the simple Koa development logger
  and the more verbose Koa production logger.
- Use `log.outputMode` and `log.filter` to control log output.
  Override using `LOG_OUTPUT_MODE` and `LOG_FILTER`.
- Define additional log filters in `server/filters.js`.

For example, this config will provide more verbose logging while
hiding all lifecycle events:

```json
{
  "log": {
    "level": "debug",
    "filter": "noLifecycle",
    "outputMode": "long"
  },
  "koa": {
    "logger": {
      "useDev": false
    }
  }
}
```

##### Debugging the server

Start a debuggable server with

```
$ yarn run server:inspect
```

Run a debuggable server that will restart on changes with

```
$ yarn run server:inspect:watch
```

#### Examples

**See the [full documentation on using examples](./examples).**

View all examples with

```
$ yarn run example
```

#### Linting

Linting against the [JavaScript Standard Style] and [JSON Lint]
is handled by [gulp].

View available commands with

```
$ yarn run gulp --tasks
```

Run all linters with

```
$ yarn run lint
```

In a separate window, use gulp to watch for changes
and lint JavaScript and JSON files with

```
$ yarn run watch
```

Automatically fix most JavaScript formatting errors with

```
$ yarn run format
```

[gulp]: https://gulpjs.com/
[JavaScript Standard Style]: https://standardjs.com/
[JSON Lint]: https://github.com/zaach/jsonlint

#### Tests

Unit and integration testing is handled by [AVA]
and coverage is reported by [Istanbul] and uploaded to [Codecov].

- Test files end in `.spec.js`.
- Unit tests are placed under `lib` alongside the tested module.
- Integration tests are placed in `test`.
- Smoke tests are placed in `test` and end in `.test.js`.
- Static files used in tests are placed in `fixtures`.

Watch and run tests on changes with

```
$ yarn run test:watch
```

If using [AVA snapshot testing], update snapshots with

```
$ yarn run test:update
```

Generate a coverage report with

```
$ yarn run report
```

An HTML version will be saved in `coverage`.

##### Debugging tests

Create a breakpoint by adding the statement `debugger` to the test
and start a debug session with, e.g.,

```
$ yarn run test:inspect test/server.spec.js
```

Watch and restart the debugging session on changes with

```
$ yarn run test:inspect:watch test/server.spec.js
```

##### Smoke tests

Smoke tests make network requests directly against the service
(running with `NODE_ENV=test`).
On CircleCI, the tests run against the built container.

To run smoke tests locally, start a test server with

```
$ yarn run server:test
```

and run the tests with

```
$ yarn run test:smoke
```

or update the test snapshots with

```
$ yarn run test:smoke:update
```

Refer to the full list of scripts for additional watch and debug modes.

[AVA]: https://github.com/avajs/ava
[AVA snapshot testing]: https://github.com/avajs/ava#snapshot-testing
[Codecov]: https://codecov.io/
[Istanbul]: https://istanbul.js.org/

### Docker

The production Docker image is built on CircleCI from `.circleci/Dockerfile`:
this Dockerfile can only be used with the CircleCI workflow.

In rare cases, building an equivalent container locally may be useful.
First, export a valid `NPM_TOKEN` in your environment,
then build and run this local container with

```
$ docker build --build-arg=NPM_TOKEN=$NPM_TOKEN -t makenew-koa-service .
$ docker run --read-only --init --publish 80:8080 makenew-koa-service
```

## Contributing

The author and active contributors may be found in `package.json`,

```
$ jq .author < package.json
$ jq .contributors < package.json
```

To submit a patch:

1. Request repository access by submitting a new issue.
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Make changes and write tests.
4. Commit your changes (`git commit -am 'Add some feature'`).
5. Push to the branch (`git push origin my-new-feature`).
6. Create a new Pull Request.

## License

This service is Copyright (c) 2016-2019 Meltwater Group.

## Warranty

This software is provided by the copyright holders and contributors "as is" and
any express or implied warranties, including, but not limited to, the implied
warranties of merchantability and fitness for a particular purpose are
disclaimed. In no event shall the copyright holder or contributors be liable for
any direct, indirect, incidental, special, exemplary, or consequential damages
(including, but not limited to, procurement of substitute goods or services;
loss of use, data, or profits; or business interruption) however caused and on
any theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use of this
software, even if advised of the possibility of such damage.
