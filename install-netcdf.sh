#!/bin/bash
set -ex

BIN_DIR=/usr/local

#Build zlib
wget https://zlib.net/zlib-1.2.13.tar.gz
tar xf zlib-1.2.13.tar.gz
cd zlib-1.2.13
./configure --prefix=${BIN_DIR}
make check
make install
cd ..
# rm -rf zlib-1.2.13 zlib-1.2.13.tar.gz

#Build HDF5
wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.2/src/hdf5-1.12.2.tar.bz2
tar xjvf hdf5-1.12.2.tar.bz2
cd hdf5-1.12.2
./configure --with-zlib=${BIN_DIR} --prefix=${BIN_DIR} --enable-hl
make
make install
cd ..
# rm -rf hdf5-1.12.2 hdf5-1.12.2.tar.bz2

#Build netcdf
wget https://downloads.unidata.ucar.edu/netcdf-c/4.9.0/netcdf-c-4.9.0.tar.gz
tar xzvf netcdf-c-4.9.0.tar.gz
cd netcdf-c-4.9.0
CC=gcc
LDFLAGS=-L${BIN_DIR}/lib
CFLAGS=-I${BIN_DIR}/include
./configure --prefix=${BIN_DIR}
make
make install
cd ..
# rm -rf netcdf-c-4.9.0 netcdf-c-4.9.0.tar.gz

NCDIR=${BIN_DIR}
LD_LIBRARY_PATH="${NCDIR}/lib:${LD_LIBRARY_PATH}"

wget https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.0/netcdf-fortran-4.6.0.tar.gz
tar xzvf netcdf-fortran-4.6.0.tar.gz
cd netcdf-fortran-4.6.0
CC=gcc
FC=gfortran
LDFLAGS=-L${BIN_DIR}/lib
CFLAGS=-I${BIN_DIR}/include
./configure --prefix=${BIN_DIR}
make
make install
cd ..
# rm -rf netcdf-fortran-4.6.0 netcdf-fortran-4.6.0.tar.gz
