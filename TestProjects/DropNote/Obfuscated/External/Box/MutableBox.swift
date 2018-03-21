//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Wraps a type `T` in a mutable reference type.
///
/// While this, like `Box<T>` could be used to work around limitations of value types, it is much more useful for sharing a single mutable value such that mutations are shared.
///
/// As with all mutable state, this should be used carefully, for example as an optimization, rather than a default design choice. Most of the time, `Box<T>` will suffice where any `BoxType` is needed.
public final class eCVootg8kYFq_54DJIWiuNHzIQNTx7o9<T>: DXOhOP50zQ10JFAOJkP9j7KjYLpB6Rya, CustomStringConvertible {
	/// Initializes a `MutableBox` with the given value.
	public init(_ uTCDx6S98gM7O3xRCW1wwOj8boQF3B1m: T) {
		self.Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_ = uTCDx6S98gM7O3xRCW1wwOj8boQF3B1m
	}

	/// The (mutable) value wrapped by the receiver.
	public var Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_: T

	/// Constructs a new MutableBox by transforming `value` by `f`.
	public func ycjiWiVoIU4SSpdXAhFTnMFu04YE_Yt1<U>(_ YxB0UCLgaNs7sRIO_UXSOjSmux2QThd0: (T) -> U) -> eCVootg8kYFq_54DJIWiuNHzIQNTx7o9<U> {
		return eCVootg8kYFq_54DJIWiuNHzIQNTx7o9<U>(YxB0UCLgaNs7sRIO_UXSOjSmux2QThd0(Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_))
	}

	// MARK: Printable

	public var description: String {
		return String(describing: Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_)
	}
}
