# Check that the package manager can build itself. This is really just testing
# that the package manager included in this package is functional for a moderate
# sized, real project.
#
# REQUIRES: have-swiftpm
#
# Make a sandbox dir. If you want to experiment with this test without waiting
# for the clone, disable the first three lines here.
#
# RUN: rm -rf %t.dir
# RUN: mkdir -p %t.dir/
# RUN: cp -R %{swiftpm_srcdir} %t.dir/swiftpm

# RUN: rm -rf %t.dir/swiftpm/.build
# RUN: %{swift} build --package-path %t.dir/swiftpm 2>&1 | tee %t.build-log

# Check the build log.
#
# RUN: %{FileCheck} --check-prefix CHECK-BUILD-LOG --input-file %t.build-log %s
#
# CHECK-BUILD-LOG: Compile Swift Module 'PackageDescription'

# Verify that the build worked.
#
# RUN: test -x %t.dir/swiftpm/.build/debug/swift-build
