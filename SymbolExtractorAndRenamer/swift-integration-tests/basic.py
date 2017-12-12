# Basic sanity check.
#
# RUN: %{swiftc} --version > %t.out
# RUN: %{FileCheck} --input-file %t.out %s
#
# CHECK: Swift version
