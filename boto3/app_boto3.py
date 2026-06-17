import boto3
from pprint import pprint

client = boto3.client('ec2', region_name='us-east-1')
response = client.run_instances(
        ImageId='ami-0521cb2d60cfbb1a6',
        InstanceType='t2.micro',
        MinCount=1,
        MaxCount=1
    )

print(response)


