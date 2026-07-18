#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd)"

bash $BASE/core/collector.sh
bash $BASE/core/security.sh
bash $BASE/core/build.sh
bash $BASE/core/scorer.sh
bash $BASE/core/report.sh

cat $BASE/reports/final_report.txt
