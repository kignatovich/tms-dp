Контейнер с дженкинсом содержит в себе sonarqube scaner

Билд
```shell
sudo docker build -t jenkins:1.0 .
```
Запуск 
```shell
docker run -d --name jenkins1.0 -p 8081:8080 jenkins:1.0
```

