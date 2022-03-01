FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apt-utils bc build-essential cpio curl \
    device-tree-compiler expect gawk gdisk git kmod liblz4-tool libssl-dev \
    locales parted python python3 qemu-user-static rsync \
    software-properties-common sudo time tzdata udev unzip wget zip

COPY packages .

RUN dpkg -i debootstrap_1.0.87_all.deb live-build_3.0.5-1linaro1_all.deb
RUN apt-get install -f -y

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && \
    apt-get install -y containerd.io docker-ce docker-ce-cli

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# https://source.android.com/setup/build/initializing
# Install necessary packages for the Android build
RUN apt-get update && \
    apt-get install -y git-core gnupg flex bison build-essential zip curl \
    zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 libncurses5-dev \
    lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev \
    libxml2-utils xsltproc unzip fontconfig
