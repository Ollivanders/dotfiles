# Used for testing Ubuntu based installation

FROM ubuntu:20.04

RUN ["/bin/bash", "-c", "echo I am now using bash!"]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \ 
    sudo \
    git \
    nano \
    vim \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home
RUN git clone https://github.com/Ollivanders/dotfiles && \
    cd dotfiles && \
    git checkout develop
WORKDIR /home/dotfiles/
