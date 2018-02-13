//XFAIL: *

//RUN: %target-prepare-obfuscation-for-file "OtherProperties" %target-run-full-obfuscation

struct SampleStruct {
  let sampleInt: Int
}
