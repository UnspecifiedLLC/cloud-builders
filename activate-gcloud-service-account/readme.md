Activate a service account for gcloud. The volumes from this container can be used in subsequent cloud-builders to use this activated account.
Usage:

0. Define an environment variable GCLOUD_SERVICE_KEY that holds the service account key; this should be base64 encoded, and it should be SECRET!

1. Create a volume to be shared between gcloud-derived containers:
  - docker volume create activated_service-account

2. Run the gcloud-config container to activate a Google Cloud service account
  - docker run -it --rm
    --mount source=activated_service-account,target=/root/.config/gcloud
    -e GCLOUD_SERVICE_KEY=${GCLOUD_SERVICE_KEY}
    unspecifiedllc/gcloud-config:latest

3. In subsequent containers that should operate as the activated service account, mount the volume same volume
  - docker run -it --rm
    --mount source=activated_service-account,target=/root/.config/gcloud
    gcr.io/cloud-builders/gcloud auth list