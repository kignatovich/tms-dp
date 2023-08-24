#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ "$1" == "--create" ]; then
    # Создание пары ключей
    gpg --gen-key
    echo "Ключи созданы."

elif [ "$1" == "--export" ]; then
   #Экспорт ключей
   echo "Введите ID ключа"
   read user_input
   gpg --export -a "$user_input" > $user_input-public.key
   gpg --export-secret-key -a "$user_input" > $user_input-private.key

elif [ "$1" == "--import" ]; then
   #Импорт ключей
   echo "Введите ID ключа"
   read user_input
   gpg --import $user_input-public.key
   gpg --import $user_input-private.key

elif [ "$1" == "--enc" ]; then
       if [ "$2" == "--k" ]; then
        public_key="$3"
        input_file="$4"
        # Шифрование файла с помощью публичного ключа
        gpg --encrypt --recipient-file "$public_key" --output "${input_file}.gpg" "$input_file"
        echo "Файл зашифрован."

    else
        echo "Использование: script.sh --enc --k public.key /path/to/file"
    fi

elif [ "$1" == "--dec" ]; then
    if [ "$2" == "--k" ]; then
        private_key="$3"
        encrypted_file="$4"

        # Расшифровка файла с помощью приватного ключа
       gpg --decrypt-files "$encrypted_file" > "${encrypted_file%.gpg}_decrypted"
        echo "Файл расшифрован."

    else
        echo "Использование: script.sh --dec --k private.key /path/to/file"
    fi

else
    echo "Использование: "
    echo "script.sh --create"
    echo "script.sh --enc --k public.key /path/to/file"
    echo "script.sh --dec --k private.key /path/to/file"
    echo "script.sh --export //И введите ID ключа"
    echo "script.sh --import //И введите ID ключа"
fi
