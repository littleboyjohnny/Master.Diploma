
FROM ubuntu:18.04
RUN apt update
RUN apt install -y python3
RUN apt install -y python3-pip
RUN python3 -m pip install semgrep
CMD semgrep --config=p/java --sarif -o /tmp/results/semgrep_result.sarif /tmp/src

