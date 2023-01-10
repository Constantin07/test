#!groovy

import org.jenkinsci.plugins.workflow.steps.FlowInterruptedException

def call(String nodeName = '', String directory = '.') {

  // Global state
  boolean needUpdate = false
  boolean apply      = false

  // Used for locks
  String jobName = "${env.JOB_NAME}"

  node(nodeName) {

    properties([
      durabilityHint('MAX_SURVIVABILITY'),
      buildDiscarder(logRotator(artifactDaysToKeepStr: '', numToKeepStr: '10')),
      // Allow only one job at a time
      disableConcurrentBuilds(),
    ])

    // Set path to terraform
    //env.PATH = "/usr/local/bin:${env.PATH}"
    def tfHome = tool(name: 'Terraform', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool')
    env.PATH = "${tfHome}:${env.PATH}"

    ansiColor('xterm') {

      stage('Checkout') {
        checkout(scm)
        milestone label: 'Checkout'
      }

      stage('Unlock secrets') {
        sh 'git crypt unlock'
        milestone label: 'Unlock secrets'
      }

      // Terraform AWS credentials wrapper
      withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'Amazon Credentials',
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]])
      {

        dir(path: directory) {

          stage("Validate") {
            println "Print terraform version"
            sh 'terraform -version'

            println "Remove the .terraform directory"
            dir('.terraform') {
              deleteDir()
            }

            println "Ensure we always start from a clean state"
            sh 'rm -f plan.out terraform.tfstate.backup'

            println "Initialise configuration"
            retry(2) {
              echo 'Initialize S3 backend'
              sh "terraform init -upgrade=true -input=false"
            }

            println "Syntax validation"
            sh 'terraform validate'
            milestone label: 'Validate'
          }
        }

        // Needs to be run after terraform init to scan modules too
        stage('Static code analysis') {
          docker.image('bridgecrew/checkov:latest').inside("--entrypoint=''") {
            sh "checkov -d ${directory} -o cli -o junitxml --output-file-path console,results.xml"
            junit skipPublishingChecks: true, testResults: 'results.xml'
          }
          milestone label: 'Static code analysis'
        }

        stage('Run TFLint') {
          //docker.image('ghcr.io/terraform-linters/tflint-bundle:latest').inside("--entrypoint=''") {
            //sh "export TFLINT_LOG=debug; tflint --chdir=${directory}/"
          //}
          sh "docker run --rm -v " + pwd() + ":/data -t ghcr.io/terraform-linters/tflint-bundle --chdir=/data/${directory}/"
          milestone label: 'TFLint'
        }

        dir(path: directory) {

          lock("${jobName}") {
              stage(name: 'Plan') {
                def exitCode = sh(script: "terraform plan -input=false -out=plan.out -detailed-exitcode", returnStatus: true)
                echo "Terraform plan exit code: ${exitCode}"
                switch (exitCode) {
                  case 0:
                    echo 'No changes to apply.'
                    currentBuild.result = 'SUCCESS'
                    cleanWs()
                    break
                  case 1:
                    echo 'Plan Failed.'
                    currentBuild.result = 'FAILURE'
                    cleanWs()
                    break
                  case 2:
                    echo 'Plan Awaiting Approval.'
                    needUpdate = true
                    stash(name: 'plan', includes: 'plan.out,.terraform/**')
                    break
                }
              milestone label: 'Plan'
            }
          }

          if (needUpdate) {
            println "Send a notification here"
          }

        } // withCredentials
      }  //dir
    } //ansiColor
  } //node

  if (needUpdate) {
    try {
      timeout(time: 60, activity: false, unit: 'MINUTES') {
        stage('Approve') {
          input(message: 'Please review the plan. Do you want to apply?', ok: 'Apply', submitter: 'admin')
          apply = true
        }
      }
    } catch (FlowInterruptedException e) {
      currentBuild.result = 'ABORTED'
      return
    } catch (e) {
      apply = false
    }

    milestone label: 'Approve'

    if (apply) {
      lock("${jobName}") {
        node(nodeName) {
          ansiColor('xterm') {
            dir(path: directory) {

              // Terraform AWS credentials wrapper
              withCredentials([[
                  $class: 'AmazonWebServicesCredentialsBinding',
                  credentialsId: 'Amazon Credentials',
                  accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                  secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]])
              {
               // Apply stage
               // - Execute `terraform apply` against the stashed plan
                stage(name: 'Apply') {
                  unstash 'plan'
                  def exitCode = sh(script: "terraform apply -input=false -auto-approve plan.out", returnStatus: true)
                  if (exitCode == 0) {
                    echo 'Changes Applied.'
                    currentBuild.result = 'SUCCESS'
                  } else {
                    echo 'Apply Failed.'
                    currentBuild.result = 'FAILURE'
                  }

                  cleanWs()
                  milestone label: 'Apply'
                }
              } //withCredentials
            } //dir
          } //ansiColour
        } //node
      } //lock
    }

  milestone label: 'Done'

  }
}
