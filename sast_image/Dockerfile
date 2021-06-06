FROM ubuntu:18.04
RUN apt update
RUN apt install -y git
RUN apt install -y make
RUN apt install -y python
RUN ["git", "clone", "https://github.com/haiwen/seafile.git" ]
RUN ["git", "clone", "https://github.com/david-a-wheeler/flawfinder.git" ]
RUN cd flawfinder && make install && cd ..
