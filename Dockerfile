# enzyme_python jupyter enviroments
FROM ubuntu:16.04
MAINTAINER  wangry@tib.cas.cn
RUN apt-get update && apt-get install -y --no-install-recommends \
      bzip2 \
      g++ \
      git \
      graphviz \
      libgl1-mesa-glx \
      libhdf5-dev \
      openmpi-bin \
      wget && \
    rm -rf /tmp/*

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt-get update

WORKDIR /tmp
RUN wget --no-check-certificate https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash ./Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3
ENV PATH=/opt/miniconda3/bin:$PATH
RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/mro/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/ && \
    conda config --set show_channel_urls yes

COPY enviroments.yml ./enviroments.yml
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
RUN conda env create -f enviroments.yml
RUN rm ./Miniconda3-latest-Linux-x86_64.sh && ln -s /opt/miniconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh  && echo ". /opt/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc && echo "conda activate enzyme_python" >> ~/.bashrc && find /opt/miniconda3/ -follow -type f -name '*.a' -delete && find /opt/miniconda3/ -follow -type f -name '*.js.map' -delete &&  /opt/miniconda3/bin/conda clean -afy