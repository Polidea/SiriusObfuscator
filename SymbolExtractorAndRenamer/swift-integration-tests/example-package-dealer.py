# Test the open source example packages.
#
# REQUIRES: have-network
# 
# Make a sandbox dir. If you want to experiment with this test without waiting
# for the clone, disable the first three lines here.
#
# RUN: rm -rf %t.dir
# RUN: mkdir -p %t.dir/
# RUN: git clone https://github.com/apple/example-package-dealer %t.dir/dealer

# RUN: rm -rf %t.dir/dealer/.build
# RUN: %{swift} build --package-path %t.dir/dealer 2>&1 | tee %t.build-log

# Check the build log.
#
# RUN: %{FileCheck} --check-prefix CHECK-BUILD-LOG --input-file %t.build-log %s
#
# CHECK-BUILD-LOG: Compile Swift Module 'FisherYates'
# CHECK-BUILD-LOG: Compile Swift Module 'Dealer'

# Verify that the build worked.
#
# RUN: test -x %t.dir/dealer/.build/debug/Dealer
# RUN: %t.dir/dealer/.build/debug/Dealer > %t.out
# RUN: %{FileCheck} --check-prefix CHECK-TOOL-OUTPUT --input-file %t.out %s
#
# We should get an example that is easier to test.
#
# CHECK-TOOL-OUTPUT: {{♡|♠|♢|♣}}{{[0-9JQKA]|10}}

# Verify that the 'git status' is clean after a build.
#
# RUN: cd %t.dir/dealer && git status > %t.out
# RUN: %{FileCheck} --check-prefix CHECK-GIT-STATUS --input-file %t.out %s
#
# CHECK-GIT-STATUS: nothing to commit, working directory clean

# Verify that another 'swift build' does nothing.
#
# RUN: %{swift} build --package-path %t.dir/dealer 2>&1 | tee %t.rebuild-log
# RUN: echo END-OF-INPUT >> %t.rebuild-log
# RUN: %{FileCheck} --check-prefix CHECK-BUILD-LOG --input-file %t.build-log %s
#
# CHECK-REBUILD-LOG-NOT: Compile
