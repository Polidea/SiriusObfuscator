
protocol T1_SampleProtocol { }

class T1_`BackticksName` {}

class T1_`BackticksNameGeneric`<`BackticksGenericParam`> {
  class T1_`BackticksInsideBackticksGeneric`: T1_`BackticksNameGeneric`<T1_`BackticksNameGeneric`<T1_`BackticksName`>> {}
}
