sudo apt-get update -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

sudo apt-get -y purge unzip
unzip awscliv2.zip

sudo ./aws/install
aws --version

AWS_ACCESS_KEY_ID=AKIAVN4GXCZGEUHE7JEH
AWS_ACCESS_KEY_SECRET=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
AWS_REGION=us-east-1


aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile aws_creds && aws configure set aws_secret_access_key "$AWS_ACCESS_KEY_SECRET" --profile aws_creds && aws configure set region "$AWS_REGION" --profile aws_creds && aws configure set output "text" --profile aws_creds

aws sts get-caller-identity

aws eks --region region update-kubeconfig --name demo-cluster


