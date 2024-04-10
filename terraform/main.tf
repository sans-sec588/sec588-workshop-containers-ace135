data "aws_caller_identity" "current" {}

# This is the policy for the s3 role to use in the initial access method

resource "aws_iam_policy" "s3_searcher_policy" {
  name        = "s3-searcher"
  description = "SEC588 Container Lab Searcher Policy"
  policy      = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::*/*"
		},
		{
			"Sid": "VisualEditor1",
			"Effect": "Allow",
			"Action": "s3:ListBucket",
			"Resource": "arn:aws:s3:::*"
		}
	]
}
EOF
}

resource "aws_iam_role" "s3_searcher" {
  name               = "s3-searcher"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "AWS": "${data.aws_caller_identity.current.account_id}"
            },
            "Condition": {}
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_searcher" {
  role       = aws_iam_role.s3_searcher.name
  policy_arn = aws_iam_policy.s3_searcher_policy.arn
}


