## В проекте 2 ветки: main(все для создания среды для разработки: ci\cd, мониторинг и тд) и terraform_bot_bran(телеграмм бот и терраформ)

# Настройка сервисной машины(она отвечает за запуск разворачивания инфраструктуры).
В качестве инфрастуктуры используется Yandex Cloud.
Для начала работы с YC нужно в нем зарегистрироваться, создать организацию и каталог.

## Установка terraform
```shell
wget https://hashicorp-releases.yandexcloud.net/terraform/1.4.6/terraform_1.4.6_linux_amd64.zip
unzip terraform_1.4.6_linux_amd64.zip
mv terraform /usr/local/bin/
```

## Установка бота
```shell
git clone git@github.com:kignatovich/tms-dp.git
cd tms-dp/
git checkout terraform_bot_bran
chmode +x ./telegram_bot/instll_bot.sh
sudo ./telegram_bot/install_bot.sh
```
После запуска данной команды, скрипт установит службу бота и запустит ее. 
Cледующим шагом нужно расшифровать секреты (любые файлы с расширением gpg).
```bash
chmode +x ./telegram_bot/gpg_secret.sh
./telegram_bot/gpg_secret.sh --dec --k tms-dp-private.key ./telegram_bot/terraform/create_infra/terraform.tfvars.gpg
gpg: encrypted with 3072-bit RSA key, ID 3BEFCA1C118FF8DA, created 2023-08-24
      "tms-dp <admin@devsecops.by>"
Файл расшифрован.
```
Шифрование ассиметричное (шифруется публичным ключом, расшифровывается приватным).

После установки бота, нужно зайти в телеграмм и дать боту команду на установку инфраструктуры.
```bash
/deploy
```

У бота сделана авторизация по telegram_id, если вашего id нету в списке разрешенных, при запуске защищенной команды появится сообщение.

<img width="626" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/c8f31e89-0866-4b84-a54a-3f14b71d0e59">


В боте реализовна проерка на наличие файлов для запуска деплоя.
Файлы наличие которых проверяются: providers.tf, terraform.tfvars, variables.tf, "main.tf.


<img width="615" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/905ee2cf-06ff-4f5e-b489-e969b2e66391">
