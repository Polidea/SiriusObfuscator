# Tests that creating a static lib and importing it into a file works

# RUN: rm -rf %t.dir
# RUN: mkdir %t.dir
# RUN: cp %S/staticLib.swift %t.dir/staticLib.swift
# RUN: cp %S/main.swift %t.dir/main.swift
# RUN: %{swiftc} -emit-object %t.dir/staticLib.swift -module-name staticLib -parse-as-library -emit-module -emit-module-path %t.dir/staticLib.swiftmodule -o %t.dir/staticLib.o -force-single-frontend-invocation
# RUN: ar -rs %t.dir/staticLib.a %t.dir/staticLib.o

# Compile a swift program linking the static library
# RUN: %{swiftc} -I %t.dir -L %t.dir %t.dir/main.swift -o %t.dir/mainWithLib -Xlinker %t.dir/staticLib.a
# RUN: %t.dir/mainWithLib > %t.dir/output
# RUN: %{FileCheck} --input-file %t.dir/output %s
# CHECK: hello
