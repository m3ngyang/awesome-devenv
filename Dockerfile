FROM ubuntu:22.04

WORKDIR /home/work

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# cmd tools
RUN apt-get update -y && \
    apt-get install -y wget \
    curl vim git tmux jq \
    iputils-ping systemd \
    s3cmd

# vimrc
RUN git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime && \
    sh ~/.vim_runtime/install_basic_vimrc.sh

# miniconda
RUN cd /home/work && \
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash ./miniconda.sh -b -p /home/work/miniconda3 && \
    /home/work/miniconda3/bin/conda init && \
    rm -f ./miniconda.sh

# etcd
ENV ETCD_VER=v3.5.6
ENV GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
ENV DOWNLOAD_URL=${GITHUB_URL}

RUN rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz && \
    rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test && \
    curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz && \
    tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1 && \
    mv /tmp/etcd-download-test/etcd /usr/local/bin/ && \
    mv /tmp/etcd-download-test/etcdctl /usr/local/bin/ && \
    rm -rf /tmp/etcd*

# cleanup
RUN apt-get autoclean && \
    cat /dev/null > /root/.bash_history && \
    echo "alias ll='ls -lh'" >> /root/.bashrc

