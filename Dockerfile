ARG BASE_IMAGE=nvidia/cudagl:11.0-devel-ubuntu20.04
FROM ${BASE_IMAGE}

# Disable dpkg/gdebi interactive dialogs
ENV DEBIAN_FRONTEND=noninteractive

# Determine Webots version to be used and set default argument
ARG WEBOTS_VERSION=R2020b-rev1
ARG WEBOTS_PACKAGE_PREFIX=

# Install Webots runtime dependencies
RUN apt update && apt install --yes wget
RUN wget https://raw.githubusercontent.com/cyberbotics/webots/master/scripts/install/linux_runtime_dependencies.sh
RUN chmod +x linux_runtime_dependencies.sh
RUN ./linux_runtime_dependencies.sh
RUN rm ./linux_runtime_dependencies.sh

# Install X virtual framebuffer to be able to use Webots without GPU and GUI (e.g. CI)
RUN apt install --yes xvfb

# Install Webots
WORKDIR /usr/local
RUN wget https://github.com/cyberbotics/webots/releases/download/$WEBOTS_VERSION/webots-$WEBOTS_VERSION-x86-64$WEBOTS_PACKAGE_PREFIX.tar.bz2
RUN tar xjf webots-*.tar.bz2
RUN rm webots-*.tar.bz2
ENV QTWEBENGINE_DISABLE_SANDBOX=1
ENV WEBOTS_HOME /usr/local
ENV PATH /usr/local/webots:${PATH}

# Finally open a bash command to let the user interact
CMD ["/bin/bash"]
