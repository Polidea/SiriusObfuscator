# Tests that multiple files are compiled correctly
#
# REQUIRES: platform=Linux
# RUN: rm -rf %t.dir
# RUN: mkdir %t.dir
# RUN: cp %S/hello.swift %t.dir/hello.swift
# RUN: cp %S/goodbye.swift %t.dir/main.swift
# RUN: %{swiftc} %t.dir/hello.swift %t.dir/main.swift -o %t.dir/main

# Check exists
# 
# RUN: ls %t.dir/ > %t.listing
# RUN: %{FileCheck} --check-prefix CL --input-file %t.listing %s
# CL: main

# Check file runs
# 
# RUN: %t.dir/main > %t.out
# RUN: %{FileCheck} --check-prefix CO --input-file %t.out %s
# CO: hello

