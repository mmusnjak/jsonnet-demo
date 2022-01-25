{
    customApp(libraries, env, appParams):: {
        // Make sure we have all the libraries we need
        // We could also be asserting all the APIs we require are available in the libraries
        assert std.objectHas(libraries, "k") : "Libraries should include field 'k' with the k8s library",
        assert std.objectHas(libraries, "flux") : "Libraries should include field 'k' with the fluxCD library",
        local k = libraries.k,
        local flux = libraries.flux,

        // Allows us to refer to the root object of the template later
        local this = self,

        local params = {
            // These are the soft defaults we can override
            replicas: 1,
        } + appParams + {
            // These are "hard" defaults that we can not override
        },

        // Hidden deployment object, as we want to be able to modify it before materializing
        deployment::
            libraries.k.apps.v1.deployment.new(
                name="custom-app",
                replicas=params.replicas,
                containers=[
                    k.core.v1.container.new("custom-app", "image.io/appImage:1.0.0"),
                    k.core.v1.container.new("sidecar", "image.io/sidecar:2.0.0"),
                ],
                podLabels={ labelKey: "labelValue" }
            ) +
            libraries.k.apps.v1.deployment.metadata.withNamespace(env.namespace),

        gitRepository:: (
            local gitRepo = flux.source.v1beta1.gitRepository;
            gitRepo.new("gitRepo") +
            gitRepo.metadata.withNamespace("custom-app") +
            gitRepo.spec.withGitImplementation("libgit2") +
            gitRepo.spec.withInterval("1m0s") +
            gitRepo.spec.ref.withBranch("main") +
            gitRepo.spec.secretRef.withName("custom-app") +
            gitRepo.spec.withTimeout("30s") +
            gitRepo.spec.withUrl("https://github.com/mmusnjak/...")
        ),

        staticCompanionObject:: {
            dict: {
                secondKey: "secondValue",
                firstKey: "firstValue",
            },
            list: [
                "first item",
                "second item",
            ],
            string: "value",
            anotherString: "value with spaces",
            bool: true,
            number: 1,
        },

        generate():: this.generateAs(""),

        generateAs(instanceId):: {
            // This generates the visible objects that will become files
            // We're fixing the strings in case the instance ID is not specified
            [std.strReplace("custom-app-%s-deployment" % instanceId, "--", "-")]: this.deployment,
            [std.strReplace("custom-app-%s-git-repository" % instanceId, "--", "-")]: this.gitRepository,
            [std.strReplace("custom-app-%s-static-companion-object" % instanceId, "--", "-")]: this.staticCompanionObject,
        },
    },
}
