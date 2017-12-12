pipeline {
	agent { node { label 'lisk-template' } }
	stages {
		stage('Install dependencies') {
			steps {
				sh 'npm install --verbose'
			}
		}
		stage('Run lint') {
			steps {
				ansiColor('xterm') {
					sh 'npm run lint'
				}
			}
		}
		stage('Build') {
			steps {
				sh 'npm run build'
			}
		}
		stage('Run tests') {
			steps {
				ansiColor('xterm') {
					sh 'npm run test'
					sh '''
					cp ~/.coveralls.yml-lisk-template .coveralls.yml
					npm run cover
					'''
				}
			}
		}
	}
	post {
		success {
			githubNotify context: 'continuous-integration/jenkins/lisk-template', description: 'The build passed.', status: 'SUCCESS'
		}
		failure {
			githubNotify context: 'continuous-integration/jenkins/lisk-template', description: 'The build failed.', status: 'FAILURE'
		}
		aborted {
			githubNotify context: 'continuous-integration/jenkins/lisk-template', description: 'The build was aborted.', status: 'ERROR'
		}
	}
}
