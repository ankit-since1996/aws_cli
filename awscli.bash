#! /bin/bash

aws ec2 create-key-pair --key-name key1 --query 'KeyMaterial' --output text > ~/key1.pem

sg_id=`aws ec2 create-security-group --group-name mysg1 --description mysecuritygroup1 --query 'GroupId'| tr -d '"'`

aws ec2 authorize-security-group-ingress --group-name mysg1 --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 run-instances --image-id ami-0947d2ba12ee1ff75 --instance-type t2.micro --count 1 --security-group-ids $sg_id --key-name key1 > ~/test.txt

vm_id=`cat ~/test.txt | grep "InstanceId" -m 1|cut -d ':' -f 2|tr -d ' "'| tr -d ','`
az=`cat ~/test.txt | grep "Zone" -m 1|cut -d ':' -f 2|tr -d ' "'| tr -d ','`

vlm_id=`aws ec2 create-volume --availability-zone $az --volume-type gp2 --size 1 --query 'VolumeId' | tr -d '"'`

sleep 60s
aws ec2 attach-volume --device /dev/sdb --instance-id $vm_id --volume-id $vlm_id

echi "Hi."




