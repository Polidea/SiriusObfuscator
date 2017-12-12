# Check that debugging can print variables.
#   https://bugs.swift.org/browse/SR-85
#
# REQUIRES: disabled
#
# Make a sandbox dir.
# RUN: rm -rf %t.dir
# RUN: mkdir -p %t.dir/tool
# RUN: touch %t.dir/tool/Package.swift
# RUN: echo 'let foo = "bar"' > %t.dir/tool/main.swift
# RUN: echo 'print(foo)' >> %t.dir/tool/main.swift
# RUN: %{swift} build --package-path %t.dir/tool -v 2>&1 | tee %t.build-log

# RUN: echo 'breakpoint set -f main.swift -l 2' > %t.dir/lldb.script
# RUN: echo 'run' >> %t.dir/lldb.script
# RUN: echo 'print foo' >> %t.dir/lldb.script
# RUN: %{lldb} %t.dir/tool/.build/debug/tool --source %t.dir/lldb.script --batch &> %t.lldb.out
# RUN: %{FileCheck} --check-prefix CHECK-LLDB-OUTPUT --input-file %t.lldb.out %s
#
# CHECK-LLDB-OUTPUT: (lldb) print foo
# CHECK-LLDB-OUTPUT-NEXT: (String) $R0 = "bar"
