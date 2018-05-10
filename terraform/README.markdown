# [Terraform](https://www.terraform.io/docs) cloud builder

[Request for Terraform builder](https://github.com/GoogleCloudPlatform/cloud-builders/issues/233)

## Terraform backend
The default backend for Terraform is local, which will store state information in local files. The .terraform directory will be created in the working directory.

Most build platforms (i.e., GCE) do not persist the working directory between builds. Losing this state information is no bueno.

There are a couple of options for managing Terraform state across builds:

###### Ignore the issue
In your build, you'll want to initialize terraform and refresh the local state. This is really not a good idea; it'll be slow and not mutli-run safe (if multiple runs kick off concurrently, there'll be nastiness like race conditions).
 terraform init
 terraform refresh
###### Persist the state in a GCS bucket manually
In your build, set up steps to manually fetch the state before running Terraform, then push it back up after Terraform is done. This will help by removing the need to init & refresh on every build; but will not address the concurrency issues.
###### Use Terraform backends
This is probably what you want to do. You'll still need to set up your GCS storage, and you'll need to configure the backend in your tf configurations. Some backends (happily, the [GCS](https://www.terraform.io/docs/backends/types/gcs.html) one does!) support locking of the remote state. This helps address the concurrency issue.

## Using this builder with Google Container Engine
To use this builder, your [builder service account](https://cloud.google.com/container-builder/docs/how-to/service-account-permissions) will need IAM permissions sufficient for the operations you want to perform.

**add necessary privileges for service account**

Refer to the Google Cloud Platform [IAM integration page](https://cloud.google.com/container-engine/docs/iam-integration) for more info.

## Using this builder image anywhere
This image can be run on any Docker host, without GCE. Why would you want to do this? It'll let you run Terraform locally, with no environment dependencies other than a Docker host installation. You can use the [local Container Builder](https://cloud.google.com/container-builder/docs/build-debug-locally) for this; but if you're curious or have
wierd / advanced requirements, it is an option.

You'll need to:
 1. Provide a service account key file
 2. Mount your project directory at '/workspace' when you run docker
 ```sh
docker run -it --rm -e GCLOUD_SERVICE_KEY=${GCLOUD_SERVICE_KEY} \
  --mount type=bind,source=$PWD,target=/workdir \
  -w="/workdir" \
  gcr.io/$PROJECT_ID/terraform <command>
```

## Building this builder
To build this builder, run the following command in this directory.
```sh
$ gcloud container builds submit . --config=cloudbuild.yaml
```


[This page](https://www.terraform.io/docs) from the terraform docs talks about using remote storage when running terraform.

You can provide the name of a storage bucket where terraform state should be kept between builds. If provided, then this builder will
 1. check if the bucket exists. If it does, it will pull terraform state from that bucket and restore it in ```./.terraform```
 2. Run terraform with the runtime arguments
 3. zip ./.terraform and push it up to the bucket.
The zipped file be encrypted locally before pushing to the bucket. Buckets are also encrypted at rest. The state information is encrypted in transit & at rest.

docker run -e GCLOUD_SERVICE_KEY=${GCLOUD_SERVICE_KEY} tf:latest <command>

docker run -it --rm -e GCLOUD_SERVICE_KEY=${GCLOUD_SERVICE_KEY} \
  --mount type=bind,source=$PWD,target=/workdir \
  -w="/workdir" \
  tf:latest <command>


  https://github.com/tasdikrahman/terraform-gcp-examples/tree/master/test-env/test-gcp-instance