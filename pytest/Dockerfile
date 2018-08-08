FROM gcr.io/cloud-builders/gcloud

RUN pip install pytest

ENTRYPOINT ["/usr/local/bin/pytest"]
CMD ["--version"]