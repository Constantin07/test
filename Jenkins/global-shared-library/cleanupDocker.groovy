#!groovy

def call(String nodeName='', int keep_images=1) {

  String docker_image = 'spotify/docker-gc'

  lock("${env.JOB_NAME}-${nodeName}") {
    stage("Cleanup on ${nodeName}") {
      node(nodeName) {

        checkout scm

        def image = docker.image(docker_image)
        image.pull()
        image.withRun("--privileged \
                       --name docker-gc \
                       -e MINIMUM_IMAGES_TO_SAVE=${keep_images} \
                       -e FORCE_IMAGE_REMOVAL=1 \
                       -e GRACE_PERIOD_SECONDS=86400 \
                       -v /var/run/docker.sock:/var/run/docker.sock \
                       -v /etc:/etc:ro"){
                        /* do nothing */
                      }

        sh '''
          docker image prune -a -f
          docker system prune -f --filter "until=48h"
        '''

        cleanWs()
      }
    }
  }
}
