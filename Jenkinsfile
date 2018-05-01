def get_build_info() {
	pr_branch = ''
	if (env.CHANGE_BRANCH != null) {
		pr_branch = " (${env.CHANGE_BRANCH})"
	}
	build_info = "#${env.BUILD_NUMBER} of <${env.BUILD_URL}|${env.JOB_NAME}>${pr_branch}"
	return build_info
}

def slack_send(color, message) {
	/* Slack channel names are limited to 21 characters */
	CHANNEL_MAX_LEN = 21

	channel = "${env.JOB_NAME}".tokenize('/')[0]
	channel = channel.replace('lisk-', 'lisk-ci-')
	if ( channel.size() > CHANNEL_MAX_LEN ) {
		 channel = channel.substring(0, CHANNEL_MAX_LEN)
	}

	echo "[slack_send] channel: ${channel} "
	slackSend color: "${color}", message: "${message}", channel: "${channel}"
}

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
		stage('Deploy') {
			steps {
				error('No deployment process specified. Depending on your project you may prefer to remove this stage entirely.')
			}
		}
	}
	post {
		success {
			script {
				if (currentBuild.result == null || currentBuild.result == 'SUCCESS') {
					previous_build = currentBuild.getPreviousBuild()
					if (previous_build != null && previous_build.result == 'FAILURE') {
						build_info = get_build_info()
						slack_send('good', "Recovery: build ${build_info} was successful.")
					}
				}

			}
			githubNotify context: 'continuous-integration/jenkins/lisk-template', description: 'The build passed.', status: 'SUCCESS'
		}
		failure {
			script {
				build_info = get_build_info()
				slack_send('danger', "Build ${build_info} failed (<${env.BUILD_URL}/console|console>, <${env.BUILD_URL}/changes|changes>)\n")

			}
			githubNotify context: 'continuous-integration/jenkins/lisk-template', description: 'The build failed.', status: 'FAILURE'
		}
		aborted {
			githubNotify context: 'continuous-integration/jenkins/lisk-template', description: 'The build was aborted.', status: 'ERROR'
		}
		always {
			archiveArtifacts allowEmptyArchive: true, artifacts: 'logs/*'
		}
	}
}
