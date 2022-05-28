local env = (import "./env.libsonnet") {
    namespace: "flux-system",
};

local fluxItems = (import "templates/flux-system/flux-system.libsonnet").fluxItems("0.30.2");

// This is our output:
fluxItems
// With these additions:
{
    local this = self,
    local gr = env.libraries.flux.source.v1beta2.gitRepository,
    local ignoreList = |||
        # exclude all
        /*
        # include deploy dir
        !/manifests/%s/%s
        # exclude non-Kubernetes YAMLs
        /manifests/**/kustomize.yaml
        /manifests/**/kustomization.yaml
    |||,
    "gotk-sync":
        gr.new(env.clusterName) +
        gr.metadata.withNamespace(env.namespace) +
        gr.spec.withGitImplementation("libgit2") +
        gr.spec.withInterval("3m1s") +
        gr.spec.ref.withBranch("validated") +
        gr.spec.secretRef.withName("flux-system") +
        gr.spec.withTimeout("30s") +
        gr.spec.withUrl("https://hostname/kube-manifests") +
        gr.spec.withIgnore(std.format(ignoreList, [env.environmentType, env.clusterName])),

    local kust = env.libraries.flux.kustomize.v1beta2.kustomization,

    // Coupled with the ignoreString above, this kustomization will apply all the manifests for this namespace.
    // Every new namespace we add will have to define its own kustomization object, but can reference the GitRepository defined above.
    "gotk-kustomization":
        kust.new("flux-system") +
        kust.metadata.withNamespace(env.namespace) +
        kust.spec.withInterval("1m0s") +
        kust.spec.withPath("./manifests/%s/%s/%s" % [env.environmentType, env.clusterName, env.namespace]) +
        kust.spec.withPrune(true) +
        kust.spec.sourceRef.withKind("GitRepository") +
        kust.spec.sourceRef.withNamespace("flux-system") +
        kust.spec.sourceRef.withName(env.clusterName),

    local provider = env.libraries.flux.notification.v1beta1.provider,
    "gotk-teams-notifications-provider":
        provider.new("aifti-teams") +
        provider.metadata.withNamespace(env.namespace) +
        provider.spec.withType("msteams") +
        provider.spec.secretRef.withName("aifti-teams-url"),

    local alert = env.libraries.flux.notification.v1beta1.alert,
    "gotk-teams-alert":
        alert.new("aifti-teams-alerts") +
        alert.metadata.withNamespace(env.namespace) +
        alert.spec.providerRef.withName(this["gotk-teams-notifications-provider"].metadata.name) +
        alert.spec.withEventSeverity("info") +
        alert.spec.withEventSources([
            {
                kind: kind,
                name: "*",
                namespace: ns,
            }
            for ns in ["flux-system", "monitoring", "prefect", "splunk-o11y-suite"]
            for kind in ["GitRepository", "Kustomization", "HelmRelease"]
        ]),
}
