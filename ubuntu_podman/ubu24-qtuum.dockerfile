FROM ubuntu:24.04
# Quantinuum

# time podman build   -f ubu24-qtuum.dockerfile -t balewski/ubu24-qtuum:p1b   
# PM: real      7m42.406s


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

# Quantinuum libs
# Upgrade pip and install necessary Python packages
RUN pip install --upgrade pip wheel setuptools

# Install pytket and the Quantinuum extension
RUN pip install pytket pytket-quantinuum qnexus pytket-qiskit qiskit-aer

# Install pyqir
RUN pip install pyqir


# Final cleanup
RUN apt-get clean

# Set the default command to bash
CMD ["/bin/bash"]