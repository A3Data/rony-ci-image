#!/bin/sh

export AWS_CSM_ENABLED=true
export AWS_CSM_PORT=31000
export AWS_CSM_HOST=127.0.0.1

(iamlive --output-file './policy.json' > /dev/null &)
$@

pkill iamlive

sleep 1
echo ""
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo "${GREEN}PERMISSIONS USED:${NC}"
cat ./policy.json
