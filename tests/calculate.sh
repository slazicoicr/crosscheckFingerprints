#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

#enter the workflow's final output directory ($1)
# cd $1

cat *.crosscheck_metrics.txt | grep -vE "^#" | md5sum
cat *.crosscheck_metrics.matrix | md5sum
