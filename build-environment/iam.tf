#######################################################################################
# IAM: Role: s3
#######################################################################################
resource "aws_iam_role" "s3" {
  name               = "aviata"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "s3" {
  name        = "aviata-s3-assumerole"
  description = "This AssumeRole abuse is limited and for one lab"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [ 
              "arn:aws:s3:::${var.bucket}",
              "arn:aws:s3:::${var.bucket}/*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": [ 
              "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.s3.name
  policy_arn = aws_iam_policy.s3.arn
}
