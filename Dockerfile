FROM ubuntu:22.04

WORKDIR /home/work

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# cmd tools
RUN apt-get update -y && \
    apt-get install -y wget \
    curl \
    vim \
    s3cmd \
    iputils-ping \
    git \
    systemd

# vimrc
RUN git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime && \
    sh ~/.vim_runtime/install_basic_vimrc.sh

# miniconda
RUN cd /home/work && \
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash ./miniconda.sh -b -p /home/work/miniconda3 && \
    /home/work/miniconda3/bin/conda init && \
    rm -f ./miniconda.sh

# cleanup
RUN apt-get autoclean && \
    cat /dev/null > /root/.bash_history && \
    echo "alias ll='ls -lh'" >> /root/.bashrc

