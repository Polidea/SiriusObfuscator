//XFAIL: *

//RUN: %target-prepare-obfuscation-for-file "UnsupportedTypes" %target-run-full-obfuscation

protocol SampleProtocol { }

class `BackticksName` {}

class `BackticksNameGeneric`<`BackticksGenericParam`> {
  class `BackticksInsideBackticksGeneric`: `BackticksNameGeneric`<`BackticksNameGeneric`<`BackticksName`>> {}
}

class SampleClass {}

extension SampleProtocol where Self: SampleClass {}

extension SampleProtocol where Self == SampleClass {}
