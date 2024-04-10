# README

1. You need to have an SSH public key in the system.
    `aws ec2 import-key-pair --key-name moses --public-key-material fileb://$HOME/.ssh/id_rsa.pub --profile=moses --region=us-east-1`

2.  Run the build.sh file.

$  aws ec2 modify-snapshot-attribute --snapshot-id $(terraform output -raw ebs_snap_id) --attribute createVolumePermission --operation-type add --group-names all
