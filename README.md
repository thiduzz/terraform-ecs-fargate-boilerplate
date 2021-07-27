
# Terraform ECS Fargate Boilerplate

This is a personal boilerplate to enable me to quickly provision and destroy my personal projects for testing in a remote environment.


## Installation

* Install Terraform by clicking [here](https://learn.hashicorp.com/tutorials/terraform/install-cli) and following the instructions.
* Install AWS CLI by clicking [here](https://aws.amazon.com/cli/) and following the instructions.
* Configure your AWS CLI configurations - the project assume that you are using the "default" profile of AWS CLI.

## Run Locally

1. Clone the project
2. Go to the project directory
3. Install AWS Provider

```bash
  terraform init
```

4. Switch the image name you want to provision (`container.tf` within `ecs-task-env-test`)
    * You may utilize the sample Nginx Dockerfile to generate a Nginx container for testing   
5. Apply the changes to the AWS Infrastructure

```bash
  terraform apply
```

## Optimizations

1. Introduce CodeDeploy/CodeBuild/Pipeline
2. Introduce private ECR Repository
3. Introduce local variables to the .tfs 

## License

[MIT](https://choosealicense.com/licenses/mit/)
  
