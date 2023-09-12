// Create CI - DEV pipeline
pipelineJob("CI - DEV pipeline") {
    definition {
        cps {
            sandbox(true)
            script("""
def buildNumber = env.BUILD_NUMBER
pipeline {
    agent any
    stages {
        stage('Clone repository') {
            steps {
                echo "Clone repository"
                checkout scmGit(branches: [[name: 'dev']], extensions: [], userRemoteConfigs: [[credentialsId: 'git_to_jenkins', url: 'git@github.com:kignatovich/myproject-dp.git']])
            }
        }
        
        stage('Checkov scanner') {
            steps {
                script {
                    try {
                        sh 'checkov -d . --framework dockerfile'
                    } catch (Exception e) {
                        echo "Caught exception: \${e.message}"
                    }
                }
            }
        }
        
        stage('Code style') {
            steps {
                script {
                    try {
                        sh 'pylint Ink/'
                    } catch (Exception e) {
                        echo "Caught exception: \${e.message}"
                    }
                }
            }
        }
        
        stage('Sonar-scanner') {
            steps {
                script {
                    def sonarProjectName = "dev-\${buildNumber}"
                    def sonarProjectKey = "mykeydev\${buildNumber}"
                    sh "sonar-scanner -D sonar.token=\\\$(cat /opt/sonarscanner/token) -D sonar.projectKey=\${sonarProjectKey} -D sonar.projectName=\${sonarProjectName}"
                }
            }
        }
        
        stage('Deploy project') {
            steps {
                script {
                    sh "/opt/ansible/ansible_dev.sh 'BN=\${buildNumber}'"
                    sh "echo Deploying project with build number \${buildNumber}"
                }
            }
        }
        
        stage('code 200 & page search') {
            steps {
                script {
                    sh "/var/jenkins_home/200.sh \\\$(cat /var/jenkins_home/dev_url) 'Developer :- Abhinav Sharma'"
                }
            }
        }
        
        stage('Apache benchmark test') {
            steps {
                script {
                    sh "/var/jenkins_home/ab.sh \\\$(cat /var/jenkins_home/dev_url)/"
                }
            }
        }
    }
    
    post {
        success {
            sh "/var/jenkins_home/telegram.sh 'Сборка DEV была успешно выполнена!'"
        }
        
        aborted {
            sh "/var/jenkins_home/telegram.sh 'Сборка DEV была прервана!'"
        }
        
        failure {
            sh "/var/jenkins_home/telegram.sh 'Ошибка во время выполнения сборки DEV!'"
        }
    }
}
""")
    }
}

}

// Create CI - PROD pipeline
pipelineJob("CI - PROD pipeline") {
    definition {
        cps {
            sandbox(true)
            script("""
def buildNumber = env.BUILD_NUMBER
pipeline {
    agent any
    stages {
        stage('Clone repository') {
            steps {
                echo "Clone repository"
                checkout scmGit(branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: 'git_to_jenkins', url: 'git@github.com:kignatovich/myproject-dp.git']])
            }
        }
        
        stage('Checkov scanner') {
            steps {
                script {
                    try {
                        sh 'checkov -d . --framework dockerfile'
                    } catch (Exception e) {
                        echo "Caught exception: \${e.message}"
                    }
                }
            }
        }
        
        stage('Code style') {
            steps {
                script {
                    try {
                        sh 'pylint Ink/'
                    } catch (Exception e) {
                        echo "Caught exception: \${e.message}"
                    }
                }
            }
        }
        
        stage('Sonar-scanner') {
            steps {
                script {
                    def sonarProjectName = "main-\${buildNumber}"
                    def sonarProjectKey = "mykeydev\${buildNumber}"
                    sh "sonar-scanner -D sonar.token=\\\$(cat /opt/sonarscanner/token) -D sonar.projectKey=\${sonarProjectKey} -D sonar.projectName=\${sonarProjectName}"
                }
            }
        }
        
        stage('Deploy project') {
            steps {
                script {
                    sh "/opt/ansible/ansible_main.sh 'BN=\${buildNumber}'"
                    sh "echo Deploying project with build number \${buildNumber}"
                }
            }
        }
        
        stage('code 200 & page search') {
            steps {
                script {
                    sh "/var/jenkins_home/200.sh \\\$(cat /var/jenkins_home/prod_url) 'Developer :- Abhinav Sharma'"
                }
            }
        }
        
        stage('Apache benchmark test') {
            steps {
                script {
                    sh "/var/jenkins_home/ab.sh \\\$(cat /var/jenkins_home/prod_url)/"
                }
            }
        }
    }
    
    post {
        success {
            sh "/var/jenkins_home/telegram.sh 'Сборка PROD была успешно выполнена!'"
        }
        
        aborted {
            sh "/var/jenkins_home/telegram.sh 'Сборка PROD была прервана!'"
        }
        
        failure {
            sh "/var/jenkins_home/telegram.sh 'Ошибка во время выполнения сборки PROD!'"
        }
    }
}
""")
    }
}

}
