
## Реализация Infrastructure as Code для дипломного проекта.

## Состав проекта: 
## - https://github.com/kignatovich/tms-dp - все для создания среды для разработки: ci\cd, мониторинг и тд;
## - https://github.com/kignatovich/tms-dp-bot - телеграмм бот и терраформ;
## - https://github.com/kignatovich/myproject-dp - приложение.


Используемые технологии/программы/утилиты/яп:
- Docker (Docker-compose)
- Jenkins(IAC)
- SonarQube
- Python (bot)
- Groovy (pipeline) готов тестовый пайплайн, нужно переделать в "боевой".
- Bash
- Nginx + SSL (certbot)
- Prometheus
- Loki
- Grafana
- caDvisor
- Ansible
- Pylint (можно заменить на flake8) 
- Apache Benchmark (нагрузочное тестирвоание)
- Telegram (notification). Alertmanager - алерты готовы, остались в пайплайне jenkins.  
- Checkov - сканирование файлов на наличие ошибок в конфигурации(terraform, Dockerfile и т.д.)
- trivy - сканирование образов docker
- gpg ([скрипт](https://github.com/kignatovich/tms-dp/blob/main/infra/gpg_secret.sh))

ВАЖНО: на данный момент все разворачивается автоматическ при использовании только одной команды. Единственное исключение - webhook. Его в jenkins нужно включать в пайплайнах вручную.
  

[Ссылка на приложение](https://github.com/kignatovich/myproject-dp), который будет учавствовать в сборке.

## Начало работы.
При запуске команды в боте телеграм (/deploy), выполняется комнада terraform apply. В это время автоматически разворачиваются sqnarqube, jenkins и сопутсвующие сервисы/скрипты.
Вывод команды terraform apply.

<img width="795" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/39f4e54e-698e-4009-ace8-b88f73f7103f">

Один из важных скриптов которые отрабатывают в самом началае секции remote-exec - prepare.sh находящийся в шифрованом архиве keyp.zip, который добавляет возможность "читать ВМ" приватные репозитории gitlab. 
```shell
#!/bin/bash
mv  ./id_rsa ./.ssh/
ssh-keyscan github.com >> /home/ubuntu/.ssh/known_hosts
```
После добавления закрытого ключа, remote-exec "стирает" его следы.


## Главная страница
После успешного разворачивания инфраструктуры - будет создана главная страница проекта, доступная по адресу https://tms-dp1.devsecops.by. 

![image](https://github.com/kignatovich/tms-dp/assets/110161538/7988f229-c14d-42c6-8a6f-e64028c3778c)

## Описание ресурсов:
- Дженкинс - https://jenkins1.devsecops.by (логин admin пароль из файла конфига terraform по умолчанию 123456789)
- Сонаркьюб - https://sonarqube1.devsecops.by (логин admin пароль из файла конфига terraform по умолчанию 123456789)
- Графана - https://grafana1.devsecops.by логин admin пароль из файла конфига terraform по умолчанию 123456789)
- Prometheus - https://prom1.devsecops.by (basic auth admin:password)
- Cadvisor - https://cad1.devsecops.by (basic auth admin:password)
- Prod - https://prod1.devsecops.by
- DEV - https://dev1.devsecops.by


## Jenkins
<img width="1436" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/1920c0c6-66a9-45d4-bcf8-692739599167">

После деплоя инфраструктуры в дженкинсе появляются два пайплайна: один для ветки main, второй для ветки dev.

## Шаги пайплайнов:
- Clone repository - клонируем код из репозитория(main или dev)
- Checkov scaner - проверка правильности написания Dockerfile (может сканировать yaml, tf и т.д.)
- Code style используется pylint
- Sonar-scanner - сканирование с помощью sonarqube (каждый запуск отдельяная запись)
- Deploy project - деплой c помощью ansible на другой сервер(клонирование репозитория, билд проекта, проверка сканером уязвимости билда проекта, запуск проекта)
- code 200 & page search - тест ответа сервера 200 и поиск по главной странице определнного текста
- Apache benchmark test - нагрузочный тест main или dev среды
- Declarative: Post Actions уведомления, реализованы через [телеграмм скрипт](https://github.com/kignatovich/tms-dp/blob/main/infra/jenkins/telegram.sh). 

<img width="627" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/6440c8dc-576e-4839-bcdc-e1168b420894">
<img width="629" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/d6d04ac2-0483-4aef-addd-0f071a621fcd">
<img width="632" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/6948f850-f925-4e15-85e5-0bfa7df27dcc">


## Пайплайны запускаются автоматически при пуше в соответствующую ветку репозитория github.

<img width="1442" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/a7590e56-39d5-44cd-9069-4ee46ef1cf26">

<img width="1450" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/cff087a3-6636-47bd-a916-35f481c47bdf">

## Отчеты Sonarqube
<img width="1418" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/b83c5933-dbfb-4f8a-9436-5baf69ed1a7f">

## Отчеты сканера уязвимостей образов, располагаются по адресу:
https://tms-dp1.devsecops.by/report/
<img width="1115" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/31532521-8b27-4d3d-b277-9643e4a64010">
<img width="1439" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/d062da7f-729e-4fe8-ac8e-a9d953306ae0">



## Продакшен версия приложения:
https://prod1.devsecops.by/
<img width="1124" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/71b9c6fc-4fd6-45da-9830-2985798f4465">

## Девелопер версия приложения:
https://dev1.devsecops.by/
<img width="1110" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/4cfde587-b926-4132-8dd6-53a3073798c3">


## Grafana:
Добавлены дашборды (автоматически разворачиваются):
- docker host (мониторинг хоста на котором установлен docker)
- docker containers (мониторинг докер контейнеров)
- monitoring services (мониторинг мониторинга)
- logs (кастомный вывод логов и алертов)

<img width="1434" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/c3a91a14-4e14-4f40-af4e-cd3bac353fd2">


<img width="1509" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/b37f8ff1-7611-412d-bfdd-23dc80d16bb3">


<img width="1502" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/343ea0f8-8dc4-4df0-b7e3-7bc69111af0b">


<img width="1508" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/ac643ed8-2bce-4074-aeee-1617d0ea7850">


<img width="1510" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/037569b0-dc16-47bf-85bf-60940d00b903">


## Также, добавлен loki для сборов логов:

<img width="1485" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/e99163a9-7b9e-45e1-9659-a15727dec0f1">

<img width="1459" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/db0604d0-f809-42ba-83f2-5e89a1a214c3">

<img width="1158" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/1e729979-0c97-4c42-9b8a-b1eef5d5a7d2">


## Alertmanager - отправляет алеры в телеграм.

<img width="616" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/cf52204f-c552-47e6-833d-f241fabf8cb4">


## github.com packages
![image](https://github.com/kignatovich/tms-dp/assets/110161538/3f232096-d803-45a1-a249-256d5c338f6d)
![image](https://github.com/kignatovich/tms-dp/assets/110161538/ef129e64-1252-49bd-b2d8-2051aba9e9fb)
![image](https://github.com/kignatovich/tms-dp/assets/110161538/0878327e-c5f3-44fd-aa1e-e4f21b5cec27)





