//
//  RationalTests.swift
//  RationalTests
//
//  Created by TJ Usiyan on 7/25/15.
//  Copyright © 2015 Buttons and Lights LLC. All rights reserved.
//

import XCTest
import SwiftCheck
@testable import Rational

extension Rational : Arbitrary {
    internal static func create(numerator n: Int) -> (Int) -> Rational {
        return { d in Rational(n, d)! }
    }

    public static var arbitrary: SwiftCheck.Gen<Rational> {
        return Gen<Rational>.compose { c in
            let d = c.generate(using: Int.arbitrary.suchThat { $0 != 0 })
            return Rational(c.generate(), d)!
        }
    }

    public static func shrink(_ value: Rational) -> [Rational] {
        let numerators = value.numerator...0
        let denominators = value.denominator..<0

        return Array(numerators.flatMap { Rational($0, value.denominator) }) + Array(denominators.flatMap { Rational(value.numerator, $0) })
    }
}

class RationalTests: XCTestCase {
    func testAll() {
        property("The inverse of an inverse equals identity") <- forAll { (i : Rational) in
            return (i.numerator != 0) ==> {
                return i.inverse?.inverse! == i
            }
        }

        property("Addition is commutative") <- forAll { (twoRationals:(Rational, Rational)) in
            let (i, j) = twoRationals
            return (i + j) == (j + i)
        }

        property("Multiplication is commutative") <- forAll { (twoRationals:(Rational, Rational)) in
            let (i, j) = twoRationals
            return (i * j) == (j * i)
        }

        property("Addition is commutative 2") <- forAll { (threeRationals:(Rational, Rational, Rational)) in
            let (i, j, k) = threeRationals

            let caseOne = (i + j + k)
            let caseTwo = ((i + j) + k)
            let caseThree = (i + (j + k))

            return (caseOne == caseTwo) && (caseTwo == caseThree)
        }

        property("Multiplication is commutative 2") <- forAll { (threeRationals:(Rational, Rational, Rational)) in
            let (i, j, k) = threeRationals

            let caseOne = (i * j * k)
            let caseTwo = ((i * j) * k)
            let caseThree = (i * (j * k))

            return (caseOne == caseTwo) && (caseTwo == caseThree)
        }

        property("Division is multiplication by inverse") <- forAll { (twoRationals:(Rational, Rational)) in
            let (i, j) = twoRationals
            return (j.numerator != 0) ==> {
                return (i / j) == (i * j.inverse!)
            }
        }

        property("Multiplication by inverse is multiplicative identity") <- forAll { (i: Rational) in
            return (i.numerator != 0) ==> {
                return (i * i.inverse!) == 1
            }
        }

        property("Square maps to numerator and denominator") <- forAll { (i:Rational) in
            let squared = i * i
            return (squared.numerator == (i.numerator * i.numerator)) && (squared.denominator == (i.denominator * i.denominator))
        }

        property("Multiplication over Addition is distributive") <- forAll { (threeRationals:(Rational, Rational, Rational)) in
            let (i, j, k) = threeRationals
            return i * (j + k) == (i * j) + (i * k)
        }

        property("Equivalence holds for `equivalent` method") <- forAll { (input:(Int, Rational)) in
            let (i, r) = input
            return (i != 0) ==> {
                return Rational(equivalentTo: r, multiplicand: i) == r
            }
        }
/*
        /* @todo I can't seem to guarantee this, actually. 2015-08-21 */
        property("Conversion through Double is not too lossy") <- forAll { (i:Rational) in
            let lhs = Double(rational: i)
            let rhs = Double(rational: Rational(floatLiteral: Double(rational: i)))
            return lhs.distanceTo(rhs) <= DBL_EPSILON
        }
*/

        property("Multiplication's effect pivots on multiplicative identity") <- forAll { (input:(Int, Rational)) in
            let (i, r) = input
            let absI = abs(i)
            return ((absI != 0) && (r.numerator != 0)) ==> {
                if r.numerator > r.denominator {
                    return Rational(absI) * r > Rational(absI   )
                } else if r.numerator < r.denominator {
                    return Rational(absI) * r < Rational(absI)
                } else {
                    return Rational(absI) * r == Rational(absI)
                }
            }
        }
    }
}
