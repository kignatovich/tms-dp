import subprocess
from telegram import Update
from telegram.ext import ApplicationBuilder, CommandHandler, ContextTypes
import os
from functools import wraps

#PROJECT_DIR = os.getcwd()
#PROJECT_DIR = "/home/dp/dp_project/infra/"
PROJECT_DIR = "/Users/kiryl/Documents/dp-tms/telegram_bot/"


def restricted(func):
    """декоратор для ограничения пользователей по телеграм id.
    telegram id можно узанать с помощью @getmyid_bot
    его нужно добавить в список allowed_ids
    """

    @wraps(func)
    async def wrapped(update: Update, context: ContextTypes.DEFAULT_TYPE, *args, **kwargs) -> None:
        user_id = update.effective_user.id
        allowed_ids = [33828605]
        if user_id in allowed_ids:
            return await func(update, context, *args, **kwargs)
        else:
            await update.message.reply_text("Вы не авторизованы для выполнения команд.")

    return wrapped


async def hello(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    await update.message.reply_text(f'Привет, {update.effective_user.first_name}!\nХочешь развернуть свой первый проект?\nПиши /help и узнай как это сделать!')

#@restricted - секции защищенные авторизацией по телеграм id
@restricted
async def help(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    help_text = "/hello - Приветствие бота\n"
    help_text += "/deploy <имя репозитория> - разворачивание проекта в облаке yandex cloud\n"
    help_text += "/task <название проекта> <окружение> - разворачивание задачи в облаке yandex cloud\n"
    await update.message.reply_text(help_text)


@restricted
async def deploy(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    # Check if the command has the required argument (the repository name)
    if len(context.args) != 1:
        await update.message.reply_text("Используй: /deploy <имя репозитория>")
        return

    repository_name = context.args[0]
    #git_repository = f"git@github.com:kignatovich/{repository_name}.git"

    try:
        
        script_directory = os.path.dirname(os.path.abspath(__file__))
        working_directory = os.path.join(script_directory, PROJECT_DIR)
        deploy_script_path = os.path.join(working_directory, "deploy.sh")
        if not os.path.exists(deploy_script_path):
            await update.message.reply_text("Данный скрипт deploy.sh отсутсвует.")
            return
        #completed_process = subprocess.run(["mkdir", repository_name], cwd=PROJECT_DIR, capture_output=True, text=True)
        completed_process = subprocess.run(["bash", "deploy.sh", repository_name], cwd=PROJECT_DIR, capture_output=True, text=True)
        output_deploy = completed_process.stdout.strip()
        #time.sleep(0.5)
        
        await update.message.reply_text(f"Деплой выполнен.\nИнформация: {output_deploy}")
    except Exception as e:
        await update.message.reply_text(f"Во время выполнения операции запуска возникла ошибка: {str(e)}")
        await update.message.reply_text(f"Во время выполнения операции деплоя возникла ошибка: {output_deploy}")


@restricted
async def task(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if len(context.args) != 2:
        await update.message.reply_text("Используй: /task <название проекта> <окружение>")
        return

    value1 = context.args[0]
    value2 = context.args[1]

    try:
        script_directory = os.path.dirname(os.path.abspath(__file__))
        working_directory = os.path.join(script_directory, PROJECT_DIR)
        deploy_script_path = os.path.join(working_directory, "task.sh")
        if not os.path.exists(deploy_script_path):
            await update.message.reply_text("Данный скрипт task.sh отсутсвует.")
            return
        
        if value2 == "main":
            #запуск проекта в прод окружении
            completed_process = subprocess.run(["bash", "task.sh", value1, value2], cwd=PROJECT_DIR, capture_output=True, text=True)
            output_main = completed_process.stdout.strip()
            await update.message.reply_text(f"Разворачивание выполненео успешно.\nИнформация: {output_main}")
        
        
        
        elif value2 == "dev":
            #запуск проекта в дев окружении
            completed_process = subprocess.run(["bash", "task.sh", value1, value2], cwd=PROJECT_DIR, capture_output=True, text=True)
            output_dev = completed_process.stdout.strip()
            await update.message.reply_text(f"Разворачивание выполненео успешно.\nИнформация: {output_dev}")
        
        
        
        else:
            await update.message.reply_text("Ошибка значения. Может быть только 'main' или 'dev'.")

        #await update.message.reply_text("Разворачивание выполненео успешно.\nИнформация: {output}")
    except Exception as e:
        
        await update.message.reply_text(f"Во время выполнения операции возникла ошибка: {str(e)}\n{output_main}\n{output_dev}")






app = ApplicationBuilder().token("5889569320:AAGDeEAGOCLy2xvYko-cIZ-oT0EmOtTnTJY").build()

app.add_handler(CommandHandler("hello", hello))
app.add_handler(CommandHandler("help", help))
app.add_handler(CommandHandler("deploy", deploy))
app.add_handler(CommandHandler("task", task))

app.run_polling()

# передача параметров в скрипт deploy.sh
#!/bin/bash
#-# ненужная секция
# Check if two arguments (value1 and value2) are provided
#if [ "$#" -ne 2 ]; then
#  echo "Usage: deploy.sh <value1> <value2>"
#  exit 1
#fi
#-#

#value1="$1"
#value2="$2"

# Create directories value1 and value2
#mkdir "$value1"
#mkdir "$value2"

#echo "Directories $value1 and $value2 created successfully."
# Add other commands as needed
