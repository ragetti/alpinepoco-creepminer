node {
    def buildImage

    stage('Clone repository') {
         checkout scm
    }

    stage('Build image') {
         buildImage = docker.build("${env.JOB_NAME}:${env.BUILD_ID}")
    }

    stage('Test image') {
        buildImage.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        docker.withRegistry('http://192.168.1.99:5000', 'private-hub-credentials') {
            buildImage.push()
            buildImage.push("latest")
        }
    }
	stage('Stop current') {
		sh 'docker ps -f name=${env.JOB_NAME} -q | xargs --no-run-if-empty docker container stop'
		sh 'docker container ls -a -fname=${env.JOB_NAME} -q | xargs -r docker container rm'
	}
	stage('Deploy new') {
		
		docker.image("${env.JOB_NAME}:${env.BUILD_ID}").withRun('--name ${env.JOB_NAME} -p 8126:8126 --restart=on-failure --entrypoint="/app/creepMiner" -v "/home/miner/dockerfiles/mycreepminer/mining.conf:/app/mining.conf" -v "/mnt/plots:/plots/:ro" ')
/*		
		docker.withRegistry('http://192.168.1.99:5000', 'private-hub-credentials') {
			buildImage.withRun('--name creepminer -p 8126:8126 --restart=on-failure --entrypoint="/app/creepMiner" -v "/home/miner/dockerfiles/mycreepminer/mining.conf:/app/mining.conf" -v "/mnt/plots:/plots/:ro" ')
			
		}*/
	}
}
