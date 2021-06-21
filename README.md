# Rony CI docker image

This repository presents a docker recipe for creating a image to be used on the [Rony](https://github.com/A3Data/rony) framework.

The image can be used on to deploy infrastructure on AWS, using Terraform.

This image enables AWS cli CMS mode, and uses [iamlive](https://github.com/iann0036/iamlive) to track all the permissions used for each Terraform run.

The image also includes a call to [modules.tf](https://github.com/antonbabenko/terraform-cost-estimation) to estimate the cost the infrastructure to be deployed will have. This call can be made using the command `make tf-plan-cost`. All the information to be sent is anonymized and needs to be approved by the user before it is sent.

## Using

To use the image, just include the following `docker-compose.yml` and `Makefile` to your project. All your terraform files need to be on the folder `./infrastructure`.

Instead of using the commands `terraform init`, `terraform apply`, etc.. you will use the commands specified on the Makefile `make tf-init`, `make tf-plan` etc.

The permissions used will be displayed on the terminal and saved to the file `iamlive_output/policy.json`.

``` yml
version: '3.7'

services:

  rony-ci:
    image:
      ratorres7/rony-ci-test:latest
    volumes:
      - ./infrastructure:/infrastructure
      - ./iamlive_output:/home/appuser/output
    working_dir: /infrastructure
    environment:
      - AWS_CSM_ENABLED=true
      - AWS_CSM_PORT=31000
      - AWS_CSM_HOST=127.0.0.1
      - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
      - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
      - AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}
```

``` makefile
#####################################################
# Makefile containing shortcut commands for project #
#####################################################

# MACOS USERS:
#  Make should be installed with XCode dev tools.
#  If not, run `xcode-select --install` in Terminal to install.

# WINDOWS USERS:
#  1. Install Chocolately package manager: https://chocolatey.org/
#  2. Open Command Prompt in administrator mode
#  3. Run `choco install make`
#  4. Restart all Git Bash/Terminal windows.

.PHONY: tf-init
tf-init:
	docker-compose run --rm rony-ci terraform init

.PHONY: tf-fmt
tf-fmt:
	docker-compose run --rm rony-ci terraform fmt

.PHONY: tf-show
tf-show:
	docker-compose run --rm rony-ci terraform show

.PHONY: tf-validate
tf-validate:
	docker-compose run --rm rony-ci terraform validate

.PHONY: tf-plan
tf-plan:
	docker-compose run --rm rony-ci terraform plan

.PHONY: tf-apply
tf-apply:
	docker-compose run --rm rony-ci terraform apply

.PHONY: tf-destroy
tf-destroy:
	docker-compose run --rm rony-ci terraform destroy

.PHONY: tf-workspace-dev
tf-workspace-dev:
	docker-compose run --rm rony-ci terraform workspace select dev

.PHONY: tf-workspace-staging
tf-workspace-staging:
	docker-compose run --rm rony-ci terraform workspace select staging

.PHONY: tf-workspace-prod
tf-workspace-prod:
	docker-compose run --rm rony-ci terraform workspace select prod

.PHONY: tf-plan-cost
tf-plan-cost:
	docker-compose run --rm rony-ci plan-cost

```