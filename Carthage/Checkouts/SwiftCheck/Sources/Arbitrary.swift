//
//  Arbitrary.swift
//  SwiftCheck
//
//  Created by Robert Widmann on 7/31/14.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

/// A type that implements random generation and shrinking of values.
///
/// While testing, SwiftCheck will invoke `arbitrary` a given amount of times 
/// (usually 100 if the default settings are used).  During that time, the 
/// receiver has an opportunity to call through to any data or sources of 
/// randomness it needs to return what it deems an "Arbitrary" value.
///
/// Shrinking is reduction in the complexity of a tested value to remove noise 
/// and present a minimal counterexample when a property fails.  A shrink 
/// necessitates returning a list of all possible "smaller" values for 
/// SwiftCheck to run through.  As long as each individual value in the returned
/// list is less than or equal to the size of the input value, and is not a 
/// duplicate of the input value, a minimal case should be reached fairly 
/// efficiently. Shrinking is an optional extension of normal testing.  If no 
/// implementation of `shrink` is provided, SwiftCheck will default to an empty 
/// one - that is, no shrinking will occur.
///
/// As an example, take the `ArrayOf` implementation of shrink:
///
///     Arbitrary.shrink(ArrayOf([1, 2, 3]))
///	    > [[], [2,3], [1,3], [1,2], [0,2,3], [1,0,3], [1,1,3], [1,2,0], [1,2,2]]
///
/// SwiftCheck will search each case forward, one-by-one, and continue shrinking
/// until it has reached a case it deems minimal enough to present.
///
/// SwiftCheck implements a number of generators for common Swift Standard 
/// Library types for convenience.  If more fine-grained testing is required see
/// `Modifiers.swift` for an example of how to define a "Modifier" type to 
/// implement it.
public protocol Arbitrary {
	/// The generator for this particular type.
	///
	/// This function should call out to any sources of randomness or state 
	/// necessary to generate values.  It should not, however, be written as a 
	/// deterministic function.  If such a generator is needed, combinators are 
	/// provided in `Gen.swift`.
	static var arbitrary : Gen<Self> { get }

	/// An optional shrinking function.  If this function goes unimplemented, it 
	/// is the same as returning the empty list.
	///
	/// Shrunken values must be less than or equal to the "size" of the original 
	/// type but never the same as the value provided to this function (or a loop 
	/// will form in the shrinker).  It is recommended that they be presented 
	/// smallest to largest to speed up the overall shrinking process.
	static func shrink(_ : Self) -> [Self]
}

extension Arbitrary {
	/// The implementation of a shrink that returns no alternatives.
	public static func shrink(_ : Self) -> [Self] {
		return []
	}
}

extension IntegerType {
	/// Shrinks any `IntegerType`.
	public var shrinkIntegral : [Self] {
		return unfoldr({ i in
			if i <= 0 {
				return .None
			}
			let n = i / 2
			return .Some((n, n))
		}, initial: self < 0 ? (Self.multiplyWithOverflow(self, -1).0) : self)
	}
}

extension Bool : Arbitrary {
	/// Returns a generator of `Bool`ean values.
	public static var arbitrary : Gen<Bool> {
		return Gen<Bool>.choose((false, true))
	}

	/// The default shrinking function for `Bool`ean values.
	public static func shrink(x : Bool) -> [Bool] {
		if x {
			return [false]
		}
		return []
	}
}

extension Int : Arbitrary {
	/// Returns a generator of `Int` values.
	public static var arbitrary : Gen<Int> {
		return Gen.sized { n in
			return Gen<Int>.choose((-n, n))
		}
	}

	/// The default shrinking function for `Int` values.
	public static func shrink(x : Int) -> [Int] {
		return x.shrinkIntegral
	}
}

extension Int8 : Arbitrary {
	/// Returns a generator of `Int8` values.
	public static var arbitrary : Gen<Int8> {
		return Gen.sized { n in
			return Gen<Int8>.choose((Int8(truncatingBitPattern: -n), Int8(truncatingBitPattern: n)))
		}
	}

	/// The default shrinking function for `Int8` values.
	public static func shrink(x : Int8) -> [Int8] {
		return x.shrinkIntegral
	}
}

extension Int16 : Arbitrary {
	/// Returns a generator of `Int16` values.
	public static var arbitrary : Gen<Int16> {
		return Gen.sized { n in
			return Gen<Int16>.choose((Int16(truncatingBitPattern: -n), Int16(truncatingBitPattern: n)))
		}
	}

