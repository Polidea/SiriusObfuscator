# Tests that importing Glibc works on Linux
#
# REQUIRES: platform=Linux
# REQUIRES: have-pexpect
#
# RUN: rm -rf %t.dir
# RUN: mkdir %t.dir
# RUN: python %s %{swift} > %t.dir/output.txt
# RUN: %{FileCheck} --input-file %t.dir/output.txt %s
# CHECK: OK

from __future__ import print_function

import pexpect, sys

swift = "swift"
if len(sys.argv) > 1:
    swift = sys.argv[1]
    
repl = pexpect.spawn(swift)

repl.expect('(.*)Welcome to Swift version (.*)\r\n')
# print 'before (text up to pattern that was matched):'
# print repl.before
# print '--'
# print 'after (what was actually matched by pattern):'
# print repl.after
# print '--'
# print repl.match.groups()
# print '--'

# repl.expect("(.*)1>(.*)")
repl.sendline('print("hello, world")')

repl.expect('\r\nhello, world.*\r\n')
# print 'before:'
# print repl.before
# print '--'
# print 'after:'
# print repl.after
# print '--'
# print repl.match.groups()
# print '--'

# repl.expect("(.*)2>(.*)")
repl.sendline('import Glibc')

# repl.expect("(.*)3>(.*)")

repl.sendline(":type lookup FILE")
repl.expect("init")
# print 'before:'
# print repl.before
# print '--'
# print 'after:'
# print repl.after
# print '--'
# print repl.match.groups()
# print '--'

print("OK")
