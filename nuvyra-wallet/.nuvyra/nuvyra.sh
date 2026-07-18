#!/bin/bash
BASE="$(dirname "$0")"
bash "$BASE/core/collector.sh"
bash "$BASE/core/analyzer.sh"
bash "$BASE/core/scorer.sh"
bash "$BASE/core/reporter.sh"
