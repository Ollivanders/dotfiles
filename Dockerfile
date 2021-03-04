FROM ubuntu:20:04

RUN apt-get update && apt-get upgrade

WORKDIR /home

RUN git clone https://github.com/Ollivanders/dotfiles && \
    cd dotfiles