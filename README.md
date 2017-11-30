# lisk-template

[![Build Status](https://jenkins.lisk.io/buildStatus/icon?job=lisk-template/master)](https://jenkins.lisk.io/job/lisk-template/job/master/)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)
<a href="https://david-dm.org/LiskHQ/lisk-template"><img src="https://david-dm.org/LiskHQ/lisk-template.svg" alt="Dependency Status"></a>
<a href="https://david-dm.org/LiskHQ/lisk-template/?type=dev"><img src="https://david-dm.org/LiskHQ/lisk-template/dev-status.svg" alt="devDependency Status"></a>

## Goals of this repository

1. To gather standards, patterns and workflows which we adopt, in order to provide a central source of truth regarding our "current thinking", which can then be applied to individual Lisk projects as and when appropriate.
1. To serve as a base for new projects.

## Usage

When starting a new Lisk project, use this repository as a base. With a few small customisations, you will have a skeleton project up and running in a few minutes. The easiest way to bootstrap a new project is using the `bin/bootstrap.sh` script:

```sh
curl --silent --user my_github_username https://raw.githubusercontent.com/LiskHQ/lisk-template/30-start_script/bin/bootstrap.sh | bash -l -s my-fresh-lisk-project
```

Notes:

- `my_github_username` should be replaced with your GitHub username. You will be prompted for your GitHub password.
- The `-l` option tells bash to act as if it had been invoked as a login shell. If you use [nvm][nvm] as your Node.js version manager, then it will be used to set the correct version of Node.js when installing NPM dependencies.
- `my-fresh-lisk-project` should be replaced with the name you’ve chosen for your new project.

If you would rather complete this process on your own, you should follow these steps:

1. Clone the repository
1. Reinitialise git (by removing the `.git` directory, running `git init` and committing everything into the initial commit)
1. Find and replace all instances of `lisk-template` with your project name (assuming the name of your project is the same as its GitHub namespace)
1. Commit these customisation changes
1. Run `npm install`

More precise steps can be viewed in the `bin/bootstrap.sh` script.

## package.json

You will need to update the project description. Other fields will be given a sensible value but may need to be updated depending on the project.

### devDependencies

Installed for your convenience are the following:

1. [Babel][babel] plus various plugins, presets and tools so you can write modern JavaScript without worrying about compatibility.
1. [Prettier][prettier] for standard code formatting.
1. [Eslint][eslint] plus various configs and plugins, to enforce additional rules beyond Prettier’s remit.
1. [Husky][husky] and [lint-staged][lint-staged] to help with running checks/builds before/after various git/NPM commands.
1. [Mocha][mocha], [Chai][chai] and [Sinon][sinon] plus plugins for tests.
1. [nyc][nyc] and [Coveralls][coveralls] for coverage.

These can be removed as appropriate, along with the corresponding NPM scripts.

### Scripts

- `start` will run your source code using `babel-node`, which is not performant but does not require transpilation.
- `format` will format your source and test code using Prettier.
- `lint` will lint everything relevant with Eslint.
- `test` will run your tests and instrument your code using nyc. (With the initial setup this results in a failing test: the first step in TDD’s red-green-refactor process!)
- `test:watch` will watch for changes and reruns your tests.
- `test:watch:min` will do the same but using the `min` reporter (useful if you just want to check if your changes break a test).
- `cover` will output a coverage report (differs based on the environment).
- `build` will transpile your source code using Babel.
- `precommit` will format staged files and lint everything before you commit.
- `prepush` will lint and test before you push.
- `prepublishOnly` will run the `prepush` checks and the `build` command. **Note: this is run automatically before publishing in NPM v5+ but must be performed manually in NPM 3 (the currently supported NPM version).**

## Documentation for contributors

Several files are especially relevant for contributors:
- `CODE_OF_CONDUCT.md` which should probably be left as it is.
- `CONTRIBUTING.md` which will benefit from project-specific customisation.
- `ISSUE_TEMPLATE.md` which may need to be adapted to your project.
- `LICENSE` which should be left alone unless your project is being released under a different licence. In this case the `license` field of the `package.json` file should be updated as well.

## Project structure

- Source code should go in `src`, test code should go in `test`.
- nyc output goes into `.nyc_output`, and built files are put into a `dist` directory which is created when needed.
- Files you do not want to commit can be placed in `.idea` or `tmp` (you will need to create these directories yourself).

### Testing structure

The test directory has some configuration and setup files, and is otherwise divided into a `specs` directory and a `steps` directory. The intention is for specifications to contain implementation-neutral Mocha suites, and the (reusable) steps to be implemented in the `steps` directory. See [this blogpost][gwt-blogpost] for an introduction.

If this approach does not suit your project the structure can be replaced as necessary. However, the configuration and setup should probably be preserved. Helpful things in place include:

- Combining Babel, nyc and Mocha.
- Adding Chai’s `expect` as a global, and initialising plugins.
- Adding `sinon` and a sinon `sandbox` as globals, and resetting the sandbox after each test in a global hook (it is recommended to use the sandbox wherever possible to avoid manual resets).

## Continuous integration

This project assumes a standard CI setup on Jenkins. There are three Jenkinsfiles:

- `Jenkinsfile` for branches/PRs which lints, tests, reports coverage to Coveralls, and notifies GitHub.
- `Jenkinsfile.private` which checks branches/PRs for known vulnerabilities in the installed dependencies using [Snyk][snyk] if `package.json` has changed. The results should not be publicly viewable in Jenkins.
- `Jenkinsfile.nightly` which checks the `master` branch for vulnerabilities nightly. The results should also not be publicly viewable in Jenkins.

The `.snyk` file configures Snyk.

## Miscellaneous information

- `.editorconfig` can be used in combination with plugins for a wide range of editors/IDEs to ensure consistency of certain key syntax details.
- `.npmignore` ensures that as little as possible is included when published to NPM. This may require adjustment.
- If the project is for a client, or otherwise will not be used as a library in other projects, consider replacing `babel-plugin-transform-runtime` and `babel-runtime` with `babel-polyfill` (see the [details section of the Babel Polyfill documentation](babel-polyfill-details)).

[babel]: https://babeljs.io/
[babel-polyfill-details]: http://babeljs.io/docs/usage/polyfill#details
[chai]: http://chaijs.com/
[coveralls]: https://coveralls.io/
[eslint]: https://eslint.org/
[gwt-blogpost]: https://blog.lisk.io/bdd-style-unit-testing-with-mocha-704137e429d5
[husky]: https://github.com/typicode/husky
[lint-staged]: https://github.com/okonet/lint-staged
[mocha]: http://mochajs.org/
[nvm]: https://github.com/creationix/nvm
[nyc]: https://istanbul.js.org/
[prettier]: https://prettier.io/
[sinon]: http://sinonjs.org/
[snyk]: https://snyk.io/
