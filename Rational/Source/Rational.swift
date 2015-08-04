//
//  RationalNumber.swift
//  Rational
//
//  Created by TJ Usiyan on 7/25/15.
//  Copyright © 2015 Buttons and Lights LLC. All rights reserved.
//

import Darwin

infix operator • { }

internal func •<T, U, V>(f: U -> V, g: T -> U) -> T -> V {
    return { f(g($0)) }
}


public struct Rational {

    /// The number representing how many of the parts indicated by the denominator are taken
    public let numerator : Int

    /// The divisor, indicating how many parts single units are to be broken into.
    public let denominator : Int

    internal init(verified tuple:(numerator: Int, denominator: Int)) {
        self.init(verifiedNumerator: tuple.numerator, verifiedDenominator: tuple.denominator)
    }

    private init(verifiedNumerator numerator: Int, verifiedDenominator denominator:Int) {
        precondition(denominator != 0)

        self.numerator = numerator
        self.denominator = denominator
    }

    // Initialize a Rational from a numerator and a denominator.
    public init?(_ numerator: Int, _ denominator:Int=1 ) {
        guard denominator != 0 else { return nil }

        self.init(verified:Rational.normalizeSign(numerator: numerator, denominator: denominator))
    }

    public init(_ value: Double) {
        self.init( floatLiteral: value )
    }

    public init(_ value: Int) {
        self.init(integerLiteral: value)
    }
}

extension Rational : IntegerLiteralConvertible, FloatLiteralConvertible {
    // Initialize a Rational from an integer or an integer literal.
    public init(integerLiteral value: Int) {
        self.init(verifiedNumerator: value, verifiedDenominator: 1)
    }

    // Initialize a Rational from a double.
    public init(floatLiteral value: Double) {
        guard !value.isInfinite && !value.isNaN && !value.isSubnormal else {
            /* @todo throw or return nil 2015-07-24 */
            fatalError("Rational can only be constructed using a normal double.")
        }

        let thePower:Int = 10 ** Rational.findExponentForNumber(value)

        let theTuple:(n:Int, d:Int) = Rational.normalizeSign(numerator: (value.isSignMinus ? -1 : 1) * lround(value * Double(thePower)), denominator: thePower)
        let theSimpleTuple:(Int, Int) = Rational.simplify(numerator: theTuple.n, denominator: theTuple.d)
        self.init(verified:theSimpleTuple)
    }
}

extension Rational {
    internal static func normalizeSign(numerator numerator: Int, denominator:Int) -> (Int, Int) {
        if denominator < 0 {
            return (-numerator, -denominator)
        } else {
            return (numerator, denominator)
        }
    }

    internal static func simplify(numerator numerator: Int, denominator:Int) -> (Int, Int) {
        let common = greatestCommonDivisor(abs(numerator), abs(denominator))
        return  (sNumerator: numerator/common, sDenominator: denominator/common)
    }

    public var inLowestTerms: Rational {
        let (simpleNumerator, simpleDenominator) = Rational.simplify(numerator: numerator, denominator: denominator)
        return Rational(verifiedNumerator: simpleNumerator, verifiedDenominator: simpleDenominator)
    }
}

extension Rational : Hashable {
    public var hashValue : Int {
        return numerator ^ denominator
    }
}

extension Rational : CustomStringConvertible {
    public var description : String {
        return "\(numerator)/\(denominator)"
    }

    /// The rational number's multiplicative inverse, or nil if the inverse would be x/0.
    public var inverse : Rational? {
        return numerator == 0 ? nil : Rational(denominator, numerator)
    }
}


// MARK: - Math
extension Rational : Equatable /* @todo already filed radar against explicit requirement of Equatable 2015-08-04 */, Comparable {}

public func ==(lhs: Rational, rhs: Rational) -> Bool {
    let sLhs = lhs.inLowestTerms
    let sRhs = rhs.inLowestTerms
    return sLhs.numerator == sRhs.numerator && sLhs.denominator == sRhs.denominator
}

