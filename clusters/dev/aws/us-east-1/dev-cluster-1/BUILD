load("@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_library", "jsonnet_to_json")

jsonnet_library(
    name = "env",
    srcs = ["env.libsonnet"],
    deps = [
        "//clusters/dev/aws/us-east-1:env",
        "//lib:utils",
        "//vendor:flux_0.28.5",
        "//vendor:k8s_1.23",
    ],
)

jsonnet_to_json(
    name = "custom-app",
    src = "custom-app.jsonnet",
    outs = [
        "custom-app-deployment",
        # "custom-app-git-repository",
        # "custom-app-instance-1-deployment",
        # "custom-app-instance-1-git-repository",
        # "custom-app-instance-1-static-companion-object",
        # "custom-app-instance-2-deployment",
        # "custom-app-instance-2-git-repository",
        # "custom-app-instance-2-static-companion-object",
        # "custom-app-instance-3-deployment",
        # "custom-app-instance-3-git-repository",
        # "custom-app-instance-3-static-companion-object",
        # "custom-app-static-companion-object",
        "setup/namespace",
    ],
    visibility = ["//:__pkg__"],
    deps = [
        ":env",
        "//lib/templates:custom_app",
    ],
)
