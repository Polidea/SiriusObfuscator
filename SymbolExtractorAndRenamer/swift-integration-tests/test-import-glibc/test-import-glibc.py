# Test import of Glibc, on Linux.
#
# REQUIRES: platform=Linux

# RUN: rm -rf %t.dir
# RUN: mkdir %t.dir
# RUN: cp %S/import-glibc.swift %t.dir/import-glibc.swift
# RUN: %{swiftc} %t.dir/import-glibc.swift -o %t.dir/main

# Check exists
#
# RUN: ls %t.dir/ > %t.dir/listing
# RUN: %{FileCheck} --check-prefix CL --input-file %t.dir/listing %s
# CL: main

# Check file runs (it prints Hello Glibc)
# 
# RUN: %t.dir/main > %t.dir/out
# RUN: %{FileCheck} --check-prefix CO --input-file %t.dir/out %s
# CO: Hello Glibc

