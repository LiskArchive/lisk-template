# lisk-template

[![Build Status](https://jenkins.lisk.io/buildStatus/icon?job=lisk-template/master)](https://jenkins.lisk.io/job/lisk-template/job/master/)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)
<a href="https://david-dm.org/LiskHQ/lisk-template"><img src="https://david-dm.org/LiskHQ/lisk-template.svg" alt="Dependency Status"></a>
<a href="https://david-dm.org/LiskHQ/lisk-template/?type=dev"><img src="https://david-dm.org/LiskHQ/lisk-template/dev-status.svg" alt="devDependency Status"></a>

## Goals of this repository

1. To gather standards, patterns and workflows which we adopt, in order to provide a central source of truth regarding our “current thinking”, which can then be applied to individual Lisk projects as and when appropriate.
1. To serve as a base for new projects.

## Usage

When starting a new Lisk project, use this repository as a base. With a few small customizations, you will have a skeleton project up and running in a few minutes. The easiest way to bootstrap a new project is using the `bin/bootstrap.sh` script:

```sh
curl --silent --user my_github_username "https://raw.githubusercontent.com/LiskHQ/lisk-template/master/bin/bootstrap.sh" | bash -ls my-fresh-lisk-project
```

If you have two-factor authentication enabled on your GitHub account, you will need to generate an access token rather than authenticating via curl. Having logged into GitHub using a browser, view [the bootstrap script][bootstrap-script] in the same browser. Click "Raw" to view the raw file. Then copy the full URL (including the access token) and run the following:

```sh
curl --silent "the_url_i_just_copied?token=remember_the_token" | bash -ls my-fresh-lisk-project
```

Notes:

- `my_github_username` in the first command should be replaced with your GitHub username. You will be prompted for your GitHub password.
- **Watch out**: some terminal applications automatically escape pasted strings, which may conflict with the quoting used in the examples above. If you get a 404 error and you've authenticated successfully with GitHub, check to see if the URL has escape characters which should be removed.
- The `-l` option tells bash to act as if it had been invoked as a login shell. If you use [nvm][nvm] as your Node.js version manager, then it will be used to set the correct version of Node.js when installing NPM dependencies.
- `my-fresh-lisk-project` should be replaced with the name you’ve chosen for your new project.

If you would rather complete this process on your own, you should follow these steps:

1. Clone the repository.
1. Reinitialise git (by removing the `.git` directory, running `git init` and committing everything into the initial commit).
1. Find and replace all instances of `lisk-template` with your project name (assuming the name of your project is the same as its GitHub namespace).
1. Commit these customization changes.
1. Run `npm install`.

More precise steps can be viewed in the `bin/bootstrap.sh` script.

## package.json

You will need to update the project description. Other fields will be given a sensible value but may need to be updated depending on the project.

### devDependencies

Installed for your convenience are the following:

1. [Babel][babel] plus various plugins, presets and tools so you can write modern JavaScript without worrying about compatibility.
1. [Prettier][prettier] for standard code formatting.
1. [ESLint][eslint] plus various configs and plugins, to enforce additional rules beyond Prettier’s remit.
1. [Husky][husky] and [lint-staged][lint-staged] to help with running checks/builds before/after various git/NPM commands.
1. [Mocha][mocha], [Chai][chai] and [Sinon][sinon] plus plugins for tests.
1. [nyc][nyc] and [Coveralls][coveralls] for coverage.

These can be removed as appropriate, along with the corresponding NPM scripts.

### Scripts

- `start` will run your source code using `babel-node`, which is not performant but does not require transpilation.
- `format` will format your source and test code using Prettier.
- `lint` will lint everything relevant with ESLint.
- `test` will run your tests and instrument your code using nyc. (With the initial setup this results in a failing test: the first step in TDD’s red-green-refactor process!)
- `test:watch` will watch for changes and rerun your tests.
- `test:watch:min` will do the same but using the `min` reporter (useful if you just want to check if your changes break a test).
- `cover` will output a coverage report (differs based on the environment).
- `build` will transpile your source code using Babel.
- `precommit` will format staged files and lint everything before you commit.
- `prepush` will lint and test before you push.
- `prepublishOnly` will run the `prepush` checks and the `build` command. **Note: this is run automatically before publishing in NPM v5+ but must be performed manually in NPM 3 (the currently supported NPM version).**

## Documentation for contributors

Several files especially relevant for contributors can be found in the `docs` directory:
- `CODE_OF_CONDUCT.md` which should probably be left as it is.
- `CONTRIBUTING.md` which will benefit from project-specific customization.
- `ISSUE_TEMPLATE.md` and `PULL_REQUEST_TEMPLATE.md` which may need to be adapted to your project.
- Additionally, in the root of the project is the `LICENSE` file, which should be left alone unless your project is being released under a different license. In this case the `license` field of the `package.json` file should be updated as well.

## Project structure

- Source code should go in `src`, test code should go in `test`.
- File and directory names should be `underscore_separated` for best cross-file system compatibility. (I.e. not in camel case etc.)
- nyc output goes into `.nyc_output`, and built files are put into a `dist` directory which is created when needed.
- Files you do not want to commit can be placed in `.idea` or `tmp` (you will need to create these directories yourself).

### Testing structure

The test directory has some configuration and setup files, and is otherwise divided into a `specs` directory and a `steps` directory. The intention is for specifications to contain implementation-neutral Mocha suites, and the (reusable) steps to be implemented in the `steps` directory. See [this blogpost][gwt-blogpost] for an introduction.

If this approach does not suit your project the structure can be replaced as necessary. However, the configuration and setup should probably be preserved. Helpful things in place include:

- Combining Babel, nyc and Mocha.
- Adding Chai’s `expect` as a global, and initialising plugins.
- Adding `Given`, `When` and `Then` from [mocha-bdd][mocha-bdd] as globals.
- Adding `sinon` and a sinon `sandbox` as globals, and resetting the sandbox after each test in a global hook (it is recommended to use the sandbox wherever possible to avoid manual resets).

## Continuous integration

This project assumes a standard CI setup on Jenkins. There are three Jenkinsfiles:

- `Jenkinsfile` for branches/PRs which lints, tests, reports coverage to Coveralls, and notifies GitHub.
- `Jenkinsfile.private` which checks branches/PRs for known vulnerabilities in the installed dependencies using [Snyk][snyk] if `package.json` has changed. The results should not be publicly viewable in Jenkins.
- `Jenkinsfile.nightly` which checks the `master` branch for vulnerabilities nightly. The results should also not be publicly viewable in Jenkins.

The `.snyk` file configures Snyk.

In order to set up continuous integration for your project you will need to do the following:
1. Modify the main Jenkinsfile to your requirements.
1. Update your GitHub project settings to allow Jenkins to submit information.
1. Set up the main Jenkins project, the private project, and the private nightly project in the `nightly-builds` folder.
1. Add a Coveralls configuration file at `~/.coveralls.yml-lisk-template` on all Jenkins nodes that will be used to build lisk-template.

## Miscellaneous information

- `.editorconfig` can be used in combination with plugins for a wide range of editors/IDEs to ensure consistency of certain key syntax details.
- `.npmignore` ensures that as little as possible is included when published to NPM. This may require adjustment.
- If the project is for a client, or otherwise will not be used as a library in other projects, consider replacing `babel-plugin-transform-runtime` and `babel-runtime` with `babel-polyfill` (see the [details section of the Babel Polyfill documentation](babel-polyfill-details)).
- The official language for all Lisk projects is US English (although we may also support translations into other languages on a per-project basis).

## Contributors

https://github.com/LiskHQ/lisk-template/graphs/contributors

## License

Copyright © 2017 Lisk Foundation

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the [GNU General Public License][license] along with this program.  If not, see <http://www.gnu.org/licenses/>.


[babel]: https://babeljs.io/
[babel-polyfill-details]: http://babeljs.io/docs/usage/polyfill#details
[bootstrap-script]: https://github.com/LiskHQ/lisk-template/blob/master/bin/bootstrap.sh
[chai]: http://chaijs.com/
[coveralls]: https://coveralls.io/
[eslint]: https://eslint.org/
[gwt-blogpost]: https://blog.lisk.io/bdd-style-unit-testing-with-mocha-704137e429d5
[husky]: https://github.com/typicode/husky
[license]: https://github.com/LiskHQ/lisk-template/tree/master/LICENSE
[lint-staged]: https://github.com/okonet/lint-staged
[mocha]: http://mochajs.org/
[mocha-bdd]: https://github.com/LiskHQ/mocha-bdd
[nvm]: https://github.com/creationix/nvm
[nyc]: https://istanbul.js.org/
[prettier]: https://prettier.io/
[sinon]: http://sinonjs.org/
[snyk]: https://snyk.io/
