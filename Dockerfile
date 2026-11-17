# Course image, pinned to the verified 2023.4-notebook7 manifest.
ARG BASE_CONTAINER=ghcr.io/ucsd-ets/datascience-notebook:2023.4-notebook7@sha256:de09c369a38a8dc9f4a6c5a52cb869d3327b92d1658ee34a98edd212a3252634
FROM ${BASE_CONTAINER}

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends aria2 nmap traceroute \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER jovyan
COPY --chown=jovyan:users requirements.txt /tmp/ma5-requirements.txt
RUN python -m pip install --no-cache-dir -r /tmp/ma5-requirements.txt

# Fail the build if a required executable, import, or package version is missing.
COPY --chown=jovyan:users verify.sh /usr/local/bin/verify-ma5
RUN bash /usr/local/bin/verify-ma5

CMD ["/bin/bash"]
