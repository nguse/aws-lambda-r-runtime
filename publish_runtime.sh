#!/bin/bash

set -euo pipefail

VERSION=${1:=3.5.1}
STARTING_DIR=$(pwd)

if [ -z "$VERSION" ];
then
    echo 'version number required'
    exit 1
fi

cd /opt/R/

zip -r $STARTING_DIR/R-$VERSION.zip bin/ lib/ lib64/ etc/ library/ doc/ modules/ share/

cd $STARTING_DIR

rm -rf R/
unzip -q R-$VERSION.zip -d R/
rm -r R/doc/manual/
#remove some libraries to save space
recommended=(boot class cluster codetools foreign KernSmooth lattice MASS Matrix mgcv nlme nnet rpart spatial survival)
for package in "${recommended[@]}"
do
   rm -r R/library/$package/
done
chmod -R 755 bootstrap runtime.R R/
rm -f runtime.zip
zip -r -q runtime.zip runtime.R bootstrap R/

aws s3 cp runtime.zip s3://nrt-precipitation-potential-forecast/runtime.zip

# --zip-file was not working
aws lambda publish-layer-version --layer-name r-runtime --content S3Bucket=nrt-precipitation-potential-forecast,S3Key=runtime.zip

echo "next, publish_function.sh"
