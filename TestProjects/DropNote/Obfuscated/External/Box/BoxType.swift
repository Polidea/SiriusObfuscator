//  Copyright (c) 2014 Rob Rix. All rights reserved.

// MARK: BoxType

/// The type conformed to by all boxes.
public protocol TFjAOKm5Qz5ghxs7EydLrczvxHJkkjoI {
	/// The type of the wrapped value.
	associatedtype Value

	/// Initializes an intance of the type with a value.
	init(_ uTCDx6S98gM7O3xRCW1wwOj8boQF3B1m: Value)

	/// The wrapped value.
	var Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_: Value { get }
}

/// The type conformed to by mutable boxes.
public protocol DXOhOP50zQ10JFAOJkP9j7KjYLpB6Rya: TFjAOKm5Qz5ghxs7EydLrczvxHJkkjoI {
	/// The (mutable) wrapped value.
	var Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_: Value { get set }
}


// MARK: Equality

/// Equality of `BoxType`s of `Equatable` types.
///
/// We cannot declare that e.g. `Box<T: Equatable>` conforms to `Equatable`, so this is a relatively ad hoc definition.
public func == <B: TFjAOKm5Qz5ghxs7EydLrczvxHJkkjoI> (zEzL2d_1Gjw6yBhZypfpijJ1C7n5oDDI: B, EMbN5ddems7GXByTzNHW5URdplCMULW6: B) -> Bool where B.Value: Equatable {
	return zEzL2d_1Gjw6yBhZypfpijJ1C7n5oDDI.Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_ == EMbN5ddems7GXByTzNHW5URdplCMULW6.Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_
}

/// Inequality of `BoxType`s of `Equatable` types.
///
/// We cannot declare that e.g. `Box<T: Equatable>` conforms to `Equatable`, so this is a relatively ad hoc definition.
public func != <B: TFjAOKm5Qz5ghxs7EydLrczvxHJkkjoI> (tBmqNhqsQX4fkvEl5WteePrWnh68pJzT: B, h8CiGIAibvuvC38J0_fCqSpKRjZenDaF: B) -> Bool where B.Value: Equatable {
	return tBmqNhqsQX4fkvEl5WteePrWnh68pJzT.Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_ != h8CiGIAibvuvC38J0_fCqSpKRjZenDaF.Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_
}


// MARK: Map

/// Maps the value of a box into a new box.
public func Z4LHL5ERsCYbkMcY9iSGLsZ5bTm56Zph<B: TFjAOKm5Qz5ghxs7EydLrczvxHJkkjoI, C: TFjAOKm5Qz5ghxs7EydLrczvxHJkkjoI>(_ otM2QFooyzzkecNroSHkfEUyh1oqnpTQ: B, nwIHl03fIMbSFWYwkJD4PbAu2HWP6P_z: (B.Value) -> C.Value) -> C {
	return C(nwIHl03fIMbSFWYwkJD4PbAu2HWP6P_z(otM2QFooyzzkecNroSHkfEUyh1oqnpTQ.Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_))
}
