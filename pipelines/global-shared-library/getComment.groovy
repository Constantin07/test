#!groovy

/* Get comment of the last commit */

def call() {
  def f = 'last_commit.txt'
  def status = sh(returnStatus: true, script: "git log -1 --pretty=%B > ${f}")
  if (status != 0) {
    currentBuild.result = 'FAILED'
    error "Failed to read last commit's comment"
  } else {
    return readFile(f).trim()
  }
  sh "rm ${f}"
}
