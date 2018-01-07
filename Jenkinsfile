node {
    def buildImage
	env.BUILDNAME = env.JOB_NAME.replaceFirst('/[^/]+$','')
	
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
            buildImage.push("${env.BUILD_NUMBER}")
            buildImage.push("latest")
        }		
    }
	
	stage('cleanup') {
		sh 'docker ps -f name=${buildImage.imageName()} -q | xargs --no-run-if-empty docker container stop'
		sh 'docker container ls -a -fname=${buildImage.imageName()} -q | xargs -r docker container rm'
	}
	
	stage('deploy') {
		sh 'docker stack deploy -c /home/miner/dockerservices/creepminer/docker-compose.yml mining'
	}

}
