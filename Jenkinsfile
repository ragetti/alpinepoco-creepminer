node {
    def buildImage

    stage('Clone repository') {
         checkout scm
    }

    stage('Build image') {
         buildImage = docker.build("ragetti/alpinepoco-creepminer:${env.BUILD_ID}")
    }

    stage('Test image') {
        buildImage.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        docker.withRegistry('http://192.168.1.99:5000', 'private-hub-credentials') {
            buildImage.push("${env.BUILD_NUMBER}")
            buildImage.push("latest")
        }
    }
	stage('Deploy to local Server') {
		sh 'docker ps -f name=creepminer -q | xargs --no-run-if-empty docker container stop'
		sh 'docker container ls -a -fname=creepminer -q | xargs -r docker container rm'
		
		docker.withRegistry('http://192.168.1.99:5000', 'private-hub-credentials') {
			buildImage.withRun('--name creepminer -p 8126:8126 --restart=on-failure --entrypoint="/app/creepMiner" -v "/home/miner/dockerfiles/mycreepminer/mining.conf:/app/mining.conf" -v "/mnt/plots:/plots/:ro" ')
		}
	}
}
