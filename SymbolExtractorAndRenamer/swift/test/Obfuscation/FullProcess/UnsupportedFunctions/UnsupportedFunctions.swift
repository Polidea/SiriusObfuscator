//XFAIL: *
//RUN: %target-prepare-obfuscation-for-file "UnsupportedFunctions" %target-run-full-obfuscation

import AppKit

// Backtick named functions
func `function`() -> Int { return 1 }
