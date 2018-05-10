# [Terraform](https://www.terraform.io/docs) cloud builder

## Terraform state
Terraform keeps information about deployment status in local files. The .terraform directory in created in the working directory.

### Persisting terraform state across builds
Most build environemnt (GCE included) do not persist the working directory between builds. If you run terraform multiple times with the same config but without the state files from previous runs, it is no bueno. [This page](https://www.terraform.io/docs) from the terraform docs talks about using remote storage when running terraform.

You can provide the name of a storage bucket where terraform state should be kept between builds. If provided, then this builder will
 1. check if the bucket exists. If it does, it will pull terraform state from that bucket and restore it in ```./.terraform```
 2. Run terraform with the runtime arguments
 3. zip ./.terraform and push it up to the bucket.
The zipped file be encrypted locally before pushing to the bucket. Buckets are also encrypted at rest. The state information is encrypted in transit & at rest.

## Using this builder with Google Container Engine
To use this builder, your [builder service account](https://cloud.google.com/container-builder/docs/how-to/service-account-permissions) will need IAM permissions sufficient for the operations you want to perform.

**add necessary privileges for service account**

Refer to the Google Cloud Platform [IAM integration page](https://cloud.google.com/container-engine/docs/iam-integration) for more info.

## Using this builder anywhere else
This image can be run locally, without GCE. When run, you'll need to:
 1. Provide a service account key file
 2. Mount your project directory at '/workspace' when you run docker:
 ```sh
 docker run -it --rm -e GCLOUD_SERVICE_KEY=${your base64 encoded service key file} \
    --mount source=.,target=/workspace \
    gcr.io/$PROJECT_ID/terraform
 ```
 3. If you want the .terraform directory persisted in cloud storage in your GCP project, provide a bucket name:
 ```sh
 docker run -it --rm -e GCLOUD_SERVICE_KEY=${your base64 encoded service key file} \
    --mount source=.,target=/workspace \
    -e GCLOUD_TERRAFORM_STATE_BUCKET=${name of the bucket for terraform state}
    gcr.io/$PROJECT_ID/terraform
 ```
 4. If you want the terraform state encrypted (recommended) then provide the ID for a secret that will hold the encryption key:
 ```sh
 docker run -it --rm -e GCLOUD_SERVICE_KEY=${your base64 encoded service key file} \
    --mount source=.,target=/workspace \
    -e GCLOUD_TF_BUCKET=${name of the bucket for terraform state}
    -e GCLOUD_TF_KEYRING=${ID of the keyring holding the encryption key}
    -e GCLOUD_TF_KEY=${ID of the encryption key}
    gcr.io/$PROJECT_ID/terraform
 ```

## Building this builder
To build this builder, run the following command in this directory.
```sh
$ gcloud container builds submit . --config=cloudbuild.yaml
```