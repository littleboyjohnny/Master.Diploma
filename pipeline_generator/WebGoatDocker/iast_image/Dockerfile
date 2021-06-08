
FROM adoptopenjdk/openjdk8:debianslim
ADD https://github.com/WebGoat/WebGoat/releases/download/7.1/webgoat-container-7.1-exec.jar /opt/app/app.jar
ENV CONTRAST__API__URL=https://ce.contrastsecurity.com/Contrast
RUN apt-get update \ 
  && apt-get install -y gnupg \ 
  && curl https://pkg.contrastsecurity.com/api/gpg/key/public | apt-key add - \ 
  && echo "deb https://pkg.contrastsecurity.com/debian-public/ all contrast" > /etc/apt/sources.list.d/contrast-all.list \ 
  && apt-get update \ 
  && apt-get install -y contrast-java-agent
ENV CONTRAST__AGENT__JAVA__STANDALONE_APP_NAME=WebGoatDocker \ 
  CONTRAST__PROTECT__RULES__SQL_INJECTION__DETECT_TAUTOLOGIES=true \ 
  CONTRAST__SERVER__NAME=WebGoatDockerServer \ 
  CONTRAST__AGENT__LOGGER__STDERR=true
EXPOSE 8080
CMD ["java","-javaagent:/opt/contrast/contrast-agent.jar","-jar","/opt/app/app.jar"]

