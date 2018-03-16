import Foundation

@objc public protocol SampleProtocol {
  @objc optional func optFunc()
  @objc optional static func optClassFunc()
  @objc optional func optFunc(param: Int)
  @objc optional static func optClassFunc(param: Int)
  @objc optional var optProp: Int { get }
  @objc optional static var optClassProp: Int { get }
}
