# Пайплайн для standalone приложений

Скрипт pipeline_generator.sh создает Dockerfile'ы инструментов SAST, DAST, IAST, RASP и Dependency Check, а также docker-compose.yaml файл для создания и поднятия контейнеров с инструментами. Чтобы воспользоваться пайплайном, необходимо отредактировать его следующим образом:
в переменной src указать путь к исходному коду проверяемого проекта, указать имя проекта в project_name, в path_or_url_to_jar указать путь к jar файлу приложения или ссылку на пакет, port - порт, на котором работает приложение, url_path - URL‐путь к стартовой странице, Далее идут переменные, связанные с использованием инструмента Contrast Security. Необходимо зарегистрироваться [здесь](https://bit.ly/341PrFu). После регистрации зайти в Organization settings -> API и скопировать в соотетствующие переменные Agent Username, API Key и Agent Service Key.

Пример для приложения WebGoat:
```
git clone https://github.com/WebGoat/WebGoat.git /home/user/src/.

src="/home/user/src"
project_name="WebGoatDocker"
path_or_url_to_jar="https://github.com/WebGoat/WebGoat/releases/download/7.1/webgoat-container-7.1-exec.jar"
port="8080"
url_path="/WebGoat"
```

После:
```
cd <project_name>
docker-compose up --build
```

Результаты сканирования инструментов будут находиться в папке results/ . Результаты Contrast Security можно увидеть на странице приложения, которое создастся после поднятия контейнеров и запуска iast контейнера
