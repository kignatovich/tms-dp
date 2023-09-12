## Описание файлов для билда контейнера Jenkins.


- 200.sh - скрипт для тестирования ответа от сайта, принимает две переемнные: имя ресурса (без протокола) и текст для поиска. Пример:

```bash
./200.sh google.com 'google'
```
- ab.sh - скрипт для запуска apache benchmark, принимает переменную имя ресурса (без протокола). Пример:

```bash
./ab.sh google.com
```

- telegram.sh - скрипт отправки сообщений в канал. Может передавть как сообщения так и файлы. Пример

```bash
./telegram.sh 'hello word' #отправка сообщения
./telegram.sh /path/to/file #отправка файла
```
- plugins.txt - плагины для jenkins
- id_rsa - используется в jenkins-casc.yaml для доступа к репозиторию github
- sonar-scanner.properties - файл настройки подключения к серверу sonarqube (в файле есть примеры)
- seedjob.groovy - пайплайны jenkins.
- Dockerfile - файл бля билда образа jenkins.
- jenkins-casc.yaml - файл настройки jenkins (учетные записи, webhook, доступы и т.д.)
- /ansible - каталог с ansible


Билд образа дженкинса
```shell
sudo docker build -t jenkins:1.0 .
```
Запуск контейнера с нужной версией образа
```shell
docker run -d --name jenkins1.0 -p 8080:8080 jenkins:1.0
```


Тестовый пайплайн
```shell
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
  
    stage('Checkov scaner') {
        steps {
            sh "checkov -d . --framework dockerfile"

        }
    }  
    
    stage ('Code style') {
        steps {
           sh "pylint Ink/"
        echo 'HI'    
        }
    }
    
//    stage('Code style') {
//    steps {
//        script {
//            try {
//                sh "pylint Ink/"
//            } catch (Exception e) {
//                echo "Caught exception: ${e.message}"
//            }
//        }
//    }
//}
    
    
    
    
    stage('Sonar-scanner') {
    steps {
        script {
            def sonarProjectName = "main-${buildNumber}"
            def sonarProjectKey = "mykey${buildNumber}"
            sh "sonar-scanner -D sonar.token=\$(cat /opt/sonarscanner/token) -D sonar.projectKey=${sonarProjectKey} -D sonar.projectName=${sonarProjectName}"
        }
    }
    }  
      
      
    stage('Deploy project') {
        steps {
            script {
              sh "/opt/ansible/ansible_main.sh 'BN=${buildNumber}'"
              sh "echo Deploying project with build number ${buildNumber}"
        }
        }
    }
    
    stage('code 200 & page search') {
        steps {
            script {
              sh "/var/jenkins_home/200.sh \$(cat /var/jenkins_home/prod_url) 'Developer :- Abhinav Sharma'"
        }
        }
    } 
    
    stage('Apache benchmark test') {
        steps {
            script {
              sh "/var/jenkins_home/ab.sh \$(cat /var/jenkins_home/prod_url)/"
        }
        }
    } 
    
      
}
    post {
        success {
                sh  "/var/jenkins_home/telegram.sh 'Сборка была успешно выполнена!'"
            
        }
            
        
        aborted {
                sh  "/var/jenkins_home/telegram.sh 'Сборка была прервана!'"
            
        }
        
        failure {
                sh "/var/jenkins_home/telegram.sh 'Ошибка во время выполнения сборки!'"
            
        }
    }

}
```