	/// The default shrinking function for `Int16` values.
	public static func shrink(x : Int16) -> [Int16] {
		return x.shrinkIntegral
	}
}

extension Int32 : Arbitrary {
	/// Returns a generator of `Int32` values.
	public static var arbitrary : Gen<Int32> {
		return Gen.sized { n in
			return Gen<Int32>.choose((Int32(truncatingBitPattern: -n), Int32(truncatingBitPattern: n)))
		}
	}

	/// The default shrinking function for `Int32` values.
	public static func shrink(x : Int32) -> [Int32] {
		return x.shrinkIntegral
	}
}

extension Int64 : Arbitrary {
	/// Returns a generator of `Int64` values.
	public static var arbitrary : Gen<Int64> {
		return Gen.sized { n in
			return Gen<Int64>.choose((Int64(-n), Int64(n)))
		}
	}

	/// The default shrinking function for `Int64` values.
	public static func shrink(x : Int64) -> [Int64] {
		return x.shrinkIntegral
	}
}

extension UInt : Arbitrary {
	/// Returns a generator of `UInt` values.
	public static var arbitrary : Gen<UInt> {
		return Gen.sized { n in Gen<UInt>.choose((0, UInt(n))) }
	}

	/// The default shrinking function for `UInt` values.
	public static func shrink(x : UInt) -> [UInt] {
		return x.shrinkIntegral
	}
}

extension UInt8 : Arbitrary {
	/// Returns a generator of `UInt8` values.
	public static var arbitrary : Gen<UInt8> {
		return Gen.sized { n in
			return Gen.sized { n in Gen<UInt8>.choose((0, UInt8(truncatingBitPattern: n))) }
		}
	}

	/// The default shrinking function for `UInt8` values.
	public static func shrink(x : UInt8) -> [UInt8] {
		return x.shrinkIntegral
	}
}

extension UInt16 : Arbitrary {
	/// Returns a generator of `UInt16` values.
	public static var arbitrary : Gen<UInt16> {
		return Gen.sized { n in Gen<UInt16>.choose((0, UInt16(truncatingBitPattern: n))) }
	}

	/// The default shrinking function for `UInt16` values.
	public static func shrink(x : UInt16) -> [UInt16] {
		return x.shrinkIntegral
	}
}

extension UInt32 : Arbitrary {
	/// Returns a generator of `UInt32` values.
	public static var arbitrary : Gen<UInt32> {
		return Gen.sized { n in Gen<UInt32>.choose((0, UInt32(truncatingBitPattern: n))) }
	}

	/// The default shrinking function for `UInt32` values.
	public static func shrink(x : UInt32) -> [UInt32] {
		return x.shrinkIntegral
	}
}

extension UInt64 : Arbitrary {
	/// Returns a generator of `UInt64` values.
	public static var arbitrary : Gen<UInt64> {
		return Gen.sized { n in Gen<UInt64>.choose((0, UInt64(n))) }
	}

	/// The default shrinking function for `UInt64` values.
	public static func shrink(x : UInt64) -> [UInt64] {
		return x.shrinkIntegral
	}
}

extension Float : Arbitrary {
	/// Returns a generator of `Float` values.
	public static var arbitrary : Gen<Float> {
		let precision : Int64 = 9999999999999

		return Gen<Float>.sized { n in
			if n == 0 {
				return Gen<Float>.pure(0.0)
			}

			let numerator = Gen<Int64>.choose((Int64(-n) * precision, Int64(n) * precision))
			let denominator = Gen<Int64>.choose((1, precision))

			return numerator
				>>- { a in denominator
					>>- { b in Gen<Float>.pure(Float(a) / Float(b)) } }
		}
	}

	/// The default shrinking function for `Float` values.
	public static func shrink(x : Float) -> [Float] {
		return unfoldr({ i in
			if i == 0.0 {
				return .None
			}
			let n = i / 2.0
			return .Some((n, n))
		}, initial: x)
	}
}

