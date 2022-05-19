local utils = import "utils.libsonnet";

// We'll use this function to give us nicer file names
local nameTransformer(objectName) =
    local hasDots = std.length(std.findSubstr(".", objectName)) > 0;
    local split = std.split(objectName, ".");
    if hasDots then split[1] + "-" + split[0] else objectName;

// If upgrading Flux, you can regenerate the static yaml file according to instructions
// here: https://fluxcd.io/docs/use-cases/azure/#flux-installation-for-azure-devops
// flux install --export > gotk-components-0.xx.y.yaml

local rawManifests = {
    "0.30.2": importstr "./gotk-components-0.30.2.yaml",
};

local supportedVersions = std.objectFields(rawManifests);

{
    fluxItems(version="0.30.2")::
        assert std.member(supportedVersions, version);
        local rawYamlManifests = rawManifests[version];
        utils.splitYamlListToFiles(rawYamlManifests, "setup/gotk", nameTransformer),
}
