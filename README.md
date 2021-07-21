
# Terraform ECS Fargate Boilerplate

This is a personal boilerplate to enable me to quickly provision and destroy my personal projects for testing in a remote environment.


## Installation

* Install Terraform by clicking [here](https://learn.hashicorp.com/tutorials/terraform/install-cli) and following the instructions.
* Install AWS CLI by clicking [here](https://aws.amazon.com/cli/) and following the instructions.
* Configure your AWS CLI configurations - the project assume that you are using the "default" profile.

## Run Locally

Clone the project

Go to the project directory

Install AWS Provider

```bash
  terraform init
```

Apply the changes to the AWS Infrastructure

```bash
  terraform apply
```

## License

[MIT](https://choosealicense.com/licenses/mit/)
  