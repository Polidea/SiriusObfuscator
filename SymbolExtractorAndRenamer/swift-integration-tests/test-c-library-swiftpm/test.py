# Test swiftpm's ability to link C libraries
#
# Needs a common C lib on all our test machines first.
# REQUIRES: have-zlib
# REQUIRES: platform=Linux
#
# Make a sandbox dir. Copy our sources over.
#
# RUN: rm -rf %t.dir
# RUN: mkdir -p %t.dir/
# RUN: cp -R %S/testApp %t.dir/
# RUN: cp -R %S/z %t.dir/

# RUN: rm -rf %t.dir/.build

# Create the git repo for the Z lib package
# RUN: git -C %t.dir/z init
# RUN: git -C %t.dir/z add .
# RUN: git -C %t.dir/z config user.name "Test User"
# RUN: git -C %t.dir/z config user.email "test@user.com"
# RUN: git -C %t.dir/z commit -m "Creating package"
# RUN: git -C %t.dir/z tag 1.0.0

# RUN: %{swift} build --package-path %t.dir/testApp 2>&1 | tee %t.build-log

# Check the build log.
#
# RUN: %{FileCheck} --check-prefix CHECK-BUILD-LOG --input-file %t.build-log %s
#
# CHECK-BUILD-LOG: Compile Swift Module 'testApp'

# Verify that the build worked.
#
# RUN: test -x %t.dir/testApp/.build/debug/testApp
# RUN: %t.dir/testApp/.build/debug/testApp > %t.out
# RUN: %{FileCheck} --check-prefix CHECK-APP-OUTPUT --input-file %t.out %s
#
#
# CHECK-APP-OUTPUT: gzFile_s(have: 0, next: 0x0000000000000000, pos: 0)
# CHECK-APP-OUTPUT-NEXT: OK

# Verify that another 'swift build' does nothing.
#
# RUN: %{swift} build --package-path %t.dir/testApp 2>&1 | tee %t.rebuild-log
# RUN: echo END-OF-INPUT >> %t.rebuild-log
# RUN: %{FileCheck} --check-prefix CHECK-BUILD-LOG --input-file %t.build-log %s
#
# CHECK-REBUILD-LOG-NOT: Compile
