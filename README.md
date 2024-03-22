## Terraform for AWS Cloud Architecture Deployment

This reademe outlines the Terraform commands used to deploy an AWS cloud architecture and provides brief explanations for each command.

**Installation and Version Check**

* **`brew install terraform` (macOS only):** Installs Terraform using Homebrew package manager.

```
brew install terraform
```

* **`terraform --version` or `terraform version`:** Verifies the installed Terraform version.

```
terraform --version
```

**Initialization and Configuration**

* **`terraform init`:** Initializes the Terraform workspace, downloading required plugins and initializing the state file.

```
terraform init
```

**Environment Variables**

* **(Security Warning):** Setting environment variables for AWS access credentials (like `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`) in the README is discouraged. It exposes sensitive information. Consider using a credential provider instead.

**Planning and Applying Changes**

* **`terraform plan`:** Generates an execution plan for infrastructure changes based on the current configuration.

```
terraform plan
```

* **`terraform apply -refresh=false`:** Applies the planned infrastructure changes to the cloud provider. `-refresh=false` skips refreshing remote state data before applying.

```
terraform apply -refresh=false
```

* **`terraform plan -out iam.tfplan`:** Creates an execution plan for infrastructure changes and saves it as `iam.tfplan`.

```
terraform plan -out iam.tfplan
```

* **`terraform apply "iam.tfplan"`:** Applies the saved execution plan from `iam.tfplan`.

```
terraform apply "iam.tfplan"
```

* **`terraform apply -target=“aws_iam_user.my_iam_user”`:** Applies changes only to the specific resource `aws_iam_user.my_iam_user`.

```
terraform apply -target="aws_iam_user.my_iam_user"
```

**Destruction and Validation**

* **`terraform destroy`:** Destroys the provisioned infrastructure based on the current configuration. Use with caution!

```
terraform destroy
```

* **`terraform validate`:** Validates the Terraform configuration syntax without applying changes.

```
terraform validate
```

**Formatting and Viewing State**

* **`terraform fmt`:** Formats Terraform configuration files for readability.

```
terraform fmt
```

* **`terraform show`:** Displays information about the provisioned infrastructure resources.

```
terraform show
```

**Variable Usage**

* The following example demonstrates setting a Terraform variable directly in the command:

```
terraform plan -refresh=false -var="iam_user_name_prefix=VALUE_FROM_COMMAND_LINE"
```

**Target-based Application**

* **`terraform apply -target=aws_default_vpc.default`:** Applies changes only to the `aws_default_vpc.default` resource.

```
terraform apply -target=aws_default_vpc.default
```

Similar commands are used to apply changes to specific data sources and resources based on their names or types.

**Workspaces**

* **`terraform workspace show`:** Displays the currently selected Terraform workspace.

```
terraform workspace show
```

* **`terraform workspace new prod-env`:** Creates a new workspace named `prod-env`.

```
terraform workspace new prod-env
```

* **`terraform workspace select default`:** Selects the `default` workspace.

```
terraform workspace select default
```

* **`terraform workspace list`:** Lists all available workspaces.

```
terraform workspace list
```

* **`terraform workspace select prod-env`:** Selects the `prod-env` workspace.

```
terraform workspace select prod-env
```
