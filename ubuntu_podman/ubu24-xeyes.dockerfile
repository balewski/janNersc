FROM ubuntu:24.04
# Example of Docker image with X11 graphics for macOS

# Build command:
# podman build -f ubu24-xeyes.dockerfile -t ubu24-xeyes:p1 .

RUN apt-get update && \
    apt-get install -y xterm python3-pip x11-apps locales && \
    apt-get clean all

# How to display on macOS:
# 1. Open XQuartz -> Settings -> Security -> Check "Allow connections from network clients"
# 2. Restart XQuartz
# 3. In Mac terminal: xhost + 127.0.0.1
# 4. Run container:
# podman run -it --rm -e DISPLAY=host.containers.internal:0 ubu24-xeyes:p1 xeyes
