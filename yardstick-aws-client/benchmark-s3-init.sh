#!/bin/bash

# Set aws credentionals.
echo $AWS_ACCESS_KEY:$AWS_SECRET_KEY > /etc/passwd-s3fs

chmod 640 /etc/passwd-s3fs

# Mount ES3 bucket.
OUT_FOLDER="yardstick-benchmark"

if [ ! -z "$ES3_BUCKET" ]; then
    OUT_FOLDER=$ES3_BUCKET
fi

s3cmd --access_key="$AWS_ACCESS_KEY" --secret_key="$AWS_SECRET_KEY" mb s3://"$OUT_FOLDER"

s3fs $OUT_FOLDER /mnt