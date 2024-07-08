(import "../env.libsonnet") {
    clusterName: "dev-cluster-1",

    // Choose the libraries that we will be using for the apps in this cluster.
    // Different clusters might be running on different Kubernetes (or other dependency) versions,
    // so we can pass in the libraries that correspond to the cluster we're building this for.
    // You can override this on namespace level as well.
    libraries: {
        k: import "github.com/jsonnet-libs/k8s-libsonnet/1.30/main.libsonnet",
        flux: import "github.com/jsonnet-libs/fluxcd-libsonnet/2.3.0/main.libsonnet",
        prom: import "github.com/jsonnet-libs/kube-prometheus-libsonnet/0.13/main.libsonnet",
        utils: import "utils.libsonnet",
    },
}
