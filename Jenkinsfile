pipeline {
    agent any 
    options {
        ansiColor('xterm')
    }
        stages {
            stage('Git Clone and Setup') {
                steps {
                    script {
                        //clone project to jenkins 
                    }
                }
            }

            stage('Build image') {
                steps {
                    script {
                        sh 'docker build -t robot .'
                    }
                }
            }

            stage('Execute Robot') {
                steps {
                    script {
                        sh 'docker run -v ${WORKSPACE}/report:/app/report -t -e TEST_CASE={TEST_CASE_ENV} robot'
                    }
                }
            }
            
            stage('Publish Report') {
                steps {
                     archiveArtifacts artifacts: '.', followSymlinks: false
                }
                   
                }
        }
        post {
            always {
                echo '*************** Stage : Cleanup ***************'
                cleanWs() 
            }
        }
    
}
