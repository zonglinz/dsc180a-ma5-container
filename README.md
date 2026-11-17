# DSC 180A Methodology Assignment 5

Container environment for the [Environments and Containerization assignment](https://dsc-capstone.org/2026-27/assignments/methodology/06/).

The image extends UCSD ETS's `datascience-notebook:2023.4-notebook7` image, pinned by manifest digest. It installs `aria2`, `nmap`, and `traceroute` with `apt-get`, and GeoPandas and `babypandas==0.1.5` with pip. It runs as `jovyan` and its default command is `/bin/bash`.

## Build and test locally

With Docker running, from this directory:

```bash
docker build --platform linux/amd64 -t dsc180a-ma5-container .
docker run --rm --platform linux/amd64 dsc180a-ma5-container bash /usr/local/bin/verify-ma5
docker run --rm -it --platform linux/amd64 dsc180a-ma5-container
```

AMD64 is required for the course's base image and DSMLP. The verification script checks all three executable paths, the exact babypandas version, DataFrame operations, and GeoPandas coordinate conversion and GeoJSON read/write.

## Build and publish with GitHub Actions

Push these files to the `main` branch. The workflow builds and tests the image, then publishes `ghcr.io/zonglinz/dsc180a-ma5-container:latest` and a commit-specific tag. It uses the temporary `GITHUB_TOKEN`; no personal access token is needed.

After the first successful run, open the package on your GitHub profile, choose **Package settings**, and change its visibility to **Public**. Confirm an unauthenticated pull succeeds before submitting.

For a manual push instead:

```bash
# Authenticate to ghcr.io with your existing package-write credential first.
docker tag dsc180a-ma5-container ghcr.io/zonglinz/dsc180a-ma5-container:latest
docker push ghcr.io/zonglinz/dsc180a-ma5-container:latest
```

## Test on DSMLP

SSH to `dsmlp-login.ucsd.edu` with your UCSD username, then run:

```bash
launch.sh -i ghcr.io/zonglinz/dsc180a-ma5-container -W DSC180A_FA26_001
bash /usr/local/bin/verify-ma5
```

Run the second command after the container has started. Exit the container when finished.
The presence of this README or the workflow source alone does not demonstrate a successful image build or submission; check the Actions run, public package, and Gradescope receipt.
