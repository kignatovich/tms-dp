Контейнер с дженкинсом содержит в себе sonarqube scaner

Билд
```shell
sudo docker build -t jenkins:1.0 .
```
Запуск 
```shell
docker run -d --name jenkins1.0 -p 8081:8080 jenkins:1.0
```


Тестовый пайплайн
```shell
pipeline {
  agent any
  stages {
    stage('Clone repository') {
      steps {
          echo "Clone repository"
          checkout scmGit(branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: 'git_to_jenkins', url: 'git@github.com:kignatovich/myproject-dp.git']])
      }
    }
  
    stage('Ansible --version') {
        steps {
            sh 'git --version'
            echo "Absible version done"
        }
    }  
    
    stage ('bash') {
        steps {
            sh '''#!/bin/bash
                 echo "hello world"
                 '''
        echo "bash version done"
            
        }
    }
    
    
    
    
    stage('Ansible run') {
        steps {
            sh 'git --version'
            echo "Absible playbook run done"
        }
    }  
      
      
}
}
```
