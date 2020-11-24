#!/bin/bash

for profile in $(aws configure list-profiles)
do
    region=`aws configure get region --profile $profile`
    echo "AWS Profile: $profile"
    echo "Region:      $region"
    echo
    terraform apply -var "profile=$profile" -var "region=$region" -state "$profile.tfstate"
done
