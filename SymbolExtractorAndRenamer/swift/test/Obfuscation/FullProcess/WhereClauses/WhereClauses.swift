//RUN: %target-prepare-obfuscation-for-file "WhereClauses" %target-run-full-obfuscation

protocol SampleProtocol {
  associatedtype AssociatedType
}

protocol SampleProtocol2 { }

protocol SampleProtocol3: class { }

class SampleClass {}

class Generic<WithType> {}

extension SampleProtocol where Self : SampleClass {}

extension SampleProtocol where AssociatedType == SampleClass {}

extension SampleProtocol where AssociatedType == SampleClass.Type {}

extension SampleProtocol where AssociatedType == SampleClass? {}

extension SampleProtocol where AssociatedType == (SampleClass, SampleClass) {}

extension SampleProtocol where AssociatedType == (SampleClass) -> SampleClass {}

extension SampleProtocol where AssociatedType == (SampleClass) -> SampleClass {}

extension SampleProtocol where AssociatedType == [SampleClass] {}

extension SampleProtocol where AssociatedType == [String: SampleClass] {}

extension Optional where Wrapped : SampleProtocol & SampleProtocol2 {}

extension Optional where Wrapped : SampleProtocol & SampleProtocol2 & SampleProtocol3 {}

extension Optional where Wrapped : SampleProtocol, Wrapped: SampleProtocol3 {}

extension Optional where Wrapped == SampleProtocol.Protocol {}

extension Optional where Wrapped == Generic<SampleClass> {}

extension SampleClass: SampleProtocol2 {}


func foo<T>(t: T) where T : SampleProtocol {}

protocol Container {
  associatedtype Item: SampleClass
  associatedtype Iterator: SampleProtocol where Iterator.AssociatedType == Item
  subscript(i: Int) -> Item { get }
}

extension Container {
  subscript<Indices: Sequence>(indices: Indices) -> [Item]
    where Indices.Iterator.Element == SampleProtocol2 {
      let result = [Item]()
      return result
  }
}
