# Source - https://github.com/vmware-tanzu/velero-plugin-for-aws#Create-S3-bucket
# AWS Setup

BUCKET=velero-avs
REGION=us-east-1

aws s3api create-bucket \
    --bucket $BUCKET \
    --region us-east-1

aws iam create-user --user-name velero

cat > velero-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET}"
            ]
        }
    ]
}
EOF

aws iam put-user-policy \
  --user-name velero \
  --policy-name velero \
  --policy-document file://velero-policy.json

aws iam create-access-key --user-name velero

Update the credentails to credentials-velero.template file

## CSI #############################################################################################################

velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.1.0,vsphereveleroplugin/velero-plugin-for-vsphere:1.0.1 \
    --bucket $BUCKET \
    --backup-location-config region=$REGION \
    --snapshot-location-config region=$REGION \
    --secret-file ./credentials-velero.template 

velero plugin add vsphereveleroplugin/velero-plugin-for-vsphere:1.0.1


kubectl create secret generic vsphere-config-secret \
    --from-file=csi-vsphere.conf \
    --namespace=kube-system

## Restic #######################################################################################################

cd /Users/avsh/code/personal/repo/sampleapps-k8s/velero

BUCKET=velero-avs
REGION=us-east-1

velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.1.0 \
    --bucket $BUCKET \
    --backup-location-config region=$REGION \
    --snapshot-location-config region=$REGION \
    --secret-file ./credentials-velero.template \
    --use-restic

## TKGI update 
## kubectl edit ds restic -n velero
## /var/vcap/data/kubelet/pods

velero backup-location create test-backup \
    --provider aws \
    --bucket $BUCKET \
    --access-mode=ReadOnly
    --config region=us-east-1
    --secret-file ./credentials-velero.template