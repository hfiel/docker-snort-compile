# docker-snort-compile
Docker environment to compile Snort from source

Table of Contents
=================

   * [docker-snort-compile](#docker-snort-compile)
   * [tl;dr](#tldr)
   * [What](#what)
   * [Why](#why)
   * [Usage](#usage)
      * [Volumes](#volumes)
      * [Ports](#ports)
   * [Versions of packages tested](#versions-of-packages-tested)
   * [About IPQ and netmap modules for DAQ](#about-ipq-and-netmap-modules-for-daq)
   * [Contributing](#contributing)
   * [License](#license)

# tl;dr

Just _build_ the image, _start_ the container and open a _shell_.
This will leave you inside the container ready to perform any build tasks.


# What

This container sets-up the programs, related libraries and dependencies to compile Snort and the DAQ libraries. It is intended as a helper to create a clean compiling environment, and _not_ a container to run Snort and perform any traffic analysis.

The container has a _developer_ user with _sudo_ rights to make a proper building process without having to use _root_.

To see a list of the libraries and dependencies included, please check the _Dockerfile_

__Please note__ that neither the source code for Snort or DAQ are included: you must download those once inside the container, and then run all the desired compilation steps, including defining any extra settings you want to use during compilation.


# Why

Installing all the dependencies in your machine to simply compile Snort can leave quite a lot of libraries and tools you probably will not use anymore.

This container allows you to have a clean environment to compile the code, and once the final packages have been obtained you can simply copy those out of the container to deploy in your desired target.

# Usage

Your require _docker_ and _docker-compose_ to use this container.

There are some shell scripts to help with usage:

* _docker-snort-compile-build_: builds the docker image
* _docker-snort-compile-start_: runs the container
* _docker-snort-compile-shell_: opens a shell (_bash_) inside the container as the _developer_ user
* _docker-snort-compile-stop_: stops the container

## Volumes
The _data_ folder is mapped as a volume inside the container (_/data_) to allow you to easily move files in and out of the container. The UID and GID of the _developer_ user are matched to those of your local user to avoid permissions problems.

The container also maps the local user _~/.ssh_ folder to the container's _developer_ user _.ssh_ folder so you can use _ssh_ and _git_ inside the container with your own local keys.

## Ports

You can also ssh _into_ the container (for example to set up a remote build environment). The port 22 is exposed in the container and mapped to the port 22122 in the host.

# Versions of packages tested

This container has been created and tested using:

* Ubuntu 18.04
* docker 18.06.0-ce, (https://docs.docker.com/)
* docker-compose 1.13.0 (https://docs.docker.com/compose/)
* daq 2.0.6 (https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz)
* snort 2.9.12 (https://www.snort.org/downloads/snort/snort-2.9.12.tar.gz)

# About IPQ and netmap modules for DAQ

* _libipq_ is deprecated (replaced by *libnetfilter_queue*), so DAQ (and Snort) will not be able to use the old _IPQ_ module. You can use the current _NFQ_ module instead, and its requirements are included in the container.
* _netmap_ (https://github.com/luigirizzo/netmap) requires compilation packages and procedures dependent on the specific kernel and hardware for the target machine, so its requirements are not included in the container. If you want to compile DAQ with the _netmap_ module, you will need to solve all the required dependencies.


# Contributing

1.  Fork the repository on Github
2.  Create a named feature branch (like `add_component_x`)
3.  Write your changes
4.  Submit a Pull Request using Github

# License

    Copyright © 2018  Héctor Fiel < https://github.com/hfiel >


    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

    The license text is available at https://www.gnu.org/licenses/agpl-3.0.html
