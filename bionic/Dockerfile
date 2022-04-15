FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apt-utils bc build-essential chrpath cpio curl \
    device-tree-compiler diffstat expect gawk gdisk git iptables jq kmod \
    liblz4-tool locales npm parted python python3 qemu-user-static rsync \
    software-properties-common sudo texinfo time tzdata udev unzip wget zip

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && \
    apt-get install -y containerd.io docker-ce docker-ce-cli

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# Configure GCC cross-compile tool chain for Jetson platform
RUN wget http://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
RUN tar -xvJf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz -C /opt
ENV NV_TOOLCHAIN_PREFIX=/opt/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
RUN rm gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz

# Fix the failure for the Jetson platform build
RUN apt-get install -y xxd libxml2-utils libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf
