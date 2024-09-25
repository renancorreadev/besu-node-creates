# FROM python:3.8
FROM ubuntu:18.04

# *** INSTALL LINUX DEPENDENCES
RUN apt-get update


RUN apt-get install -y wget
RUN apt-get install -y htop
RUN apt-get install -y curl
RUN apt-get install -y jq
RUN apt-get install -y tree
RUN apt-get install -y build-essential
RUN apt-get install -y git
RUN apt-get install -y file

# *** CREATE SERVICE DIR
ARG DEBIAN_REPORT=noninteractive
RUN apt-get --fix-missing update
WORKDIR /app

# ** INSTALL HyperLeadge/besu - [ v23.4.0 ]

RUN wget https://hyperledger.jfrog.io/hyperledger/besu-binaries/besu/23.4.0/besu-23.4.0.tar.gz
RUN tar -xvzf besu-23.4.0.tar.gz

RUN mv besu-23.4.0 /opt/besu

# ** INSTALL JavaJDK - [ v20.0.1 ]
RUN wget https://download.java.net/java/GA/jdk20.0.1/b4887098932d415489976708ad6d1a4b/9/GPL/openjdk-20.0.1_linux-x64_bin.tar.gz
RUN tar zxvf openjdk-20.0.1_linux-x64_bin.tar.gz -C /opt/
ENV JAVA_HOME=/opt/jdk-20.0.1

# ** CONFIGURE ENV PATH
ENV PATH="${JAVA_HOME}/bin:${PATH}"
ENV PATH="/opt/besu/bin:${PATH}"


