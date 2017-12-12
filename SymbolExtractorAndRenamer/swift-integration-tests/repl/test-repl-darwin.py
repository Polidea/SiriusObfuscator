# Tests that importing Darwin works on OS X
#
# REQUIRES: magic
# REQUIRES: platform=Darwin
# REQUIRES: have-pexpect
#
# RUN: rm -rf %t.dir
# RUN: mkdir %t.dir
# RUN: python %s %{swift} > %t.dir/output.txt
# RUN: %{FileCheck} --input-file %t.dir/output.txt %s
# CHECK: OK

import pexpect, sys, time

swift = "swift"
if len(sys.argv) > 1:
    swift = sys.argv[1]

def debug(p):
    print('before:')
    print(p.before)
    print('--')
    print('after:')
    print(p.after)
    print('--')
    print(p.match.groups())
    print('--')

repl = pexpect.spawn(swift)

repl.expect('(.*)Welcome to Apple Swift version (.*)\r\n')
repl.sendline('print("hello, world")')

repl.expect('\r\nhello, world.*\r\n')
repl.sendline('import Foundation')

repl.sendline(":type lookup FILE")
try:
    repl.expect("init")
except:
    debug(repl)

print("OK")
