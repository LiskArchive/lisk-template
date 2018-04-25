#!/bin/sh

# Exit with error code if no project name was provided
projectname=${1:-}
if [ -z "$projectname" ]; then
	echo 'Usage: bootstrap <project-name>'
	exit 1
fi

# Clone template repository
git clone git@github.com:LiskHQ/lisk-template.git "$projectname"
cd "$projectname"

# Reinitialize git
rm -rf .git
git init
git add .
git commit -m 'Initial commit' -m 'Initialized from lisk-template: https://github.com/LiskHQ/lisk-template'

# Customize project using provided project name
git grep -l lisk-template | xargs sed -i '' "s/lisk-template/$projectname/g"
sed -i '.bak' $'s/\t"version": .*/\t"version": "0.0.0",/' package.json
rm package.json.bak
rm bin/bootstrap.sh
git add .
git commit -m "Customize lisk-template as $projectname"

# Install npm dependencies
test $(command -v nvm) && nvm use 6.14.1
test $(command -v npm) && npm install
