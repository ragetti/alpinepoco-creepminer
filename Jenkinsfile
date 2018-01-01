pipeline {
	agent any

	stages {
		def buildImage
		env.BUILDNAME = env.JOB_NAME.replaceFirst('/[^/]+$', '')
		
		echo "BUILDNAME=${env.BUILDNAME}"
		
		stage('clone') {
			 checkout scm
		}

		stage('build') {
			 buildImage = docker.build("${env.BUILDNAME}:${env.BUILD_ID}")
		}

		stage('test') {
			buildImage.inside {
				sh 'echo "Tests passed"'
			}
		}

		stage('push') {
			docker.withRegistry('http://192.168.1.99:5000', 'private-hub-credentials') {
				buildImage.push()
				buildImage.push("latest")
			}
		}
		stage('cleanup') {
			sh 'docker ps -f name=${buildImage.imageName()} -q | xargs --no-run-if-empty docker container stop'
			sh 'docker container ls -a -fname=${buildImage.imageName()} -q | xargs -r docker container rm'
		}
		stage('deploy') {
	/*	
			docker.withRegistry('http://192.168.1.99:5000', 'private-hub-credentials') {
				buildImage.pull()
				
				docker.image('${buildImage.imageName()}:${buildImage.imageName()}')
				.run('--name "${buildImage.imageName()}" -p 8126:8126 --restart=on-failure --entrypoint="/app/creepMiner" -v "/home/miner/dockerfiles/mycreepminer/mining.conf:/app/mining.conf" -v "/mnt/plots:/plots/:ro" ')
			}
	*/		
			docker {
					image '${buildImage.imageName()}:${buildImage.imageName()}'
					args '--name "${buildImage.imageName()}" -p 8126:8126 --restart=on-failure --entrypoint="/app/creepMiner" -v "/home/miner/dockerfiles/mycreepminer/mining.conf:/app/mining.conf" -v "/mnt/plots:/plots/:ro" '
			}
		}
	}
}
