// This is the template for our custom app
local customApp = (import "templates/custom-app.libsonnet");

local env = (import "./env.libsonnet") {
    namespace: "custom-app",
};

{
    "setup/namespace": env.libraries.k.core.v1.namespace.new("custom-app"),
}
// We'll generate multiple instances, some with custom names
+ customApp.customApp(env, appParams={ replicas: 2 }).generateAs("instance-1")
+ customApp.customApp(env, appParams={ replicas: 5 }).generateAs("instance-2")
// Here we'll use the default number of replicas
+ customApp.customApp(env, appParams={}).generateAs("instance-3")

// We'll add some last minute fields to this deployment
+ (
    customApp.customApp(env, appParams={}) + {
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
