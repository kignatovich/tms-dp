import subprocess
from telegram import Update
from telegram.ext import ApplicationBuilder, CommandHandler, ContextTypes
import os
from functools import wraps

PROJECT_DIR = "PRPATH"



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
    help_text += "/deploy - разворачивание проекта в облаке yandex cloud\n"
    await update.message.reply_text(help_text)


@restricted
async def deploy(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    # Деплой проекта, проеврка наличия файлов в проекте вывод ошибок
    try:
        script_directory = os.path.dirname(os.path.abspath(__file__))
        working_directory = os.path.join(PROJECT_DIR, "terraform", "create_infra")
        required_files = ["providers.tf", "terraform.tfvars", "variables.tf", "main.tf"]
        missing_files = [file for file in required_files if not os.path.exists(os.path.join(working_directory, file))]
        
        if missing_files:
            missing_files_str = ", ".join(missing_files)
            await update.message.reply_text(f"Отсутствует файл: {missing_files_str}")
            return
        
        completed_process = subprocess.run(["bash", "terraform apply", "apply", "-auto-approve"], cwd=PROJECT_DIR, capture_output=True, text=True)
        #output_deploy = completed_process.stdout.strip()
        
        await update.message.reply_text(f"Деплой выполнен.")
    except Exception as e:
        await update.message.reply_text(f"Во время выполнения операции запуска возникла ошибка: {str(e)}")
        await update.message.reply_text(f"Во время выполнения операции деплоя возникла ошибка: {output_deploy}")


app = ApplicationBuilder().token("5889569320:AAGDeEAGOCLy2xvYko-cIZ-oT0EmOtTnTJY").build()

app.add_handler(CommandHandler("hello", hello))
app.add_handler(CommandHandler("help", help))
app.add_handler(CommandHandler("deploy", deploy))

app.run_polling()
