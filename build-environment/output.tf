output "ebs_snap_id" {
    value = aws_ebs_snapshot.data_ingest_snapshot.id
}

output "runcmd" {
    value = "aws ec2 modify-snapshot-attribute --snapshot-id ${aws_ebs_snapshot.data_ingest_snapshot.id} --attribute createVolumePermission --operation-type add --group-names all --region ${var.region} --profile ${var.profile}"
}