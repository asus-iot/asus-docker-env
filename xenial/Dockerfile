FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apt-utils bc build-essential device-tree-compiler \
    gcc-arm-linux-gnueabihf kmod libssl-dev python sudo
