//RUN: %target-prepare-obfuscation-for-file "ExcludeNSManaged" %target-run-full-obfuscation
import CoreData

class Coffee: NSManagedObject {}

extension Coffee {
  @NSManaged var name: String?
}

@objc protocol SelectableSearchModelItem {
  var name: String? { get set }
}

extension Coffee: SelectableSearchModelItem {}
