FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apt-transport-https apt-utils bc build-essential curl \
    device-tree-compiler gcc-arm-linux-gnueabihf kmod libssl-dev locales \
    lsb-release python software-properties-common sudo

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && \
    apt-get install -y containerd.io docker-ce docker-ce-cli

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
