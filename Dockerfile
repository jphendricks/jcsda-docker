# FROM jcsda/docker-gnu-openmpi-dev:latest  as crtm-era5-build
FROM ubuntu:20.04

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Clone crtm
WORKDIR /home/jedi

RUN apt-get update && \
    apt-get install -y m4 \
                       git \
                       build-essential \
                       wget \
                       tar \
                       ssh \
                       libssl-dev \
                       libblas-dev \
                       liblapack-doc \
                       liblapack-dev \
                       libeigen3-dev \
                       mpich \
                       libboost-all-dev

RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Install ecbuild
RUN git clone https://github.com/ecmwf/ecbuild
ENV PATH="/home/jedi/ecbuild/bin:${PATH}"

# Install cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.24.2/cmake-3.24.2.tar.gz; \
    tar xzvf cmake-3.24.2.tar.gz; \
    cd cmake-3.24.2; \
    ./bootstrap; \
    make; \
    make install; \
    cd ..; \
    rm -rf cmake-3.24.2 cmake-3.24.2.tar.gz

#Build zlib
RUN wget https://zlib.net/zlib-1.2.13.tar.gz; \
    tar xf zlib-1.2.13.tar.gz; \
    cd zlib-1.2.13; \
    ./configure --prefix=/usr/local; \
    make check; \
    make install; \
    cd ..; \
    rm -rf zlib-1.2.13 zlib-1.2.13.tar.gz

#Build HDF5
RUN wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.2/src/hdf5-1.12.2.tar.bz2; \
    tar xjvf hdf5-1.12.2.tar.bz2; \
    cd hdf5-1.12.2; \
    ./configure --with-zlib=/usr/local --prefix=/usr/local --enable-hl; \
    make; \
    make install; \
    cd ..; \
    rm -rf hdf5-1.12.2 hdf5-1.12.2.tar.bz2

#Build netcdf
RUN wget https://downloads.unidata.ucar.edu/netcdf-c/4.9.0/netcdf-c-4.9.0.tar.gz; \
    tar xzvf netcdf-c-4.9.0.tar.gz; \
    cd netcdf-c-4.9.0; \
    ./configure --prefix=/usr/local \
                CC=gcc \
                LDFLAGS=-L/usr/local/lib \
                CFLAGS=-I/usr/local/include; \
    make; \
    make install; \
    cd ..; \
    rm -rf netcdf-c-4.9.0 netcdf-c-4.9.0.tar.gz

ENV NCDIR=/usr/local
ENV LD_LIBRARY_PATH="${NCDIR}/lib:${LD_LIBRARY_PATH}"

RUN wget https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.0/netcdf-fortran-4.6.0.tar.gz; \
    tar xzvf netcdf-fortran-4.6.0.tar.gz; \
    cd netcdf-fortran-4.6.0; \
    ./configure --prefix=/usr/local \
                CC=gcc \
                FC=gfortran \
                LDFLAGS=-L/usr/local/lib \
                CFLAGS=-I/usr/local/include; \
    make; \
    make install; \
    cd ..; \
    rm -rf netcdf-fortran-4.6.0 netcdf-fortran-4.6.0.tar.gz

RUN git clone https://github.com/ecmwf/eckit.git; \
    cd eckit; \
    git checkout 2021.12.0; \
    mkdir build; \
    cd build; \
    ecbuild ..; \
    make; \
    ctest; \
    make install; \
    cd ..; \
    rm -rf eckit

RUN git clone -b master https://github.com/ecmwf/fckit.git; \
    cd fckit; \
    mkdir build; \
    cd build; \
    ecbuild ..; \
    make; \
    ctest; \
    make install; \
    cd ..; \
    rm -rf fckit

RUN git clone -b master https://github.com/ecmwf/atlas.git; \
    cd atlas; \
    mkdir build; \
    cd build; \
    ecbuild ..; \
    make; \
    ctest; \
    make install; \
    cd ..; \
    rm -rf atlas

# ssh git stuff
COPY id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN chown -R root:root /root/.ssh
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN git clone git@github.com:gsl-lite/gsl-lite.git; \
    cd gsl-lite; \
    mkdir build; \
    cd build; \
    cmake ..

RUN git clone https://github.com/JCSDA/fv3-bundle.git; \
    cd fv3-bundle; \
    mkdir build; \
    cd build; \
    ecbuild  -Dgsl-lite_DIR:PATH=/home/jedi/gsl-lite/build ..; \
    make update; \
    make -j4; \
    ctest

# #Download base image ubuntu 20.04
# FROM ubuntu:20.04
#
# # LABEL about the custom image
# LABEL maintainer="johnny.hendricks@orbitalmicro.com"
# LABEL version="0.1"
# LABEL description="This is custom Docker Image for JEDI"
#
# # Disable Prompt During Packages Installation
# ARG DEBIAN_FRONTEND=noninteractive

