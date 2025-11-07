FROM ubuntu:24.04

#  podman build  --network=host -f ubu24-qec.dockerfile -t balewski/ubu24-qec:p1e   --platform linux/arm64   
#   --platform linux/amd64   works w/o LD_PRELOAD  but generates WARNING: image platform (linux/amd64) does not match the expected platform (linux/arm64)
# for omp_get_num_threads:  #      -e LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1 \
# on PM use 'podman-hpc' instead of 'podman' and all should work
# additionaly do 1 time: podman-hpc migrate balewski/ubuXX-qiskit-qml:p1


# Set non-interactive mode for apt-get
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

# Update the OS and install required packages
RUN echo "1a-AAAAAAAAAAAAAAAAAAAAAAAAAAAAA OS update" && \
    apt-get update && \
    apt-get install -y locales autoconf automake gcc g++ make vim wget ssh openssh-server sudo git emacs aptitude build-essential xterm python3-pip python3-tk python3-scipy python3-dev iputils-ping net-tools screen feh hdf5-tools python3-bitstring plocate graphviz tzdata x11-apps python3-venv dnsutils iputils-ping && \
    apt-get clean


# Create a virtual environment for Python packages to avoid the externally managed environment issue
RUN python3 -m venv /opt/venv

# Activate the virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Install Qiskit  and its related packages within the virtual environment
RUN echo "2b-AAAAAAAAAAAAAAAAAAAAAAAAAAAAA Qiskit  libs" && \
     /opt/venv/bin/pip install --upgrade "qiskit[visualization,ibm]" qiskit_ibm_runtime qiskit-aer

#  Quantum error corrections tools
# Clone Stim
RUN git clone https://github.com/quantumlib/Stim.git /stim

# (Option A) Install the Python package (includes C++ core build)
RUN /opt/venv/bin/pip install /stim

# (Option B) Build just the CLI binary - not working
#RUN cd /stim && cmake -B build && cmake --build build --target stim && \
#     cp build/stim /usr/local/bin/stim

RUN /opt/venv/bin/pip install  pymatching sinter


# Install additional Python libraries
RUN echo "2d-AAAAAAAAAAAAAAAAAAAAAAAAAAAAA python libs" && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install matplotlib h5py scipy jupyter notebook bitstring lmfit pytest scikit-learn networkx[default]   pandas 


# Final cleanup
RUN apt-get clean

# Set the default command to bash
CMD ["/bin/bash"]
