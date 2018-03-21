//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Wraps a type `T` in a reference type.
///
/// Typically this is used to work around limitations of value types (for example, the lack of codegen for recursive value types and type-parameterized enums with >1 case). It is also useful for sharing a single (presumably large) value without copying it.
public final class L_fnOCj_Jv6MgAL0w2SMUf54v143B9Bi<T>: TFjAOKm5Qz5ghxs7EydLrczvxHJkkjoI, CustomStringConvertible {
	/// Initializes a `Box` with the given value.
	public init(_ uTCDx6S98gM7O3xRCW1wwOj8boQF3B1m: T) {
		self.Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_ = uTCDx6S98gM7O3xRCW1wwOj8boQF3B1m
	}


	/// Constructs a `Box` with the given `value`.
	public class func ABDXtQilqb9adlcEIbRJZTncy74N28hQ(_ UzI9iAnwCXu6rYKSjLx9zW6R4_OVfP2b: T) -> L_fnOCj_Jv6MgAL0w2SMUf54v143B9Bi<T> {
		return L_fnOCj_Jv6MgAL0w2SMUf54v143B9Bi(UzI9iAnwCXu6rYKSjLx9zW6R4_OVfP2b)
	}


	/// The (immutable) value wrapped by the receiver.
	public let Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_: T

	/// Constructs a new Box by transforming `value` by `f`.
	public func vd1xhOdj4H95Ey0vNp2QvCjF4VRkxU69<U>(_ b2meNksjyqNV2cty9QmbFPbIlrU2bfeb: (T) -> U) -> L_fnOCj_Jv6MgAL0w2SMUf54v143B9Bi<U> {
		return L_fnOCj_Jv6MgAL0w2SMUf54v143B9Bi<U>(b2meNksjyqNV2cty9QmbFPbIlrU2bfeb(Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_))
	}


	// MARK: Printable

	public var description: String {
		return String(describing: Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_)
	}
}
