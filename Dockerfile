FROM ubuntu:18.10

MAINTAINER NgLoader, <teamwuffy@gmail.com>

RUN apt -y update

RUN adduser --disabled-password --gecos "" --home /home/container container

RUN apt install -y --install-recommends software-properties-common ca-certificates lib32gcc1

RUN add-apt-repository -y ppa:webupd8team/java && apt -y update
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections

RUN apt -y install \
        oracle-java8-set-default \
        libswt-gtk-3-java \
        xvfb

RUN Xvfb :99 &
RUN export DISPLAY=:99

# Move java into gamedir
RUN cp -a /usr/lib/jvm/java-8-oracle/ /home/container/runtime/

USER container
ENV USER=container HOME=/home/container DISPLAY=:99
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]