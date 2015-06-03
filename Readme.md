# CloudTail

CloudFormation and ECS event tailer.

## Usage

```bash
$ docker build -t cloudtail .
$ docker run \
  -e AWS_REGION=$(aws configure get region)                           \
  -e AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)         \
  -e AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key) \
  cloudtail

ts=1433368415 id=Service msg="convox Custom::ECSService CREATE_COMPLETE"
ts=1433375012 id=8858edf9 msg="(service sinatra) registered 1 instances in (elb sinatra)"
```