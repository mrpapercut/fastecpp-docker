#!/bin/bash
export PYTHONPATH=/verify-cert/src

CERT_NAME=$(echo $1 | md5sum - | awk '{print $1}')
CERT_FILENAME=cert-$CERT_NAME

RUN_MPI=0

if [ $RUN_MPI != 0 ]; then
    mpirun ecpp-mpi -n "$1" -c -f /fastecpp/$CERT_FILENAME
else
    ecpp -n "$1" -c -f /fastecpp/$CERT_FILENAME # &> /dev/null
fi

cp /fastecpp/$CERT_FILENAME.primo /verify-cert/certs/

rm /fastecpp/$CERT_FILENAME*

cd /verify-cert

if n=$(./ecpp-verify -i ./certs/$CERT_FILENAME.primo | grep -irn 'certificate is a prime number' -); then
    echo "$1 is prime (certificate: $CERT_FILENAME)" >> foundprimes.txt
    echo "$1 is prime!"
else
    echo "$1 is not prime :(" >> notfoundprimes.txt
    echo "$1 is not prime :("
fi
