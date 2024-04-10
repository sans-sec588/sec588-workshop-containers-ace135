#!/bin/bash

terraform apply
$(terraform output -raw runcmd)