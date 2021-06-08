
FROM owasp/dependency-check:latest
USER root
USER ${UID}
CMD ["--scan", "/src", "--project", "WebGoatDocker", "--out", "/report"]

