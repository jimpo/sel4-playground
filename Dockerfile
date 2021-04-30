FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && \
    apt-get -y install \
        cmake ccache ninja-build cmake-curses-gui \
        python3-dev python3-pip python3-venv \
        libxml2-utils libncurses-dev \
        curl git doxygen device-tree-compiler \
        u-boot-tools \
        protobuf-compiler \
        gcc-arm-linux-gnueabi g++-arm-linux-gnueabi \
        gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
        gcc-arm-none-eabi \
        gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
        haskell-stack \
        cpio \
        bison flex bc # U-Boot build deps

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN . /root/.cargo/env && \
    rustup install nightly && \
    rustup default nightly && \
    rustup component add rust-src && \
    cargo install xargo

RUN pip3 install setuptools sel4-deps camkes-deps protobuf PyYAML

WORKDIR /root

COPY camkes-project /root/camkes-project
COPY sel4test /root/sel4test
COPY u-boot /root/u-boot
COPY devices /root/devices
COPY build-tools /root/
COPY apps /root/camkes-project/projects/camkes

RUN mkdir output
