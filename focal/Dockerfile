FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apt-utils bc build-essential cpio expect gdisk git kmod \
    libssl-dev python python3 parted qemu-user-static rsync sudo time tzdata \
    udev unzip wget zip device-tree-compiler lz4

RUN wget https://github.com/rockchip-linux/rk-rootfs-build/raw/master/ubuntu-build-service/packages/debootstrap_1.0.87_all.deb
RUN wget https://github.com/rockchip-linux/rk-rootfs-build/raw/master/ubuntu-build-service/packages/live-build_3.0.5-1linaro1_all.deb
RUN dpkg -i debootstrap_1.0.87_all.deb live-build_3.0.5-1linaro1_all.deb
RUN apt-get install -f -y
RUN rm debootstrap_1.0.87_all.deb live-build_3.0.5-1linaro1_all.deb
