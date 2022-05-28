load("@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_library")

jsonnet_library(
    name = "k8s_1.23",
    srcs = glob(["github.com/jsonnet-libs/k8s-libsonnet/1.23/**/*.libsonnet"]),
    visibility = [
        "//clusters:__subpackages__",
    ],
)

jsonnet_library(
    name = "flux_0.28.5",
    srcs = glob(["github.com/jsonnet-libs/fluxcd-libsonnet/0.28.5/**/*.libsonnet"]),
    visibility = [
        "//clusters:__subpackages__",
    ],
)
