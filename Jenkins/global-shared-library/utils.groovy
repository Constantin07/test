#!groovy

import jenkins.model.Jenkins

@NonCPS
def setJobDescription(String text) {
  def jobNamePath = env.JOB_NAME.split('/')
  def job = Jenkins.instance.getItem(jobNamePath.last())
  job.description = text
}
