FROM ubuntu:latest
LABEL maintainer="chunyang"
LABEL org.opencontainers.image.source=git@github.com:longfengpili/myubuntu.git
LABEL org.opencontainers.image.description="myubuntu image"
LABEL org.opencontainers.image.licenses=MIT

# Docker 内用户切换到 root
USER root

# 设置环境变量，以支持中文
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# 设置容器的时区为东八区，即北京时间
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 更新系统包列表并安装
RUN sed -i s@/archive.ubuntu.com/@/mirrors.tuna.tsinghua.edu.cn/@g /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y locales wget cron python3.8 python3.8-distutils python3-pip git \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 \
    && locale-gen zh_CN.UTF-8
    # && apt-get clean
    # && rm -rf /var/lib/apt/lists/*

# Create WorkDir
WORKDIR /workspace/

#Copy requirements
COPY requirements.txt ./requirements.txt

#Pip
RUN pip3 install -i https://pypi.doubanio.com/simple/ -r requirements.txt

# Run the command on container startup
CMD tail -f /dev/null
