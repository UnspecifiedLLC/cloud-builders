docker run -it \
  -e GCLOUD_SERVICE_KEY=$GCLOUD_SERVICE_KEY \
  --name gcloud-service-account \
  unspecifiedllc/activate-gcloud-service-account:latest

(Making a public repository)[https://cloud.google.com/container-registry/docs/access-control#serving_images_publicly]

(Using bind mounts)[https://docs.docker.com/v17.09/engine/admin/volumes/bind-mounts/]

(creating service accounts)[https://cloud.google.com/docs/authentication/getting-started]

(travis build lifecycle)[https://docs.travis-ci.com/user/customizing-the-build/#The-Build-Lifecycle]

(Google Cloud Platform cloud-builders)[https://github.com/GoogleCloudPlatform/cloud-builders]

(http://gcr.io/un-cloud-builders/fission:latest) fission builder

(medium article using cloud builders, key ring, volumes)[https://medium.com/@lestrrat/taming-google-container-builder-22a6dded155c]

(google cloud articale on authroziation)[https://cloud.google.com/sdk/docs/authorizing]
  - credential files are stored in /home/username/.config/gcloud. suggests that reusing this volume is the way cloudbuilder passes auth between containers.

docker run -it --rm --mount source=<volume>,target=/root/.config/gcloud gcr.io/un-cloud-builders/gcloud-config:latest


docker run -it --rm -e GCLOUD_SERVICE_KEY=`cat ~/Desktop/GCR_SERVICE_KEY.txt` --mount source=gcloud,target=/root/.config/gcloud gcr.io/un-cloud-builders/gcloud-config:latest

docker run -it --rm --mount source=gcloud,target=/root/.config/gcloud gcr.io/un-cloud-builders/gcloud-config:latest

  # master:
  #   unspecified/cloud-builders-gcloud-config:latest
  #   gcr.io/un-cloud-builders/build-config:latest
  # tag:
  #   unspecified/cloud-builders-gcloud-config:<tag>
  #   gcr.io/un-cloud-builders/build-config:<tag>
  # pull request:
  #   unspecified/cloud-builders-gcloud-config:<branch>
  #   gcr.io/un-cloud-builders/build-config:<branch>
  # other:

after_script:
  docker volume rm config-gcloud


Location of key file after config:
/root/.config/gcloud/legacy_credentials/un-cloud-builders-sa@un-cloud-builders.iam.gserviceaccount.com

File listing the default gcloud account:
~/.config/gcloud# cat configurations/config_default

location of key file using 'account' from config_default:
/root/.config/gcloud/legacy_credentials/${account}


sudo: false
language: generic

services:
  - docker

env:
  global:
    - BASENAME=GCLOUD-CONFIG

before_install:

install:
  - docker pull gcr.io/cloud-builders/docker
  - docker volume create config-gcloud

script:
  - docker build -t gcr.io/un-cloud-builders/gcloud-config:${COMMIT_TAG} .
  - docker run -it --rm
    --mount source=config-gcloud,target=/root/.config/gcloud
    -e GCLOUD_SERVICE_KEY=${GCLOUD_SERVICE_KEY}
    gcr.io/un-cloud-builders/gcloud-config:${COMMIT_TAG}

  - docker run -itd --rm
    --name docker-client
    --mount source=config-gcloud,target=/root/.config/gcloud
    -v /var/run/docker.sock:/var/run/docker.sock
    --entrypoint /bin/sleep
    gcr.io/cloud-builders/docker inf

  - docker exec -it docker-client /root/.config/gcloud/gcloud-config/scripts/shared/gcr_docker_login.bash
  # removing this for now; dockerhub does not seem to suppport service accounts for
  #- docker exec -it docker-client /root/.config/gcloud/gcloud-config/scripts/shared/dockerhub_login.bash

  # Removing this; both dockerhub and GCR are building their own images from triggered builds.
  #TODO: this build should be triggered by
  # - python build/publish.py gcr.io/un-cloud-builders/gcloud-config ${COMMIT_TAG} unspecified/cloud-builders-gcloud-config

after_script:
  - docker rm --force docker-client
  - docker volume rm config-gcloud