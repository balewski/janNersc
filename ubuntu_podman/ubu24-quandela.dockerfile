FROM ubuntu:24.04
# Quandela  - on MacOS needs to be compiled as amd64 & then it works

# podman build -f ubu24-quandela.dockerfile -t balewski/ubu24-perceval:p2g   --platform linux/arm64   


# Set non-interactive mode for apt-get
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

# Update the OS and install required packages
RUN echo "1a-AAAAAAAAAAAAAAAAAAAAAAAAAAAAA OS update" && \
    apt-get update && \
    apt-get install -y locales autoconf automake gcc g++ make vim wget ssh openssh-server sudo git emacs aptitude build-essential xterm python3-pip python3-tk python3-scipy python3-dev iputils-ping net-tools screen feh hdf5-tools python3-bitstring plocate graphviz tzdata x11-apps python3-venv dnsutils iputils-ping libgomp1 && \
    apt-get clean

# Create a virtual environment for Python packages to avoid the externally managed environment issue
RUN python3 -m venv /opt/venv

# Activate the virtual environment
ENV PATH="/opt/venv/bin:$PATH"


# Install ML  libraries
RUN echo "2c-AAAAAAAAAAAAAAAAAAAAAAAAAAAAA math libs" && \
    /opt/venv/bin/pip install scikit-learn pandas seaborn[stats] networkx[default]

# Install additional Python libraries
RUN echo "2d-AAAAAAAAAAAAAAAAAAAAAAAAAAAAA python libs" && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install matplotlib h5py scipy jupyter notebook bitstring lmfit pytest

RUN pip install  perceval-quandela


# Final cleanup
RUN apt-get clean

# Set the default command to bash
CMD ["/bin/bash"]

# test
# python3 -c "import perceval as pcvl; print(pcvl.__version__)"
# >>> 0.12.1
