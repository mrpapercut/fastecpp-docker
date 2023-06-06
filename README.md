# FastECPP in Docker

This repo aims to run FastECPP checks in Docker.

## Usage
Run ./build.ps1 and ./run.ps1 to start the container

While in the container terminal, use `runandverify.sh` if you just want to check a number:
```bash
# Single number
./runandverify.sh "10^500+10^499+10^460+1"

# From a file
while IFS= read -r line; do ./runandverify.sh $line; done < testnumbers.txt
```
One of the generated certificates (.primo) can be found in `./certs`

Run the following to perform only the ECPP check and get the certificates:
```bash
ecpp -n '10^500+10^499+10^460+1' -c -f /fastecpp/certs/cert-500-499-460
```

Run the following to verify generated certificates:
```bash
export PYTHONPATH=/verify-cert/src
/verify-cert/ecpp-verify -i /fastecpp/certs/cert-500-500-499-460
```

## Notes
FastECPP is _relatively_ fast. It takes a fast PC on a single core around 35 seconds to test & verify a 1000 digit number, but over 500 seconds to process a 2000 digit number. With multiple cores times are a lot better, but should be tested for better insights. Don't expect to prove any million digit PRP soon
