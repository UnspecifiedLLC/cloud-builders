#!/bin/bash
# base64 decode the given GCLOUD_SERVICE_KEY into a tmp json file
# activate the account

# If there is no current context, get one.
if [ ! -z "$GCLOUD_SERVICE_KEY" ]
then
    rootdir=/root/.config/gcloud-config
    mkdir -p $rootdir
    tmpdir=$(mktemp -d "$rootdir/servicekey.XXXXXXXX")
    trap "echo deleting temp dir ${tmpdir}; rm -rf $tmpdir" EXIT
    echo "created tmp dir: ${tmpdir}"
    echo ${GCLOUD_SERVICE_KEY} | base64 --decode -i > ${tmpdir}/gcloud-service-key.json
    gcloud auth activate-service-account --key-file ${tmpdir}/gcloud-service-key.json
else
    echo "\$GCLOUD_SERVICE_KEY environment variable is not set"
fi

active_account=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" 2> /dev/null)

function funct_usage() {
    cat <<EOF
No gcloud account is active.

To make use of this container:
1) Run this image with the service account credentials base64 encoded as an environment variable. Don't remove it immediately; we'll be using it's volumes later:
$ docker run -it unspecifiedllc/activate-gcloud-service-account:latest \
    -e GCLOUD_SERVICE_KEY=<base64 encoded Google service key> \
    -name gcloud-service-account
2) Use the volumes from this container for subsequent cloud builders
3 ) If you like, explicitly remove the container w/ the activated service credentials:
$ docker rm gcloud-service-account

EOF
    exit 1
}

[[ -z "$active_account" ]] && funct_usage
echo "Activated account: $active_account"