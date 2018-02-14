
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

def build(nodeName = '') {

    // Global state
    def needUpdate = false
    def apply = false
    def comment = ''

    node(nodeName) {

        properties(
            [
                buildDiscarder(logRotator(artifactDaysToKeepStr: '', numToKeepStr: '30')),

                pipelineTriggers([pollSCM('''TZ=Europe/London
                * * * * *''')]),

                // Allow only one job at a time
                disableConcurrentBuilds(),
            ]
        )

        // Set path to terraform
        env.PATH = "/usr/local/bin:${env.PATH}"
        //def tfHome = tool(name: 'Terraform', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool')
        //env.PATH = "${tfHome}:${env.PATH}"

        wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {

                stage('Checkout') {
                    checkout([$class: 'GitSCM',
                        branches: [[name: '*/master']],
                        doGenerateSubmoduleConfigurations: false,
                        userRemoteConfigs: [[credentialsId: 'Git']]
                    ])

                    // Add comment to build description
                    comment = get_comment()
                    currentBuild.description = comment

                    sh 'git crypt unlock'
                }

                milestone label: 'Checkout'

            dir(path: "./terraform/${environment}") {

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
                    stage("Validate - ${environment}") {
                        //Print terraform version
                        sh 'terraform --version'

                        // Remove the .terraform directory
                        dir('.terraform') {
                            deleteDir()
                        }

                        // initialise configuration
                        retry(3) {
                            sh 'terraform init -get=true -force-copy'
                        }

                        //Load modules if any
                        sh 'terraform get -update=true'

                        //Syntax validation
                        sh 'terraform validate'
                    }

                    milestone label: 'Validate'

                    stage(name: "Plan - ${environment}") {
                        def exitCode = sh(script: "terraform plan -out=plan.out -detailed-exitcode", returnStatus: true)
                        switch (exitCode) {
                            case 0:
                                currentBuild.result = 'SUCCESS'
                                break
                            case 1:
                                currentBuild.result = 'FAILURE'
                                break
                            case 2:
                                needUpdate = true
                                stash(name: 'plan', includes: 'plan.out')
                                break
                        }
                    }
                }

                milestone label: 'Plan'

                if (needUpdate) {
                    withCredentials([
                        [
                            $class: 'UsernamePasswordMultiBinding',
                            credentialsId: 'Hipchat',
                            usernameVariable: 'HIPCHAT_USERNAME',
                            passwordVariable: 'HIPCHAT_APIKEY'
                        ]
                    ]) {
                            def msg_template = "${env.JOB_NAME} #${env.BUILD_NUMBER} needs user confirmation \
                                                (<a href='${env.BUILD_URL}/console'>Console</a> / \
                                                <a href='${env.BUILD_URL}/flowGraphTable'>Steps</a> / \
                                                <a href='${env.RUN_DISPLAY_URL}/'>Pipeline</a>), Change: " + comment
                            hipchatSend(
                                color: 'PURPLE',
                                message: msg_template,
                                room: 'Platform Engineering',
                                server: 'api.hipchat.com',
                                sendAs: "${env.HIPCHAT_USERNAME}",
                                token: "${env.HIPCHAT_APIKEY}",
                                v2enabled: true
                            )
                        }
                }
            }
        }
    } // node

    if (needUpdate) {
        try {
            input(message: 'Apply Plan?', ok: 'Apply')
            apply = true
        } catch (err) {
            apply = false
        }

        milestone label: 'User input'

        if (apply) {
            node(nodeName) {
                wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
                    dir(path: "./terraform/${environment}") {

                        // Terraform AWS credentials wrapper
                        withCredentials([
                            [
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: 'Terraform',
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                            ]
                        ])
                        {
                            // Apply stage
                            // - unstash plan.out
                            // - Execute `terraform apply` against the stashed plan
                            stage("Apply - ${environment}") {
                                unstash 'plan'

                                def exitCode = sh(script: 'terraform apply plan.out', returnStatus: true)
                                if (exitCode == 0) {
                                    currentBuild.result = 'SUCCESS'
                                } else {
                                    currentBuild.result = 'FAILURE'
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
