## Velero

Velero can be used to back up and restore your Kubernetes cluster resources and persistent volumes

### Velero Docs

- [Velero Docs](https://velero.io/docs/v1.4/basic-install/)
- [Install CLI](https://velero.io/docs/v1.4/basic-install/)

### Copy Images to Container Registry

```
export REGISTRY_HOST=harbor.tkgi.com

export PROJECT=velero
```

1. Copy the Velero Image version based on Velero CLI Version from [repo](https://github.com/vmware-tanzu/velero/releases)

    > docker pull velero/velero:v1.4.2
2. Push to private registry
    > docker push $REGISTRY_HOST/$PROJECT/velero:v1.4.2
3. Same for [Velero Plugin](https://github.com/vmware-tanzu/velero-plugin-for-aws). Compatibility section mapping for plugin image version to Velero Version
  
    > docker pull velero/velero-plugin-for-aws:v1.1.0

    > docker push $REGISTRY_HOST/$PROJECT/velero-plugin-for-aws:v1.1.0


### Install Velero to the source cluster

```
VeleroImage=$REGISTRY_HOST/$PROJECT/velero:v1.4.2

VeleroPlugin=$REGISTRY_HOST/$PROJECT/velero-plugin-for-aws:v1.1.0

BUCKET=velero

REGION=minio,s3ForcePathStyle="true",s3Url=http://<external-ip of minio>:<port>
```

> velero install \
    --provider aws \
    --image $VeleroImage \
    --plugins $VeleroAWSPlugin \
    --bucket $BUCKET \
    --backup-location-config region=$REGION \
    --snapshot-location-config region=$REGION \
    --secret-file ./credentials-velero.template \
    --use-restic

### Velero Restic plugin install for TKGI

[Issue](https://github.com/vmware-tanzu/velero/issues/2767)

```
kubectl edit daemonset restic -n velero

change hostPath from /var/lib/kubelet/pods to /var/vcap/data/kubelet/pods:

Example:

hostPath:
 path: /var/vcap/data/kubelet/pods
```

Check the status of pods and Ensure velero is running successful

### Backup Stateless Applications Application

> velero backup create yelb-backup-v1 --include-namespaces yelb

> velero describe backup yelb-backup-v1 --details

### Backup Stateful Applications Application

Restic rus as daemonset. It requires pod to have annotatation to handles the PodVolumeBackups for pods on that node

> kubectl -n yelb annotate pod/redis-server-0 backup.velero.io/backup-volumes=redis-persistent-storage

> velero backup create yelb-backup-v1 --include-namespaces yelb

> velero describe backup yelb-backup-v1 --details


### Restore backups to the target cluster

1. Install Velero in target cluster. 
2. `velero get backup` will show the existing backups as same bucket name provided during install.

> velero restore create --from-backup yelb-backup-v1

> velero describe restore yelb-backup-v4-20210111115805 --details
