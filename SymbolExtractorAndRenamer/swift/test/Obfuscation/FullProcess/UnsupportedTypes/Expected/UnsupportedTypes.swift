
protocol T1_SampleProtocol { }

class T1_`BackticksName` {}

class T1_`BackticksNameGeneric`<`BackticksGenericParam`> {
  class T1_`BackticksInsideBackticksGeneric`: T1_`BackticksNameGeneric`<T1_`BackticksNameGeneric`<T1_`BackticksName`>> {}
}

class T1_SampleClass {}

extension T1_SampleProtocol where Self: T1_SampleClass {}

extension T1_SampleProtocol where Self == T1_SampleClass {}
