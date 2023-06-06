#!/bin/bash
# Need to set this var for verify-cert
export PYTHONPATH=/verify-cert/src

# Create filename for cert, which is 'cert-md5(input)'
CERT_NAME=$(echo $1 | md5sum - | awk '{print $1}')
CERT_FILENAME=cert-$CERT_NAME

# Change to anything but zero to run multi-core
# IMPORTANT: the code below does not in any way limit the amount of cores.
# It just uses all of them, even ones you didn't know you had
# Use at own risk!
RUN_MPI=0

# Run ecpp test
if [ $RUN_MPI != 0 ]; then
    # Need to explicitly set these vars to run MPI as root
    export OMPI_ALLOW_RUN_AS_ROOT=1
    export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
    mpirun ecpp-mpi -n "$1" -c -f /fastecpp/$CERT_FILENAME
else
    ecpp -n "$1" -c -f /fastecpp/$CERT_FILENAME # &> /dev/null
fi

# Move the .primo certfile for certification as it's the only format the verifier can handle
cp /fastecpp/$CERT_FILENAME.primo /verify-cert/certs/

# Clean up created certs
rm /fastecpp/$CERT_FILENAME*

cd /verify-cert

# Verify cert and log to either 'foundprimes.txt' or 'notfoundprimes.txt'
if n=$(./ecpp-verify -i ./certs/$CERT_FILENAME.primo | grep -irn 'certificate is a prime number' -); then
    echo "$1 is prime (certificate: $CERT_FILENAME)" >> foundprimes.txt
    echo "$1 is prime!"
else
    echo "$1 is not prime :(" >> notfoundprimes.txt
    echo "$1 is not prime :("
fi
