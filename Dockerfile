FROM ubuntu
#FROM pradosj/ngs

#
# Install required ubuntu packages to build BLASR
#
RUN apt-get update && apt-get install -y \
    git \
    python \
    make \
    curl \
    bzip2 \
    g++ \
    libz-dev



#
# Install HDF5 library dependencies for PacBio-BLASR
#
#RUN mkdir -p /data/hdf5 && curl -k -L https://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.16/bin/linux-centos6-x86_64-gcc447/hdf5-1.8.16-linux-centos6-x86_64-gcc447-shared.tar.gz | tar -C /data/hdf5 -zxvf -
RUN mkdir -p /data/hdf5 && curl -k -L https://dl.dropboxusercontent.com/u/70124057/hdf5-1.8.16_centos5_gcc5.3.0_noszip.tar.gz | tar -C /data/hdf5 -zxvf -


#
# Install PacBio-BLASR
#
RUN git clone --recursive https://github.com/PacificBiosciences/blasr.git /data/blasr 
WORKDIR /data/blasr
RUN ./configure.py --sub --no-pbbam HDF5_INCLUDE=/data/hdf5/hdf5-1.8.16/include/ HDF5_LIB=/data/hdf5/hdf5-1.8.16/lib && make configure-submodule build-submodule blasr



#
# Install PacBio-PBCCS
#
RUN apt-get install -y \
    git \
    make \
    cmake \
    g++ \
    libboost-dev

RUN git clone https://github.com/PacificBiosciences/pbccs.git /data/pbccs && mkdir /data/pbccs/build
WORKDIR /data/pbccs
RUN git submodule update --init --remote
WORKDIR /data/pbccs/build
RUN cmake .. && make



#
# Install STAR binaries
#
RUN curl -kL https://github.com/alexdobin/STAR/archive/2.5.2a.tar.gz | tar -C /data -zxf -




VOLUME [“/export/“]

#EXPOSE :80



