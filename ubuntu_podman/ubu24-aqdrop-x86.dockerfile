FROM ubuntu:24.04

# HPC-Podman on PM 
#  time  podman-hpc  build  -f ubu24-aqdrop-x86.dockerfile -t ubu24-aqdrop:p1
# additionaly do 1 time:      podman-hpc migrate ubu24-aqdrop:p1


ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

# --- generic OS ppackages ---
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        aptitude \
        autoconf \
        automake \
        build-essential \
        dnsutils \
        emacs \
        feh \
        g++ \
        gcc \
        git \
        graphviz \
        hdf5-tools \
        iputils-ping \
        locales \
        make \
        net-tools \
        openssh-server \
        plocate \
        python3-bitstring \
        python3-dev \
        python3-pip \
        python3-scipy \
        python3-tk \
        python3-venv \
        screen \
        ssh \
        sudo \
        tzdata \
        vim \
        wget \
        x11-apps \
        xterm && \
    rm -rf /var/lib/apt/lists/*

# -- generic python libs ---
RUN python3 -m venv "${VIRTUAL_ENV}" && \
    pip install --upgrade pip && \
    pip install \
        bitstring \
        h5py \
        jupyter \
        lmfit \
        matplotlib \
        "networkx[default]" \
        notebook \
        pandas \
        pytest \
        pytz \
        scikit-learn \
        scipy

# -- AQDrop speciffic ---
RUN python3 -m venv "${VIRTUAL_ENV}" && \
     pip install --upgrade  aqdrop

CMD ["/bin/bash"]
