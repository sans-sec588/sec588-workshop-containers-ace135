resource "local_file" "cloud_init_ingest_template" {
  content = templatefile("${path.module}/templates/cloud-init-ingest.tmpl", {

  })
  filename = "${path.module}/files/cloud-init-ingest.yaml"
}

data "local_file" "cloud_init_ingest_yaml" {
  filename   = local_file.cloud_init_ingest_template.filename
  depends_on = [local_file.cloud_init_ingest_template]
}


data "aws_ami" "alpine_pinned" {
  most_recent = true
  owners      = ["538276064493"]

  filter {
    name   = "name"
    values = ["alpine*x86_64-bios-cloudinit-r0"]
  }

  filter {
    name   = "description"
    values = ["Alpine Linux*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "data_ingestion" {
  ami           = data.aws_ami.alpine_pinned.id
  instance_type = "t2.micro"

  user_data = data.local_file.cloud_init_ingest_yaml.content

  subnet_id = aws_subnet.public.id
  
  tags = {
    Name = "Data Ingestion Server"
  }
}

resource "aws_ebs_snapshot" "data_ingest_snapshot" {
  volume_id = aws_instance.data_ingestion.root_block_device[0].volume_id

}