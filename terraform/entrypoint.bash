#!/bin/bash
# Copyright 2018 UNspecified, LLC
# https://www.unspecified.life

#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at

#        http://www.apache.org/licenses/LICENSE-2.0

#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

set -e

active_account=""
function get-active-account() {
  active_account=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" 2> /dev/null)
}

function activate-service-key() {
  rootdir=/root/.config/gcloud-config
  mkdir -p $rootdir
  tmpdir=$(mktemp -d "$rootdir/servicekey.XXXXXXXX")
  trap "rm -rf $tmpdir" EXIT
  echo ${GCLOUD_SERVICE_KEY} | base64 --decode -i > ${tmpdir}/gcloud-service-key.json
  gcloud auth activate-service-account --key-file ${tmpdir}/gcloud-service-key.json --quiet
  get-active-account
}

function service-account-usage() {
  cat <<EOF
No account is set. This is either provided by the Google cloud builder environment, or by providing a
key file through environment variables, e.g. set
  GCLOUD_SERVICE_KEY=<base64 encoded service account key file>
EOF
  exit 1
}

function account-active-warning() {
  cat <<EOF
A service account key file has been provided in the environment variable GCLOUD_SERVICE_KEY. This account will
be activated, which will override the account already activated in this container.

This usually happens if you've defined the GCLOUD_SERVICE_KEY environment variable in a cloudbuild.yaml file & this is
executing in a Google cloud builder environment.
EOF
}

get-active-account
if [[ (! -z "$active_account") &&  (! -z "$GCLOUD_SERVICE_KEY") ]]; then
  account-active-warning
  activate-service-key
elif [[ (-z "$active_account") && (! -z "$GCLOUD_SERVICE_KEY") ]]; then
  activate-service-key
elif [[ (-z "$active_account") &&  (-z "$GCLOUD_SERVICE_KEY") ]]; then
  echo "no active account and no key"
  service-account-usage
fi

echo "Running: terraform $@"
terraform "$@"



