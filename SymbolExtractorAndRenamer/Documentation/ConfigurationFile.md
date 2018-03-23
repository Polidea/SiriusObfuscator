# Configuration File

This document describes the obfuscation configuration file format and conventions.

# Location

The configuration file should be named `.obfuscation.yml` and be placed under the project's root directory.

# Format

The file is in the YAML format presented in the example:

```
exclude:

  - type:
      name: "SampleClass"
      module: "iOSTestApp"

  - inheritance:
      base: "SampleTransitiveBaseClass"
      module: "iOSTestApp"
      transitive: true

  - inheritance:
      base: "SampleBaseClass"
      module: "iOSTestApp"
      transitive: false

  - conformance:
      protocol: "SampleTransitiveUsedProtocol"
      module: "iOSTestApp"
      transitive: true

  - conformance:
      protocol: "SampleUsedProtocol"
      module: "iOSTestApp"
      transitive: false

```

At the top level, there's a `exlude` key that specifies the array of exclusion rules for the obfuscation process.

The possible rules are:

## 1. Type exclusion rule

```
type:
  name: <string>
  module: <string>
```

The `type` key specifies the type exclusion rule. It states which one particular type should not be included in the obfuscation process. It contains two fields: `name` and `module`. The values under name and module are used to identify the particular Swift type (class, struct, enum or protocol) to exclude from obfuscation.

## 2. Inheritance exclusion rule

```
inheritance:
  base: <string>
  module: <string>
  transitive: <boolean>
```

The `inheritance` key specifies the inheritance exclusion name. It excludes the subclasses of particular base class (name from `base` field) in particular module (name from `module` field) from obfuscation. There's a boolean parameter `transitive` that defines whether the subclasses of subclass of base class should be excluded as well. If `transitive` is true, they will be excluded, if it's `false`, they will not.

## 3. Conformance exclusion rule

```
conformance:
  protocol: <string>
  module: <string>
  transitive: <boolean>
```

The `conformance` key specifies the conformance exclusion name. It excludes the objects that conform from a particular protocol or protocols extending particular protocol. The values from `protocol` and `module` fields are used to identify the protocol to exclude. The `transitive` boolean parameter defines whether the subclasses of classes conforming to stated protocol or protocols extending the protocol extending the stated protocol should be excluded from obfuscation as well. If `true`, they will be excluded. If `false`, they will not.
