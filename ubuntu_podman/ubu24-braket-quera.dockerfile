FROM ubuntu:24.04

# time podman build -f ubu24-braket-quera.dockerfile  -t balewski/ubu24-braket-quera:p1c     

# PM: 

# AWS=Braket + Qiskit +Jupyter+QuEra
# Instructions: https://www.quera.com/using-aquila

# Use-case test command
# python3 -c 'from braket.ahs.atom_arrangement import AtomArrangement; import numpy as np; from quera_ahs_utils.plotting import show_register'

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

RUN echo "1- Updating OS and installing essential packages" && \
    apt-get update && \
    apt-get install -y locales autoconf automake gcc g++ make vim wget ssh openssh-server sudo git emacs aptitude \
                       build-essential xterm python3-pip python3-tk python3-scipy python3-dev iputils-ping \
                       net-tools screen graphviz graphviz-dev feh hdf5-tools x11-apps unzip curl ffmpeg python3-venv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a virtual environment and install basic Python libraries
RUN echo "2a- Creating a virtual environment and installing basic Python libraries" && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir Pillow

# Add the virtual environment to the PATH
ENV PATH="/opt/venv/bin:$PATH"

# Install generic Python libraries
RUN echo "2b- Installing generic Python libraries" && \
    pip install --no-cache-dir matplotlib h5py  scipy jupyter notebook scikit-learn bitstring==4.0.1


# Install Qiskit-specific libraries
RUN echo "2c- Installing Qiskit-specific libraries" && \
    pip install --no-cache-dir qiskit-experiments fastaparser kaleidoscope mapomatic pylatexenc networkx[default,extra] graphviz pyzx

# Install AWS CLI
RUN echo "2d- Installing AWS CLI" && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install && rm -rf awscliv2.zip aws

# Install QuEra + AWS Braket libraries
RUN echo "2e- Installing QuEra + AWS Braket libraries" && \
    pip install --no-cache-dir quera_ahs_utils numdifftools bloqade qiskit-aer

