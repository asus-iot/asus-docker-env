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

# https://www.nxp.com/docs/en/user-guide/ANDROID_USERS_GUIDE.pdf
# Set the clang to be used to compile Linux kernel
RUN git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 /opt/prebuilt-android-clang -b master
RUN cd /opt/prebuilt-android-clang; git checkout 007c96f100c5322acc37b84669c032c0121e68d0
ENV CLANG_PATH=/opt/prebuilt-android-clang

# Configure GCC cross-compile tool chain
RUN wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu.tar.xz
RUN tar -xvJf gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu.tar.xz -C /opt
ENV AARCH64_GCC_CROSS_COMPILE=/opt/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu/bin/aarch64-linux-gnu-
RUN rm gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu.tar.xz

# Configure GCC cross-compile tool chain for Jetson platform
RUN wget http://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
RUN tar -xvJf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz -C /opt
ENV NV_TOOLCHAIN_PREFIX=/opt/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
RUN rm gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz


# Install additional package for the NXP Android build
RUN apt-get update && \
    apt-get install -y uuid uuid-dev zlib1g-dev liblz-dev liblzo2-2 \
    liblzo2-dev lzop git curl u-boot-tools mtd-utils \
    android-sdk-libsparse-utils android-sdk-ext4-utils \
    device-tree-compiler gdisk m4 zlib1g-dev bison flex make libssl-dev \
    gcc-multilib

# Fix the failure for the NXP Android build
RUN apt-get update && \
    apt-get install -y libncurses5

# Fix the failure for the Jetson platform build
RUN apt-get update && \
    apt-get install -y xxd
