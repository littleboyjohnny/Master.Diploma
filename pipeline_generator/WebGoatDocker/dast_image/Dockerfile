
FROM owasp/zap2docker-stable
COPY ./entrypoint.sh /usr/bin/entrypoint.sh
USER root
RUN chmod 777 /usr/bin/entrypoint.sh && ln -s /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["zap-full-scan.py", "-t", "http://iast:8080/WebGoat", "-r", "zap_result.html"]

