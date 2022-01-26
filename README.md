# Using Jsonnet to generate Kubernetes cluster manifests

This repository shows one possible way of using plain Jsonnet to generate Kubernetes manifests.
It makes use of various Jsonnet libraries, such as [jsonnet-libs](https://github.com/jsonnet-libs) and others.

## Prerequisites

You'll need to install the following:

* [jsonnet](https://jsonnet.org/): `brew install go-jsonnet`
* [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler): `brew install jsonnet-bundler`
* [go](https://go.dev/): `brew install go`
* [gojsontoyaml](https://github.com/brancz/gojsontoyaml): `go install github.com/brancz/gojsontoyaml@latest`
* [GNU Parallel](https://www.gnu.org/software/parallel/): `brew install parallel`
* [Jsonnet NG](https://marketplace.visualstudio.com/items?itemName=Sebbia.jsonnetng): VSCode extension for Jsonnet

## Downloading dependencies

Jsonnet-bundler is used to download the dependencies to the `vendor` directory.
You need to do this once before being able to build the manifests.

```bash
jb install
```

Later, you'll also need to do it if the remote repository has updated the dependencies.
You can update dependencies yourself by running `jb update`.
Make sure to rebuild the manifests after that to confirm no unwanted changes were caused.

## Building the output manifests

You can run the [scripts/build.sh](scripts/build.sh) script to regenerate the output manifests.
This will format all jsonnet and libsonnet files in the clusters and lib directories, and then save the rendered manifests to the manifests directory.

You can call that script with one or more directories or jsonnet files to avoid rebuilding all the manifests.
If called with a directory, it will process all jsonnet files in that directory and all its children.

```bash
# Builds all the clusters in dev environment:
scripts/build.sh clusters/dev

# Builds all the manifests for dev-cluster-1:
scripts/build.sh clusters/dev/dev-cluster-1 

# Builds all the manifests for dev-cluster-1 and for prod-cluster-1:
scripts/build.sh clusters/dev/dev-cluster-1 clusters/prod/prod-cluster-1
```

## Project structure

* [clusters](clusters): contains the environments and clusters for which we're generating manifests
* [clusters/dev](clusters/dev): contains shared environment config for all dev clusters, and a directory for each cluster
* [clusters/dev/dev-cluster-1](clusters/dev/dev-cluster-1): Jsonnet source for the cluster manifests. In this example, it's one jsonnet file per namespace
* [lib](lib): shared libraries for this repository. This can contain application templates that are reusable in different environments
* [manifests](manifests): rendered manifests ready to be applied to the clusters. The internal directory structure replicates the structure of the [clusters](clusters) directory
* [vendor](vendor): the downloaded external dependencies used. The contents are controlled by [jsonnetfile.json](jsonnetfile.json) and the corresponding lock file, and managed by the jsonnet-bundler tool
* [scripts](scripts): various scripts, including pre-commit checks and the build script

## Learning more

* [Jsonnet tutorial](https://jsonnet.org/learning/tutorial.html)
* [Jsonnet Kubernetes library](https://jsonnet-libs.github.io/k8s-libsonnet/)
* [FluxCD Jsonnet library](https://jsonnet-libs.github.io/fluxcd-libsonnet/)
* [Tanka](https://tanka.dev/): A more comprehensive Kubernetes configuration utility using Jsonnet to define manifests.
* [Qbec](https://github.com/splunk/qbec): Another comprehensive tool for managing Kubernetes configurations
* [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus): A Jsonnet-based definition for a full Prometheus installation in Kubernetes
