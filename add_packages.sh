#!/bin/bash

set -euo pipefail

VERSION=${1:=3.5.1}

if [ -z "$VERSION" ];
then
    echo 'version number required'
    exit 1
fi

cd /opt/R/

./bin/Rscript -e 'chooseCRANmirror(graphics=FALSE, ind=34); install.packages("httr")'
./bin/Rscript -e 'chooseCRANmirror(graphics=FALSE, ind=34); install.packages("aws.s3")'

echo "next, publish_runtime.sh"
