# Test `swift package init` (executable)

## Create a new package with an executable target.

```
RUN: rm -rf %t.dir
RUN: mkdir -p %t.dir/Project
RUN: %{swift} package --package-path %t.dir/Project init --type executable
RUN: %{swift} build --package-path %t.dir/Project 2>&1 | tee %t.build-log
```

## Check the build log.

```
RUN: %{FileCheck} --check-prefix CHECK-BUILD-LOG --input-file %t.build-log %s
```

```
CHECK-BUILD-LOG: Compile Swift Module 'Project'
CHECK-BUILD-LOG: Linking {{.*}}Project
```

## Verify that the tool was built and works.

```
RUN: test -x %t.dir/Project/.build/debug/Project
RUN: %t.dir/Project/.build/debug/Project > %t.out
RUN: %{FileCheck} --check-prefix CHECK-TOOL-OUTPUT --input-file %t.out %s
```

```
CHECK-TOOL-OUTPUT: Hello, world!
```

## Check there were no compile errors or warnings.

```
RUN: %{FileCheck} --check-prefix CHECK-NO-WARNINGS-OR-ERRORS --input-file %t.build-log %s
```

```
CHECK-NO-WARNINGS-OR-ERRORS-NOT: warning
CHECK-NO-WARNINGS-OR-ERRORS-NOT: error
```
