load("@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_library")

jsonnet_library(
    name = "env",
    srcs = ["env.libsonnet"],
    visibility = ["//clusters/dev/aws:__subpackages__"],
    deps = ["//clusters/dev:env"],
)
