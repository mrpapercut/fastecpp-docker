FROM debian:latest

RUN apt-get update && apt-get install -y \
    gcc g++ make \
    wget \
    libgmp-dev libmpfr-dev libpari-dev zlib1g-dev \
    openmpi-common openmpi-bin libopenmpi-dev \
    git python3 pip

WORKDIR /fastecpp

# Install GNU MPC
RUN wget https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz && tar -xzf ./mpc-1.3.1.tar.gz
RUN cd /fastecpp/mpc-1.3.1 && ./configure && make && make install

# Install MPFRCX
RUN wget https://www.multiprecision.org/downloads/mpfrcx-0.6.3.tar.gz && tar -xzf ./mpfrcx-0.6.3.tar.gz
RUN cd /fastecpp/mpfrcx-0.6.3 && ./configure && make && make install

# Install CM
RUN wget https://www.multiprecision.org/downloads/cm-0.4.2.tar.gz && tar -xzf ./cm-0.4.2.tar.gz
RUN cd /fastecpp/cm-0.4.2 && ./configure --enable-mpi && make && make install

# Cleanup
RUN cd /fastecpp && rm -rf ./*

# Install ecpp-verifier
RUN mkdir /verify-cert && \
    cd /verify-cert && \
    git clone https://github.com/tomato42/ecpp-verifier . && \
    mv ./ecpp ./ecpp-verify && \
    pip install ecdsa gmpy2

# Allows loading shared libraries
RUN ldconfig

WORKDIR /verify-cert

# Add runandverify script
COPY ./runandverify.sh ./runandverify.sh
RUN chmod +x ./runandverify.sh