extension Double : Arbitrary {
	/// Returns a generator of `Double` values.
	public static var arbitrary : Gen<Double> {
		let precision : Int64 = 9999999999999

		return Gen<Double>.sized { n in
			if n == 0 {
				return Gen<Double>.pure(0.0)
			}

			let numerator = Gen<Int64>.choose((Int64(-n) * precision, Int64(n) * precision))
			let denominator = Gen<Int64>.choose((1, precision))

			return numerator
				>>- { a in denominator
					>>- { b in Gen<Double>.pure(Double(a) / Double(b)) } }
		}
	}

	/// The default shrinking function for `Double` values.
	public static func shrink(x : Double) -> [Double] {
		return unfoldr({ i in
			if i == 0.0 {
				return .None
			}
			let n = i / 2.0
			return .Some((n, n))
		}, initial: x)
	}
}

extension UnicodeScalar : Arbitrary {
	/// Returns a generator of `UnicodeScalar` values.
	public static var arbitrary : Gen<UnicodeScalar> {
		return UInt32.arbitrary.flatMap(Gen<UnicodeScalar>.pure • UnicodeScalar.init)
	}

	/// The default shrinking function for `UnicodeScalar` values.
	public static func shrink(x : UnicodeScalar) -> [UnicodeScalar] {
		let s : UnicodeScalar = UnicodeScalar(UInt32(tolower(Int32(x.value))))
		return [ "a", "b", "c", s, "A", "B", "C", "1", "2", "3", "\n", " " ].nub.filter { $0 < x }
	}
}

extension String : Arbitrary {
	/// Returns a generator of `String` values.
	public static var arbitrary : Gen<String> {
		let chars = Gen.sized(Character.arbitrary.proliferateSized)
		return chars >>- { Gen<String>.pure(String($0)) }
	}

	/// The default shrinking function for `String` values.
	public static func shrink(s : String) -> [String] {
		return [Character].shrink([Character](s.characters)).map { String($0) }
	}
}

extension Character : Arbitrary {
	/// Returns a generator of `Character` values.
	public static var arbitrary : Gen<Character> {
		return Gen<UInt32>.choose((32, 255)) >>- (Gen<Character>.pure • Character.init • UnicodeScalar.init)
	}

	/// The default shrinking function for `Character` values.
	public static func shrink(x : Character) -> [Character] {
		let ss = String(x).unicodeScalars
		return UnicodeScalar.shrink(ss[ss.startIndex]).map(Character.init)
	}
}

extension AnyForwardIndex : Arbitrary {
	/// Returns a generator of `AnyForwardIndex` values.
	public static var arbitrary : Gen<AnyForwardIndex> {
		return Gen<Int64>.choose((1, Int64.max)).flatMap(Gen<AnyForwardIndex>.pure • AnyForwardIndex.init)
	}
}

extension AnyRandomAccessIndex : Arbitrary {
	/// Returns a generator of `AnyRandomAccessIndex` values.
	public static var arbitrary : Gen<AnyRandomAccessIndex> {
		return Gen<Int64>.choose((1, Int64.max)).flatMap(Gen<AnyRandomAccessIndex>.pure • AnyRandomAccessIndex.init)
	}
}

extension Mirror : Arbitrary {
	/// Returns a generator of `Mirror` values.
	public static var arbitrary : Gen<Mirror> {
		let genAny : Gen<Any> = Gen<Any>.oneOf([
			Bool.arbitrary.map(asAny),
			Int.arbitrary.map(asAny),
			UInt.arbitrary.map(asAny),
			Float.arbitrary.map(asAny),
			Double.arbitrary.map(asAny),
			Character.arbitrary.map(asAny),
		])

		let genAnyWitnessed : Gen<Any> = Gen<Any>.oneOf([
			Optional<Int>.arbitrary.map(asAny),
			Array<Int>.arbitrary.map(asAny),
			Set<Int>.arbitrary.map(asAny),
		])

		return Gen<Any>.oneOf([
			genAny,
			genAnyWitnessed,
		]).map(Mirror.init)
	}
}


// MARK: - Implementation Details Follow

private func asAny<T>(x : T) -> Any {
	return x
}

extension Array where Element : Hashable {
	private var nub : [Element] {
		return [Element](Set(self))
	}
}

private func unfoldr<A, B>(f : B -> Optional<(A, B)>, initial : B) -> [A] {
	var acc = [A]()
	var ini = initial
	while let next = f(ini) {
		acc.insert(next.0, atIndex: 0)
		ini = next.1
	}
	return acc
}

#if os(Linux)
	import Glibc
#else
	import Darwin
#endif
