#!/bin/bash

if [ $1 = "plan-cost" ]; then
    terraform show -json plan.tfplan | jq -cf terraform.jq 
    read -p "The information above will be sent to modules.tf to estimate the costs. Proceed [Y/n]? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        terraform plan -out=plan.tfplan > /dev/null && terraform show -json plan.tfplan | jq -cf terraform.jq | curl -s -X POST -H "Content-Type: application/json" -d @- https://cost.modules.tf/
    fi

else
    (iamlive --output-file '/home/appuser/output/policy.json' > /dev/null &)
    $@
    kill 0
    sleep 1
    echo PERMISSIONS USED:
    cat /home/appuser/output/policy.json
fi
