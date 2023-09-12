# Описание модулей

- .nginx.sh - разворачивает nginx хосты, получает SSL сертификаты, формирует главную страницу проекта, добавляет некоторе значения в файлы для будущего билда jenkins, добавляет формат json log для prod и dev окружения. 
- .daemon.json - файл для службы docker, добавляющя отправку логов в prometheus 
- /contrib - темплейты для гереации отчетов Trivy. Синтаксис запуска и генерации отчета в html:
```bash
sudo trivy image --scanners vuln --format template --template "@./tms-dp/infra/contrib/html.tpl" -o /var/www/tms-dp1.devsecops.by/link/report.html IMAGE_NAME(OR ID)
```
- /jenkins - файлы для билда jenkins контейнера
- /loki - файлы конфигурации для запуска контейнера loki и promtail
- /monitoring -файлы для запуска контейров отвечающих за мониторинг:
  - alertmanager - отправка сообщений
  - caddy(можно было его не использовать, но хотелось попробовать) - прокси сервер
  - grafana (дашборды и датасурсы)
  - prometheus
- /nginx (EXAMPLE файлы для виртуальных хостов, главной страницы), использует скрипт nginx.sh
- /sonarqube - описание и тестовые записи для рабоыт sonarqube (в проекте используется частично)
