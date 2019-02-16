#!groovy

def cleanup(String nodeName='') {

  String docker_image = 'spotify/docker-gc'

  stage('Clean old images and containers') {
    node(nodeName) {
       def image = docker.image(docker_image)
       image.pull()

        sh '''
          docker run --rm --privileged \
          --name docker-gc \
          -e MINIMUM_IMAGES_TO_SAVE=1 \
          -e FORCE_IMAGE_REMOVAL=1 \
          -e GRACE_PERIOD_SECONDS=86400 \
          -v /var/run/docker.sock:/var/run/docker.sock \
          -v /etc:/etc:ro \
          ${docker_image}
        '''

        sh 'docker ps --filter "status=exited" -q | xargs -r docker rm'
        sh 'docker volume ls --filter "dangling=true" -q | xargs -r docker volume rm'
    }
  }
}
