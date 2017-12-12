# Test `swift run` (executable)

## Create a new package with an echo executable.

```
RUN: rm -rf %t.dir
RUN: mkdir -p %t.dir/secho
RUN: %{swift} package --package-path %t.dir/secho init --type executable
RUN: echo "import Foundation; print(CommandLine.arguments.dropFirst().joined(separator: \" \"))" >%t.dir/secho/Sources/secho/main.swift
RUN: %{swift} run --package-path %t.dir/secho secho 1 "two" 2>&1 | tee %t.run-log
```

## Check the run log.

```
RUN: %{FileCheck} --check-prefix CHECK-BUILD-LOG --input-file %t.run-log %s
```

```
CHECK-BUILD-LOG: Compile Swift Module 'secho'
CHECK-BUILD-LOG: Linking {{.*}}secho
CHECK-BUILD-LOG: 1 two
```