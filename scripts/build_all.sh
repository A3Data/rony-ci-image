export DOCKERHUB_USER=ronya3data
export DOCKERHUB_REPO=rony-ci
export RONY_CI_VERSION=0.0.1
export IAMLIVE_VERSION=0.40.0

for terraform_version in 0.15.5 1.1.3
do
    export TERRAFORM_VERSION=$terraform_version
    ./scripts/build_and_push.sh
done