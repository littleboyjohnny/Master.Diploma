#!/bin/bash

src="<path to source of project>"
project_name="<project name>"
path_or_url_to_jar="<path or url to jar file of application>"

port="<port of application>"
url_path="<url path of application>"

contrast_api_user_name="<Agent Username>"
contrast_api_api_key="<API Key>"
contrast_api_service_key="<Agent Service Key>"
contrast_api_url="https://ce.contrastsecurity.com/Contrast"

contrast_project_server_name="${project_name}Server"

mkdir $project_name
mkdir $project_name/sast_image
mkdir $project_name/dast_image
mkdir $project_name/iast_image
mkdir $project_name/dependency_check_image
mkdir $project_name/results

echo -e "\
user=\$USER\n\
UID=\$(id -u \${USER})\n\
GID=\$(id -g \${USER})\n\
\n\
CONTRAST__API__USER_NAME=$contrast_api_user_name\n\
CONTRAST__API__API_KEY=$contrast_api_api_key\n\
CONTRAST__API__SERVICE_KEY=$contrast_api_service_key\n\
CONTRAST__API__URL=$contrast_api_url\n\
" > $project_name/.env

echo -e "
version: '3'\n\
services:\n\
  iast:\n\
    build: iast_image/.\n\
    environment:\n\
      - CONTRAST__API__API_KEY\n\
      - CONTRAST__API__SERVICE_KEY\n\
      - CONTRAST__API__USER_NAME\n\
      - CONTRAST__API__URL\n\
    ports:\n\
      - \"$port:$port\"\n\
\n\
  sast:\n\
    container_name: sast_app\n\
    build: sast_image/.\n\
    volumes:\n\
      - ./results:/tmp/results\n\
      - $src:/tmp/src\n\
\n\
  dast:\n\
    container_name: dast_app\n\
    build: dast_image/.\n\
    volumes:\n\
      - ./results:/zap/wrk/:rw\n\
    tty: true\n\
    depends_on:\n\
      - iast\n\
\n\
  dependency_check:\n\
    build: dependency_check_image/.\n\
    container_name: dependency_check_app\n\
    environment:\n\
      - user\n\
      - UID\n\
      - GID\n\
    volumes:\n\
      - ./dependency_check_image:/usr/share/dependency-check/data:z\n\
      - ./results:/report:z\n\
      - $src:/src:z\n\
" > $project_name/docker-compose.yaml

echo -e "
FROM ubuntu:18.04\n\
RUN apt update\n\
RUN apt install -y python3\n\
RUN apt install -y python3-pip\n\
RUN python3 -m pip install semgrep\n\
CMD semgrep --config=p/java --sarif -o /tmp/results/semgrep_result.sarif /tmp/src\n\
" > $project_name/sast_image/Dockerfile

echo -e "
FROM owasp/zap2docker-stable\n\
COPY ./entrypoint.sh /usr/bin/entrypoint.sh\n\
USER root\n\
RUN chmod 777 /usr/bin/entrypoint.sh && ln -s /usr/bin/entrypoint.sh\n\
ENTRYPOINT [\"/usr/bin/entrypoint.sh\"]\n\
CMD [\"zap-full-scan.py\", \"-t\", \"http://iast:$port$url_path\", \"-r\", \"zap_result.html\"]\n\
" > $project_name/dast_image/Dockerfile

echo -e "#!/bin/bash\n\
\n\
set -e\n\
\n\
cmd=\"\$@\"\n\
\n\
>&2 echo \"!!!!!!!! Check app for available !!!!!!!!\"\n\
\n\
while [ -z \$(curl -v --silent http://iast:$port 2>&1 | grep -o '< HTTP/.* [^5][0-9][0-9]') ]; do\n\
  >&2 echo \"!!!!!!!! App is not available, will try again in 10 seconds... !!!!!!!!\"\n\
  sleep 10\n\
done\n\
\n\
>&2 echo \"!!!!!!!! App is now available !!!!!!!!\"\n\
\n\
>&2 echo \"!!!!!!!! Going to execute cmd: \$cmd !!!!!!!!\"\n\
\n\
exec \$cmd
" > $project_name/dast_image/entrypoint.sh

echo -e "
FROM adoptopenjdk/openjdk8:debianslim\n\
ADD $path_or_url_to_jar /opt/app/app.jar\n\
ENV CONTRAST__API__URL=$contrast_api_url\n\
RUN apt-get update \\ \n\
  && apt-get install -y gnupg \\ \n\
  && curl https://pkg.contrastsecurity.com/api/gpg/key/public | apt-key add - \\ \n\
  && echo \"deb https://pkg.contrastsecurity.com/debian-public/ all contrast\" > /etc/apt/sources.list.d/contrast-all.list \\ \n\
  && apt-get update \\ \n\
  && apt-get install -y contrast-java-agent\n\
ENV CONTRAST__AGENT__JAVA__STANDALONE_APP_NAME=$project_name \\ \n\
  CONTRAST__PROTECT__RULES__SQL_INJECTION__DETECT_TAUTOLOGIES=true \\ \n\
  CONTRAST__SERVER__NAME=$contrast_project_server_name \\ \n\
  CONTRAST__AGENT__LOGGER__STDERR=true\n\
EXPOSE $port\n\
CMD [\"java\",\"-javaagent:/opt/contrast/contrast-agent.jar\",\"-jar\",\"/opt/app/app.jar\"]
" > $project_name/iast_image/Dockerfile

echo -e "
FROM owasp/dependency-check:latest\n\
USER root\n\
USER \${UID}\n\
CMD [\"--scan\", \"/src\", \"--project\", \"$project_name\", \"--out\", \"/report\"]
" > $project_name/dependency_check_image/Dockerfile
