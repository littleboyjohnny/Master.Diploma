FROM owasp/zap2docker-stable
COPY ./entrypoint.sh /usr/bin/entrypoint.sh
USER root
RUN chmod 777 /usr/bin/entrypoint.sh && ln -s /usr/bin/entrypoint.sh
CMD /usr/bin/entrypoint.sh && zap-full-scan.py -t http://app:80 > /tmp/zap_result.txt
