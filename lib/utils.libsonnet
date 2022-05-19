{
    local this = self,

    // check whether the argument is of type object
    isObject(item):: std.type(item) == "object",

    isNotObject(item):: !this.isObject(item),

    // Merge an array of objects into an object.
    // By default no transform is done, but a mapping function can be passed in
    flattenArrayToObject(array, transform=function(item) item)::
        assert std.type(array) == "array" : "flattenArrayToObject takes an array containing objects as an argument";
        assert std.length(std.filter(this.isNotObject, array)) == 0 : "every item in the array passed to flattenArrayToObject must be an object";
        std.foldl(function(accumulator, item) accumulator + transform(item), array, {}),

    // Takes a list of YAML objects in a string and generates one object per item.
    // The name is generated from given prefix, position in yaml list, object kind and name.
    // Optionally, a name transformer function can be supplied, that modifies the object name before creating the file name
    splitYamlListToFiles(yamlString, filePrefix, nameTransformer=function(item) item)::
        // make sure both inputs are strings
        assert std.isString(yamlString) : "Given YAML input parameter is not a string";
        assert std.isString(filePrefix) : "Given file prefix input parameter is not a string";

        local parsedYaml = std.parseYaml(yamlString);
        // make sure the yaml input parses to an array
        assert std.isArray(parsedYaml) : "Input YAML is not an array";

        // make sure each item in the list has fields: kind, metadata, metadata.name
        assert std.length(std.filter(function(obj) !std.objectHas(obj, "kind"), parsedYaml)) == 0 : "Every object in the input YAML must have the field 'kind'";
        assert std.length(std.filter(function(obj) !std.objectHas(obj, "metadata"), parsedYaml)) == 0 : "Every object in the input YAML must have the field 'metadata'";
        assert std.length(std.filter(function(obj) !std.objectHas(obj.metadata, "name"), parsedYaml)) == 0 : "Every object in the input YAML must have the field 'metadata.name'";

        local formatFileName(index, item) =
            local nameParameters = [filePrefix, index, item.kind, nameTransformer(item.metadata.name)];
            { [std.format("%s-%02d-%s-%s", nameParameters)]: item };

        // for each item in the array parsedYaml, create a pair that represents a file name as key, and the item as value
        local listOfNamesAndResources = std.mapWithIndex(formatFileName, parsedYaml);

        // Merge the list of k/v pairs into one large dictionary
        this.flattenArrayToObject(listOfNamesAndResources),
}
