!#/bin/bash

echo "Netegem els recursos d'AWS creats amb CloudFormation..."
aws cloudformation delete-stack --stack-name $1
aws cloudformation wait stack-delete-complete --stack-name $1
echo "Stack eliminat correctament."
