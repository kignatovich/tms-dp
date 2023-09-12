
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

<img width="729" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/833b45df-1917-4619-98b5-f7ea8429ed4c">


Один из важных скриптов которые отрабатывают в самом началае секции remote-exec - prepare.sh находящийся в шифрованом архиве keyp.zip, который добавляет возможность "читать ВМ" приватные репозитории gitlab. 
```shell
#!/bin/bash
mv  ./id_rsa ./.ssh/
ssh-keyscan github.com >> /home/ubuntu/.ssh/known_hosts
```
После добавления закрытого ключа, remote-exec "стирает" его следы.


## Главная страница
После успешного разворачивания инфраструктуры - будет создана главная страница проекта, доступная по адресу https://tms-dp1.devsecops.by. 

![image](https://github.com/kignatovich/tms-dp/assets/110161538/f64e1850-d4c6-4b8b-97f9-b33b0ccd54e2)


## Описание ресурсов:
- Дженкинс - https://jenkins1.devsecops.by (логин admin пароль из файла конфига terraform по умолчанию 123456789)
- Сонаркьюб - https://sonarqube1.devsecops.by (логин admin пароль из файла конфига terraform по умолчанию 123456789)
- Графана - https://grafana1.devsecops.by логин admin пароль из файла конфига terraform по умолчанию 123456789)
- Prometheus - https://prom1.devsecops.by (basic auth admin:password)
- Cadvisor - https://cad1.devsecops.by (basic auth admin:password)
- Prod - https://prod1.devsecops.by
- DEV - https://dev1.devsecops.by


## Jenkins
![image](https://github.com/kignatovich/tms-dp/assets/110161538/0d0d0885-568c-4851-860b-9ab3b725973e)


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



## Пайплайны запускаются автоматически при пуше в соответствующую ветку репозитория github.

![image](https://github.com/kignatovich/tms-dp/assets/110161538/dd1f3dd8-3966-4fef-9b25-6b7e86f0ade6)



## Отчеты Sonarqube
![image](https://github.com/kignatovich/tms-dp/assets/110161538/1ed98931-2edf-418b-bbe0-a914eed1bd5e)


## Отчеты сканера уязвимостей образов, располагаются по адресу:
https://tms-dp1.devsecops.by/report/
![image](https://github.com/kignatovich/tms-dp/assets/110161538/7645d4a1-d0a5-4c0a-9a89-b470a55f411d)
![image](https://github.com/kignatovich/tms-dp/assets/110161538/962edcec-1a11-4f2b-9442-837aef2af3ca)





## Продакшен версия приложения:
https://prod1.devsecops.by/

<img width="1124" alt="Снимок экрана 2023-08-21 в 17 23 33" src="https://github.com/kignatovich/tms-dp/assets/110161538/f48c1917-0555-4694-bfb9-d731a9c77290">


## Девелопер версия приложения:
https://dev1.devsecops.by/

<img width="1110" alt="Снимок экрана 2023-08-21 в 17 24 15" src="https://github.com/kignatovich/tms-dp/assets/110161538/b1125230-15c8-4b9d-85ad-3d01a012ef93">


## Grafana:
Добавлены дашборды (автоматически разворачиваются):
- docker host (мониторинг хоста на котором установлен docker)
- docker containers (мониторинг докер контейнеров)
- monitoring services (мониторинг мониторинга)
- logs (кастомный вывод логов и алертов)

<img width="1510" alt="Снимок экрана 2023-08-21 в 17 26 14" src="https://github.com/kignatovich/tms-dp/assets/110161538/2e3efc5b-542a-46dd-9428-8e782d65f8ee">

<img width="1509" alt="Снимок экрана 2023-08-21 в 17 26 37" src="https://github.com/kignatovich/tms-dp/assets/110161538/77bda930-379b-4088-a212-8e1338b203e1">

<img width="1502" alt="Снимок экрана 2023-08-21 в 17 27 04" src="https://github.com/kignatovich/tms-dp/assets/110161538/376b8153-309e-4a10-8af6-2fc253e21ad3">

<img width="1510" alt="Снимок экрана 2023-08-21 в 17 28 43" src="https://github.com/kignatovich/tms-dp/assets/110161538/42a2201b-eb31-403f-904f-7d4522b4639b">



## Также, добавлен loki для сборов логов:

<img width="1485" alt="Снимок экрана 2023-08-21 в 17 29 21" src="https://github.com/kignatovich/tms-dp/assets/110161538/0c76dbf1-9e72-4899-b03a-cff41a304659">

<img width="1459" alt="Снимок экрана 2023-08-21 в 17 30 29" src="https://github.com/kignatovich/tms-dp/assets/110161538/21dd927b-b7ec-411b-9b33-37ac60ab8089">


## Alertmanager - отправляет алеры в телеграм.

![image](https://github.com/kignatovich/tms-dp/assets/110161538/a461bff4-02c4-45c3-8b8b-56992a0c9a28)



## github.com packages
<img width="931" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/b7562f8c-2159-44bf-b019-e65c3694a775">

<img width="740" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/0c209461-c994-4ac0-9e33-a94931274a79">

<img width="758" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/03d11824-82e9-464d-8d68-fe042f4abf75">








