  # Terraform
  - create_bucket - праметры для s3 бакета, в которм будет храниться terraform.tfstate от create_infra  (все переменые задаются в файле terraform.tfvars)
  - create_dns - создание зоны DNS для нашего проекта (все переменые задаются в файле terraform.tfvars)
  - create_infra - создание ВМ для разворачивания проекта и выполнение в ней команд по разворачиванию системы CD\CD(зависит от create_bucket и create_dns).



Описание terraform.tfvars
```shell
token  =  "1111aaaa22222bbbb3333cccc" #можно получить по ссылке https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token
cloud_id  = "00000000000000000" #можно получить по ссылке https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id
folder_id = "00000000000000000" #можно получить по ссылке https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id 
SQPWD     = "123456789"  #общий пароль вэб авторизации для сервисов jenkins, sonarqube, grafana
SQPNAME   = "MyProject"  #название проекта по умолчанию для sonarqube(переменная нужна для гененрации токена sonarqube)
SQPKEY    = "mykey"   #ключь по умолчанию для sonarqube(переменная нужна для гененрации токена sonarqube)
GITPROJECT = "git@github.com:kignatovich/tms-dp.git" #ссылка на существующий проекта в github
prpass = "MuYBQgv6jiK0"  #пароль от архива преднастройки ssh ключей ВМ
prpass_url = "https://docs.google.com/uc?export=download&id=1Ga-OAfa4X5tHq0aiedBVOdrGIB9tAPes" #ссылка на заштврованный архив в GC.
prpass_zip = "keyp.zip" #название зашифрованного архива
prpass_file = "prepare.sh" #скрипт установки ssh ключей
login_ghcr = "long.bi4@gmail.com" #логин в ghcr.io 
sname_ghcr = "kignatovich"  #имя юзера в ghcr.io
jenkins_im_ghcr = "jenkins-jcasc:1.2"  #название билда jenkins серврера
tghcr = "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" #api_key от ghcr.io
user_vm = "ubuntu" #пользователь ВМ
d_dns = "devsecops.by."  #имя домена (обязательно с точкой в конце)
dns_a_name = "tms-dp1.devsecops.by." #главная страница проекта (обязательно с точкой в конце)
jenkins_dns_a_name = "jenkins1.devsecops.by." #страница jenkinsa в проекте (обязательно с точкой в конце)
sonar_dns_a_name = "sonarqube1.devsecops.by." #страница sonarqube проекта (обязательно с точкой в конце)
prod_dns_a_name = "prod1.devsecops.by." #страница Prod развертывания проекта (обязательно с точкой в конце)
dev_dns_a_name = "dev1.devsecops.by."  #страница Dev развертывания проекта (обязательно с точкой в конце)
grafana_dns_a_name = "grafana1.devsecops.by." #страница grafana проекта (обязательно с точкой в конце)
prometheus_dns_a_name = "prom1.devsecops.by." #страница prometheus проекта (обязательно с точкой в конце)
cadvisor_dns_a_name = "cad1.devsecops.by."   #страница cadvisor проекта (обязательно с точкой в конце)
static_ip = "51.250.14.123"  #статический адрес проекта
```
