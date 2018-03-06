
// Get comment of last commit
def get_comment() {
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

def build(nodeName = '', directory = '.') {

    // Global state
    def needUpdate = false
    def apply = false
    def comment = ''

    node(nodeName) {

        properties(
            [
                buildDiscarder(logRotator(artifactDaysToKeepStr: '', numToKeepStr: '30')),
                pipelineTriggers([githubPush(), pollSCM("TZ=Europe/London\n* * * * *")]),
                // Allow only one job at a time
                disableConcurrentBuilds(),
            ]
        )

        // Set path to terraform
        env.PATH = "/usr/local/bin:${env.PATH}"
        //def tfHome = tool(name: 'Terraform', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool')
        //env.PATH = "${tfHome}:${env.PATH}"

        ansiColor('xterm') {

            stage('Checkout') {
                checkout(scm)

                // Add comment to build description
                comment = get_comment()
                currentBuild.description = comment
            }

            milestone label: 'Checkout'

            stage('Unlock secrets'){
                sh 'git crypt unlock'
            }

            milestone label: 'Unlock secrets'

            dir(path: directory) {

                // Terraform AWS credentials wrapper
                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'Amazon Credentials',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]
                ])
                {
                    timestamps {
                        stage("Validate") {
                            //Print terraform version
                            sh 'terraform --version'

                            // Remove the .terraform directory
                            dir('.terraform') {
                                deleteDir()
                            }

                            // Ensure we always start from a clean state
                            sh '''
                                rm -f plan.out
                                rm -f terraform.tfstate.backup
                            '''

                            // initialise configuration
                            retry(3) {
                                echo 'Initialize S3 backend'
                                sh 'terraform init -get=true -force-copy'
                            }

                            //Load modules if any
                            retry(3) {
                                sh 'terraform get -update=true'
                            }

                            //Syntax validation
                            sh 'terraform validate'
                        }
                    }

                    milestone label: 'Validate'

                    timestamps {
                        stage(name: 'Plan', concurency: 1) {
                            def exitCode = sh(script: "terraform plan -out=plan.out -detailed-exitcode", returnStatus: true)
                            echo "Terraform plan exit code: ${exitCode}"
                            switch (exitCode) {
                                case 0:
                                    echo 'No changes to apply.'
                                    currentBuild.result = 'SUCCESS'
                                    break
                                case 1:
                                    echo 'Plan Failed.'
                                    currentBuild.result = 'FAILURE'
                                    break
                                case 2:
                                    echo 'Plan Awaiting Approval.'
                                    needUpdate = true
                                    stash(name: 'plan', includes: 'plan.out')
                                    break
                            }
                        }
                    }

                    milestone label: 'Plan'

                    if (needUpdate) {
                        println 'Send a notification here'
                    }
                }
            }
        }
    }

    if (needUpdate) {
        try {
            input(message: 'Please review the plan. Do you want to apply?', ok: 'Apply', submitter: 'admin')
            apply = true
        } catch (err) {
            apply = false
        }

        milestone label: 'User input'

        if (apply) {
            node(nodeName) {
                ansiColor('xterm') {
                    dir(path: directory) {

                        // Terraform AWS credentials wrapper
                        withCredentials([
                            [
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: 'Amazon Credentials',
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                            ]
                        ])
                        {
                            timestamps {
                                // Apply stage
                                // - unstash plan.out
                                // - Execute `terraform apply` against the stashed plan
                                stage(name: 'Apply', concurency: 1) {
                                    unstash 'plan'
                                    def exitCode = sh(script: 'terraform apply -auto-approve plan.out', returnStatus: true)
                                    if (exitCode == 0) {
                                        echo 'Changes Applied.'
                                        currentBuild.result = 'SUCCESS'
                                    } else {
                                        echo 'Apply Failed.'
                                        currentBuild.result = 'FAILURE'
                                    }
                                }
                            }
                        }
                    }
                }

                milestone label: 'Apply'
            }
        }

        milestone label: 'Done'

    }
}

return this;
