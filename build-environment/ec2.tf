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

  user_data = file("files/keys.sh")

  subnet_id = aws_subnet.public.id

  tags = {
    Name = "Data Ingestion Server"
  }
}

resource "null_resource" "before_sleep" {
  depends_on = [aws_instance.data_ingestion]
}

resource "time_sleep" "wait_for_cloud_init" {
  create_duration = "180s"

  depends_on = [null_resource.before_sleep]
}

resource "aws_ebs_snapshot" "data_ingest_snapshot" {
  volume_id = aws_instance.data_ingestion.root_block_device[0].volume_id

  depends_on = [time_sleep.wait_for_cloud_init]
} 