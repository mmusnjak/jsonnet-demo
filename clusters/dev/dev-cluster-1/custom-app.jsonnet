// Choose the libraries that we will be using for the apps in this namespace.
// Different clusters might be running on different Kubernetes (or other dependency) versions,
// so we can pass in the libraries that correspond to the cluster we're building this for
local libraries = {
    k: import "github.com/jsonnet-libs/k8s-libsonnet/1.23/main.libsonnet",
    flux: import "github.com/jsonnet-libs/fluxcd-libsonnet/0.25.3/main.libsonnet",
};

// This is the template for our custom app
local customApp = (import "templates/custom-app.libsonnet");

{
    "setup/namespace": libraries.k.core.v1.namespace.new("custom-app"),
}
// We'll generate multiple instances, some with custom names
+ customApp.customApp(libraries, env={}, appParams={ replicas: 2 }).generateAs("instance-1")
+ customApp.customApp(libraries, env={}, appParams={ replicas: 5 }).generateAs("instance-2")
// Here we'll use the default number of replicas
+ customApp.customApp(libraries, env={}, appParams={}).generateAs("instance-3")

// We'll add some last minute fields to this deployment
+ (
    customApp.customApp(libraries, env={}, appParams={}) + {
        deployment+: {
            metadata+: {
                annotations+: {
                    lastMinute: "very much so",
                },
            },
        },
    }
    // And we won't specify an instance ID. This is not safe when we're deploying different instances of the same template in the same namespace.
).generate()
