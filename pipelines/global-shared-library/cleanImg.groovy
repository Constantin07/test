#!groovy

/* Clean img images */

def call() {
  withEnv(['PATH+img=/usr/local/bin']) {
    sh "img ls | tail -n +2 | cut -f1 | xargs -r -I % sh -c '{ img rm %; sleep 1; }'"
  }
}
