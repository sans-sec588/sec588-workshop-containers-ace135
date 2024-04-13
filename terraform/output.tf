output "final_text" {
  value = <<EOF
-------------------------------------------------------------------------------
Role ARN for the first portion of the lab:        ${aws_iam_role.s3_searcher.arn}
Command to run for the first portion of the lab:  s3-account-search ${aws_iam_role.s3_searcher.arn} dev.aviata.cloud
Command to run for EC2 Build:                     

aws ec2 run-instances --image-id $AMI \
                      --region us-east-2 \
                      --count 1 \
                      --instance-type t2.micro \
                      --key-name attacker-key \
                      --security-group-ids ${aws_security_group.ssh.id} \
                      --subnet-id ${aws_subnet.public.id} \
                      --block-device-mappings file:///root/workdir/mappings.json
-------------------------------------------------------------------------------
EOF
}

