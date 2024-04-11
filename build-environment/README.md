# README

This is for the build environment to replicate what aviata.cloud has on their backend.

1. Take a look at the `terraform.tfvars.example` file, this file shows you the variables you can specify for the run.
2. Rename or copy the file to `terraform.tfvars`
3. Run the build.sh file in Linux or Mac. In windows run: `terraform output -raw runcmd`, and then copy that in the command prompt to execute the final part of the run.