public func <(lhs: Rational, rhs: Rational) -> Bool {
    return Rational.findLeastCommonDenominatorAndApply(lhs, rhs: rhs) { (newLeft, newRight, _) in
        return newLeft < newRight
    }
}

public func +(augend:Rational, addend:Rational) -> Rational {
    return Rational.findLeastCommonDenominatorAndOperateOnNumerators(augend, rhs: addend, computeNumerator: +)
}

public func -(subtrahend:Rational, diminuend:Rational) -> Rational {
    return Rational.findLeastCommonDenominatorAndOperateOnNumerators(subtrahend, rhs: diminuend, computeNumerator: -)
}

public func *(multiplicand:Rational, multiplier:Rational) -> Rational {
    let theTuple = Rational.normalizeSign(numerator: multiplicand.numerator * multiplier.numerator, denominator: multiplicand.denominator * multiplier.denominator)
    return Rational(verified: theTuple)
}

public func /(dividend:Rational, divisor:Rational) -> Rational {
    let theTuple = Rational.normalizeSign(numerator: dividend.numerator * divisor.denominator, denominator: dividend.denominator * divisor.numerator)
    return Rational(verified: theTuple)
}

// MARK: Utilities

/// Return the greatest common factor for the two integer arguments. This function uses the iterative Euclidean
/// algorithm for calculating GCF.
func greatestCommonDivisor(lhs: Int, _ rhs: Int) -> Int {
    var a = lhs
    var b = rhs
    while b != 0 {
        let t = b
        b = a % b
        a = t
    }
    return a
}

extension Rational {
    static func leastCommonDivisor(lhs: Int, _ rhs: Int) -> Int {
        return (abs(lhs) / greatestCommonDivisor(lhs, rhs)) * abs(rhs)
    }

    static func findLeastCommonDenominatorAndApply<T>(lhs: Rational, rhs: Rational, transform:(lhsNumerator: Int, rhsNumerator:Int, denominator: Int) -> T) -> T {
        let newDenominator = Rational.leastCommonDenominator(lhs, rhs)

        let leftNumerator = lhs.numerator * (newDenominator / lhs.denominator)
        let rightNumerator = rhs.numerator * (newDenominator / rhs.denominator)

        return transform(lhsNumerator: leftNumerator, rhsNumerator: rightNumerator, denominator: newDenominator)
    }

    /* @todo figure out a good name 2015-07-28 */
    static func findLeastCommonDenominatorAndOperateOnNumerators(lhs: Rational, rhs: Rational, computeNumerator:(newLeftNumerator: Int, newRightNumerator:Int) -> Int) -> Rational {

        return findLeastCommonDenominatorAndApply(lhs, rhs: rhs) { (newLeftNumerator, newRightNumerator, denominator) -> Rational in
            let theTuple = Rational.normalizeSign(numerator: computeNumerator(newLeftNumerator: newLeftNumerator, newRightNumerator: newRightNumerator), denominator: denominator)
            return Rational(verified: theTuple)
        }

    }

    static func greatestCommonDenominator(lhs: Rational, _ rhs: Rational) -> Int {
        return greatestCommonDivisor(lhs.denominator, rhs.denominator)
    }

    static func leastCommonDenominator(lhs: Rational, _ rhs: Rational) -> Int {
        return leastCommonDivisor(lhs.denominator, rhs.denominator)
    }

    public static func findExponentForNumber(input:Double) -> Int {

        func _findExp(accum:Int, _ remainder:Double) -> (accum:Int, remainder:Double) {
            if remainder % 1 == 0 {
                return (accum, remainder)
            } else {
                return _findExp(accum + 1, remainder * 10)
            }
        }

        return _findExp(0, abs(input)).accum
    }
    

}


infix operator ** {
associativity left
precedence 240
}

internal func **(base: Int, power: Int) -> Int {
    return (0..<power).reduce(1) { (accum, _) -> Int in accum * base }
}

internal func **(base: Double, power: Double) -> Double {
    return pow(base, power)
}

internal func **(base: Float, power: Float) -> Float {
    return pow(base, power)
}
