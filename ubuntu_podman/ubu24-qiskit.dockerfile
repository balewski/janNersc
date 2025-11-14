FROM ubuntu:24.04

#  podman build  --network=host -f ubu24-qiskit.dockerfile -t balewski/ubu24-qiskit:p7o   --platform linux/arm64   
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

RUN pip install --upgrade qiskit-ibm-runtime

# QSP project w/ Kabir
RUN /opt/venv/bin/pip install pyqsp pandas  openpyxl

# Q-CTRL
RUN /opt/venv/bin/pip install fire-opal  qctrl-visualizer 

# IonQ
RUN /opt/venv/bin/pip install  qiskit-ionq

# OLD qiskit-machine-learning qiskit_ibm_experiment  qiskit_qasm3_import

# Install additional Python libraries
RUN echo "2d-AAAAAAAAAAAAAAAAAAAAAAAAAAAAA python libs" && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install matplotlib h5py scipy jupyter notebook bitstring lmfit pytest scikit-learn networkx[default]


# Final cleanup
RUN apt-get clean

# Set the default command to bash
CMD ["/bin/bash"]
