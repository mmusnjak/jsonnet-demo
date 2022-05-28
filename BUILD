load("@com_adobe_rules_gitops//gitops:defs.bzl", "k8s_deploy")

k8s_deploy(
    name = "release",
    cluster = "CLUSTER",
    deployment_branch = "helloworld-prod",
    image_digest_tag = True,  # test optional image tagging
    image_registry = "REGISTRY",  # override the default registry host for production
    image_repository_prefix = "k8s",
    manifests = [
        "//clusters/dev/aws/us-east-1/dev-cluster-1:custom-app",
    ],
    namespace = "NAMESPACE",
    user = "USER",
)
