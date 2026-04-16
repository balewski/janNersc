FROM ubuntu:24.04

# Podman example:
#   podman build --network=host -f ubu24-aqdrop.dockerfile -t ubu24-aqdrop:p1 --platform linux/arm64
# On PM use `podman-hpc` instead of `podman`.

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

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

RUN python3 -m venv "${VIRTUAL_ENV}" && \
    pip install --upgrade pip && \
    pip install \
        "qiskit[visualization,ibm]" \
        qiskit-aer \
        qiskit-experiments \
        qiskit-ibm-runtime \
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

CMD ["/bin/bash"]
