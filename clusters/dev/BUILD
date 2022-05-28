load("@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_library")

jsonnet_library(
    name = "env",
    srcs = ["env.libsonnet"],
    visibility = ["//clusters/dev:__subpackages__"],
    deps = ["//clusters:env"],
)
