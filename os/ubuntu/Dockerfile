# Used for testing Ubuntu based installation

FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y \
    git \
    nano \
    vim

RUN echo
WORKDIR /home
RUN git clone https://github.com/Ollivanders/dotfiles && \
    cd dotfiles && \
    git checkout develop
WORKDIR /home/dotfiles/
