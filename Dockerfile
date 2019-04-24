# Dockerfile
FROM  ubuntu:18.04
MAINTAINER "Maurice Jumelet"

RUN apt-get update -y && \
    apt-get install -y git cmake gcc g++ libboost-all-dev libicu-dev

# install OCE
RUN  apt-get install -y liboce-foundation-dev liboce-modeling-dev liboce-ocaf-dev liboce-visualization-dev liboce-ocaf-lite-dev

# build opencollada
WORKDIR /tmp
RUN apt-get install -y libpcre3-dev libxml2-dev
RUN git clone https://github.com/KhronosGroup/OpenCOLLADA.git
WORKDIR  /tmp/OpenCOLLADA
RUN git checkout 064a60b65c2c31b94f013820856bc84fb1937cc6
RUN mkdir build
WORKDIR /tmp/OpenCOLLADA/build
RUN cmake ..
RUN make -j3
RUN make install

# For building the IfcPython wrapper (on by default), SWIG and Python development are needed
RUN apt-get install -y python-all-dev swig

# build IfcOpenShell
WORKDIR /tmp
RUN git clone https://github.com/IfcOpenShell/IfcOpenShell.git
WORKDIR /tmp/IfcOpenShell
RUN mkdir build
WORKDIR /tmp/IfcOpenShell/build
RUN cmake ../cmake -DOCC_LIBRARY_DIR=/usr/lib/x86_64-linux-gnu/ \
      -DOPENCOLLADA_INCLUDE_DIR="/usr/local/include/opencollada" \
      -DOPENCOLLADA_LIBRARY_DIR="/usr/local/lib/opencollada"  \
      -DPCRE_LIBRARY_DIR=/usr/lib/x86_64-linux-gnu/
RUN make install%
