#!/bin/bash

terraform apply -auto-approve
$(terraform output -raw runcmd)