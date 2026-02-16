#!/bin/bash

echo "Netegem els recursos d'AWS manualment creats..."

# 1. Eliminar instàncies EC2
echo "Eliminant instàncies EC2..."
instances=$(aws ec2 describe-instances --query "Reservations[].Instances[?State.Name=='running'].InstanceId[]" --output text)
if [ -n "$instances" ]; then
  aws ec2 terminate-instances --instance-ids $instances
  echo "Esperant que les instàncies EC2 es terminin..."
  aws ec2 wait instance-terminated --instance-ids $instances
else
  echo "No hi ha instàncies EC2 actives."
fi

# 2. Eliminar bases de dades RDS
echo "Eliminant bases de dades RDS..."
databases=$(aws rds describe-db-instances --query "DBInstances[].DBInstanceIdentifier" --output text)
for db in $databases; do
  aws rds delete-db-instance --db-instance-identifier $db --skip-final-snapshot
  echo "Esperant que la base de dades $db s'elimini..."
  aws rds wait db-instance-deleted --db-instance-identifier $db
done

# 3. Eliminar Launch Templates
echo "Eliminant Launch Templates..."
launch_templates=$(aws ec2 describe-launch-templates --query "LaunchTemplates[].LaunchTemplateId" --output text)
for lt in $launch_templates; do
  aws ec2 delete-launch-template --launch-template-id $lt
done

# 4. Eliminar grups de seguretat
echo "Eliminant grups de seguretat..."
security_groups=$(aws ec2 describe-security-groups --query "SecurityGroups[?GroupName!='default'].GroupId" --output text)
for sg in $security_groups; do
  aws ec2 delete-security-group --group-id $sg
done

# 5. Eliminar VPC
echo "Eliminant VPC..."
vpcs=$(aws ec2 describe-vpcs --query "Vpcs[?IsDefault!=\`true\`].VpcId" --output text)
if [ -n "$vpcs" ]; then
  for vpc in $vpcs; do
    aws ec2 delete-vpc --vpc-id $vpc
  done
else
  echo "No hi ha VPCs creats manualment."
fi

# Check vpc dependencies
dependencies=$(aws ec2 describe-vpc-endpoints --query "VpcEndpoints[].VpcEndpointId" --output text)

echo "Tots els recursos manualment creats han estat eliminats (en la mesura del possible)."
