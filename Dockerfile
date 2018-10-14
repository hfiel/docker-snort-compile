#     Copyright © 2018  Héctor Fiel < https://github.com/hfiel >
#
#
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU Affero General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU Affero General Public License for more details.
#
#     You should have received a copy of the GNU Affero General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#     The license text is available at https://www.gnu.org/licenses/agpl-3.0.html

FROM ubuntu:18.04

LABEL name="docker-snort-compile"
LABEL maintainer="Hector Fiel https://github.com/hfiel/"
LABEL repository="https://github.com/hfiel/docker-snort-compile"
LABEL version="0.1"
LABEL description="This dockerfile contains a development environment to \
compile snort from source."

#================================
# Build arguments
#================================
ENV BUILD_TIMESTAMP 201810120940
ENV LOCALE en_US.UTF-8
EXPOSE 22


#================================
# TIMEZONE
#================================

## Set UTC timezone
RUN ln -snf /usr/share/UTC /etc/localtime && \
    echo UTC > /etc/timezone

#================================
# APT - MAIN
# NOTE: to reduce number and size of layers, you usually you use apt-get install only once in the dockerfile
#  Since the build dependencies can change, I use TWO separated apt-get install to speed up building
#  If you need to add more dependencies, please do in the APT - BUILD DEPENDENCIES section
#================================
COPY assets/docker-snort-compile/etc/apt /assets/docker-snort-compile/etc/apt

RUN /bin/bash -c 'ln -fs /assets/docker-snort-compile/etc/apt/sources.list /etc/apt/sources.list' && /bin/bash -c 'ln -fs /assets/docker-snort-compile/etc/apt/apt.conf.d/99recommends /etc/apt/apt.conf.d/99recommends'

#base system update and install
RUN apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
#     Debian base system and tools
      bash-completion \
      fontconfig \
      less \
      locales \
      rsync \
      sudo \
      supervisor \
      tree \
      unzip \
      ca-certificates \
#     Debian network tools
      curl \
      wget \
#     Editors and development
      vim \
      git \
      build-essential \
      checkinstall \
#     SSH
      openssh-client \
      openssh-server \
#     end
      && \
#     clean up
      apt-get clean -y && \
      apt-get autoclean -y && \
      apt-get autoremove -y && \
      rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
      rm -rf /var/lib/apt/lists/*

#================================
# LOCALES
#================================
RUN locale-gen $LOCALE && update-locale LANG=$LOCALE

#================================
# SSH
#================================
RUN mkdir -p /var/run/sshd

#================================
# APT - BUILD DEPENDENCIES
#================================
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
#     snort dependencies
      libpcap-dev \
      libpcre3-dev \
      libdumbnet-dev \
      zlib1g-dev \
      liblzma-dev \
      openssl \
      libssl-dev \
      libnghttp2-dev \
      libluajit-5.1-dev \
#     DAQ dependencies
      libnetfilter-queue-dev \
      bison \
      flex \
#     end
      && \
#     clean up
      apt-get clean -y && \
      apt-get autoclean -y && \
      apt-get autoremove -y && \
      rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
      rm -rf /var/lib/apt/lists/*

#================================
# LOAD ASSETS
#================================
COPY assets/docker-snort-compile /assets/docker-snort-compile

ENTRYPOINT ["/assets/docker-snort-compile/bin/entrypoint_docker-snort-compile"]
