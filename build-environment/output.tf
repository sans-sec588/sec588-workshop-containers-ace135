output "ebs_snap_id" {
  value = aws_ebs_snapshot.data_ingest_snapshot.id
}

output "runcmd" {
  value = "aws ec2 modify-snapshot-attribute --snapshot-id ${aws_ebs_snapshot.data_ingest_snapshot.id} --attribute createVolumePermission --operation-type add --group-names all --region ${var.region} --profile ${var.profile}"
}

output "s3_url" {
  description = "S3 hosting URL (HTTP)"
  value       = aws_s3_bucket_website_configuration.dev_site.website_endpoint
}