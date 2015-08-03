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
    internal static func create(numerator n: Int) -> Int -> Rational {
        return { d in Rational(n, d)! }
    }

    public static var arbitrary: SwiftCheck.Gen<Rational> {
        return Rational.create <^> Int.arbitrary <*> Int.arbitrary.suchThat { $0 != 0 }
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
    }
}
