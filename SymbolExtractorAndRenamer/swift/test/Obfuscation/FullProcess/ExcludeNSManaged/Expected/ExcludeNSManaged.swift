import CoreData

class Coffee: NSManagedObject {}

extension Coffee {
  @NSManaged var name: String?
}

@objc protocol T1_SelectableSearchModelItem {
  var name: String? { get set }
}

extension Coffee: T1_SelectableSearchModelItem {}
