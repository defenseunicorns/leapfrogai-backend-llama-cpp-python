# llama.cpp End-To-End Tests

This directory holds our e2e tests that we use to verify LFAI + llama.cpp functionality in an environment that replicates a live setting. The tests in this directory are automatically run against a [UDS Core](https://github.com/defenseunicorns/uds-core) cluster whenever a PR is opened or updated.


## Running Tests Locally
The tests in this directory are also able to be run locally! We are currently opinionated towards running on a cluster that is configured with UDS, as we mature out tests & documentations we'll potentially lose some of that opinionation.


### Dependencies
1. Python >= 3.11.6
2. k3d >= v5.6.0
3. uds >= v0.7.0


### Actually Running The Test
There are several ways you can setup and run these tests. Here is one such way:

```bash
# Setup the UDS cluster
# NOTE: This stands up a k3d cluster and installs istio & pepr
# NOTE: Be sure to use the latest released version at the time you're reading this!
uds deploy oci://ghcr.io/defenseunicorns/packages/uds/bundles/k3d-core-istio-dev:0.13.1 --confirm

# Install the LFAI API
# NOTE: Be sure to use the latest released version at the time you're reading this!
uds zarf package deploy oci://ghcr.io/defenseunicorns/packages/leapfrogai-api:v0.5.1 --confirm

# Install the llama.cpp Backend
# NOTE: Be sure to use the latest released version at the time you're reading this!
# NOTE: If you are testing changes you have made locally, you will need to rebuild the llama.cpp Docker image and Zarf Package.
uds zarf package deploy oci://ghcr.io/defenseunicorns/packages/leapfrogai/llama-cpp:v0.1.0-amd64 --confirm


# Install the python dependencies
python -m pip install -r requirements-dev.txt

# Run the tests!
python -m pytest .  -v
```