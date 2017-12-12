#
# RUN: rm -rf %t.dir
# RUN: mkdir -p %t.dir
# RUN: touch %t.dir/hello.swift
# RUN: echo 'print("hello")' > %t.dir/hello.swift
# RUN: %{swiftc} %t.dir/hello.swift -o %t.dir/hello

# Check the file exists
#
# RUN: ls %t.dir/ > %t.listing
# RUN: %{FileCheck} --check-prefix CHECK-FILE --input-file %t.listing %s
#
# CHECK-FILE: hello

# Check the file runs
#
# RUN: %t.dir/hello > %t.output
# RUN: %{FileCheck} --check-prefix CHECK-OUT --input-file %t.output %s
#
# CHECK-OUT: hello

