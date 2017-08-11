#!groovy

node {
    int plan_exitcode
    def git_url = 'git@github.com:Constantin07/test.git'

    // Set path to terraform
    env.PATH = "/usr/local/bin:${env.PATH}"

    properties(
        [buildDiscarder(logRotator(artifactDaysToKeepStr: '', numToKeepStr: '10')),

        [$class: 'GithubProjectProperty',
        projectUrlStr: 'https://github.com/Constantin07/test'],

        pipelineTriggers([pollSCM('H/1 * * * *')]),

        // Allow only one change at a time
        disableConcurrentBuilds()
    ])

    stage('Checkout'){
        checkout([$class: 'GitSCM',
            branches: [[name: '*/master']],
            doGenerateSubmoduleConfigurations: false,
            userRemoteConfigs: [[credentialsId: 'Git', url: git_url]]
        ])
    }

    stage('Get secrets'){
	withEnv(["PATH+git-crypt=/usr/local/bin"]) {
	    sh '''
		env
		git crypt unlock
	    '''
	}
    }

    dir(path: './terraform') {

        stage('Validate') {
            // Remove the terraform state file so we always start from a clean state
            if (fileExists(".terraform/terraform.tfstate")) {
                sh '''rm -rf .terraform/terraform.tfstate'
                      rm -f plan.out'
                      rm -f terraform.tfstate.backup
                '''
            }

            ansiColor('xterm') {
                // Print terraform version
                sh 'terraform --version'

                // Rewrite in cannonical format
                sh 'terraform fmt -list=true -diff=false'

                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                    credentialsId: 'Amazon Credentials']]) {
                    // Initialize S3 backend
                    sh 'terraform init'
                }

                // Syntax validation 
                sh 'terraform validate'
            }
        }

        milestone label: 'Validate'

        stage(name: 'Plan', concurency: 1) {
            ansiColor('xterm') {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Amazon Credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    plan_exitcode = sh(returnStatus: true,
                        script: 'terraform plan -detailed-exitcode -out=plan.out')
                }
                echo "Terraform plan exit code: ${plan_exitcode}"

                if(plan_exitcode == 0) {
                    echo "No changes to apply."
                    currentBuild.result = 'SUCCESS'
                }

                if(plan_exitcode == 1) {
                    // Error (send a message via HipChat)
                    echo "Plan Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
                    currentBuild.result = 'FAILURE'
                }

                if(plan_exitcode == 2) {
                    // Succeeded, there is a diff to apply (send a message via HiChat)
                    stash name: "plan", includes: "plan.out"
                    echo "Plan Awaiting Approval: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
                }
            }
        }

        milestone label: 'Plan'

        if(plan_exitcode == 2) {
            stage(name: 'Apply', concurency: 1) {
                try {
                    input message: 'Please review the plan. Do you want to apply?', ok: 'Apply', submitter: 'admin'

                    unstash 'plan'

                    ansiColor('xterm') {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        credentialsId: 'Amazon Credentials',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                            def apply_exitcode = sh(returnStatus: true, script: 'terraform apply plan.out')
                        }
                    }

                    if(apply_exitcode == 0) {
                        echo "Changes Applied ${env.JOB_NAME} - ${env.BUILD_NUMBER}"    
                    } else {
                        echo "Apply Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
                        currentBuild.result = 'FAILURE'
                    }

                } catch (err) {
                    // Send a message via HipChat
                    echo "Plan Discarded: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
                    currentBuild.result = 'UNSTABLE'
                }
            }
        }
    }
}
