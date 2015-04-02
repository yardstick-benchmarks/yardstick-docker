#!/bin/bash

cnt_bench=$(ls results* 2>/dev/null | wc -l)

if [ ${cnt_bench} == 0 ]; then
    echo "Benchmark result not found!"

    exit 1
fi

# Export benchmark label
while read p; do
    if [[ ${p} == BENCHMARK_LABEL* ]]; then
        export BENCHMARK_LABEL=$(echo ${p} | sed 's/.*=\(.*\)/\1/')
    fi
done < config/benchmark-ec2.properties

# Ploat result.
for file in results-*
do
    bin/jfreechart-graph-gen.sh -gm STANDARD -i ${file}
done

# Rename file.
rename "s/results/$BENCHMARK_LABEL-results/" results*

# Zip results.
for dir in "$BENCHMARK_LABEL"-results-*
do
    base=$(basename "$dir")
    zip -r "${base}.zip" "$dir"
done

echo "Start to upload results to storage."

mv "$BENCHMARK_LABEL"-results-* /mnt

echo "Results uploaded."

# If remote dir contains benchmark result then will generate compare graph.
cnt_bench=$(ls /mnt/*-results-*.zip 2>/dev/null | wc -l)

if [ ${cnt_bench} -gt 1 ]; then
    echo "Remote directory contains another benchmark results.";
    # Create remove directory and copy results to temp dir.
    mkdir temp_comp

    echo "Start to download results from storage."

    cp /mnt/*-results-*.zip ./temp_comp

    echo "Results downloaded."

    for filename in temp_comp/*.zip
    do
      unzip $filename -d temp_comp
    done

    rm -rf temp_comp/*.zip

    lsArra=(./temp_comp/*-results-*)

    bin/jfreechart-graph-gen.sh -gm COMPARISON -i ${lsArra[@]}

    for dir in results-comparison-*
    do
        base=$(basename "$dir")
        zip -r "${base}$(date -d "today" +"%H%M")" "$dir"
        mv "$dir" "${base}$(date -d "today" +"%H%M")"
    done

    echo "Start upload comparison to storage."

    mv results-comparison-* /mnt

    echo "Comparison results uploaded."

    rm -rf results-comparison-*

    rm -rf temp_comp
fi;

chmod -R 755 /mnt/*

# Set acl public.
BUCKET=$(../benchmark-user-data.sh ES3_BUCKET)

if [ -z "$BUCKET" ]; then
    BUCKET="yardstick-benchmark"
fi

s3cmd --access_key=$(../benchmark-user-data.sh AWS_ACCESS_KEY) \
    --secret_key=$(../benchmark-user-data.sh AWS_SECRET_KEY) setacl s3://"$BUCKET" \
    --acl-public --recursive