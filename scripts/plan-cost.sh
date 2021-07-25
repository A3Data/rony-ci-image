#!/bin/bash

terraform plan -out=plan.tfplan > /dev/null && terraform show -json plan.tfplan | tail -n +2 | jq -cf /bin/terraform.jq
terraform show -json plan.tfplan
read -p "The information above will be sent to modules.tf to estimate the costs. Proceed [y/n]? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo ""
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color
    echo -e "${GREEN}COST ESTIMATION:${NC}"
    terraform show -json plan.tfplan | tail -n +2 | jq -cf /bin/terraform.jq | curl -s -X POST -H "Content-Type: application/json" -d @- https://cost.modules.tf/ | python3 -m json.tool
fi
echo