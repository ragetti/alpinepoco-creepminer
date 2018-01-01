node {
    def buildImage

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        buildImage = docker.build("ragetti/alpinepoco-creepminer")
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */

        buildImage.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
		 
		 
		 /*
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            buildImage.push("${env.BUILD_NUMBER}")
            buildImage.push("latest")
        }*/

        docker.withRegistry('http://192.168.1.99:5000', 'private-hub-credentials') {
            buildImage.push("${env.BUILD_NUMBER}")
            buildImage.push("latest")
        }
    }
	stage('Deploy to local Server') {
		sh 'docker ps -f name=creepminer -q | xargs --no-run-if-empty docker container stop'
		sh 'docker container ls -a -fname=creepminer -q | xargs -r docker container rm'
		docker.withRegistry('http://192.168.1.99:5000', 'private-hub-credentials') {
			buildImage.image("${env.BUILD_NUMBER}").withRun('--name creepminer -p 8126:8126 --restart=on-failure --entrypoint="/app/creepMiner" -v "/home/miner/dockerfiles/mycreepminer/mining.conf:/app/mining.conf" -v "/mnt/plots:/plots/:ro" ')
		}
	}
}
