protocol T1_SampleProtocol {
  associatedtype AssociatedType
}

protocol T1_SampleProtocol2 { }

protocol T1_SampleProtocol3: class { }

class T1_SampleClass {}

class T1_Generic<WithType> {}

extension T1_SampleProtocol where Self : T1_SampleClass {}

extension T1_SampleProtocol where AssociatedType == T1_SampleClass {}

extension T1_SampleProtocol where AssociatedType == T1_SampleClass.Type {}

extension T1_SampleProtocol where AssociatedType == T1_SampleClass? {}

extension T1_SampleProtocol where AssociatedType == (T1_SampleClass, T1_SampleClass) {}

extension T1_SampleProtocol where AssociatedType == (T1_SampleClass) -> T1_SampleClass {}

extension T1_SampleProtocol where AssociatedType == (T1_SampleClass) -> T1_SampleClass {}

extension T1_SampleProtocol where AssociatedType == [T1_SampleClass] {}

extension T1_SampleProtocol where AssociatedType == [String: T1_SampleClass] {}

extension Optional where Wrapped : T1_SampleProtocol & T1_SampleProtocol2 {}

extension Optional where Wrapped : T1_SampleProtocol & T1_SampleProtocol2 & T1_SampleProtocol3 {}

extension Optional where Wrapped : T1_SampleProtocol, Wrapped: T1_SampleProtocol3 {}

extension Optional where Wrapped == T1_SampleProtocol.Protocol {}

extension Optional where Wrapped == T1_Generic<T1_SampleClass> {}

extension T1_SampleClass: T1_SampleProtocol2 {}


func NF1_foo<T>(SP1_t: T) where T : T1_SampleProtocol {}

protocol T1_Container {
  associatedtype Item: T1_SampleClass
  associatedtype Iterator: T1_SampleProtocol where Iterator.AssociatedType == Item
  subscript(i: Int) -> Item { get }
}

extension T1_Container {
  subscript<Indices: Sequence>(indices: Indices) -> [Item]
    where Indices.Iterator.Element == T1_SampleProtocol2 {
      let V1_result = [Item]()
      return V1_result
  }
}
