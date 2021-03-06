//
//  IntTests.swift
//  Rational
//
//  Created by TJ Usiyan on 3/25/16.
//  Copyright © 2016 Buttons and Lights LLC. All rights reserved.
//

import XCTest
import SwiftCheck
@testable import Rational

@warn_unused_result public func ==(lhs:(quotient: Int, modulus: Int), rhs:(quotient: Int, modulus: Int)) -> Bool {
    return (lhs.quotient == rhs.quotient) && (lhs.modulus == rhs.modulus)
}

@warn_unused_result public func ==(lhs:(quotient: Int, remainder: Int), rhs:(quotient: Int, remainder: Int)) -> Bool {
    return (lhs.quotient == rhs.quotient) && (lhs.remainder == rhs.remainder)
}

class IntTests: XCTestCase {
    func testAll() {
        property("(x ‘quot‘ y)⋆y + (x ‘rem‘ y) == x ") <- forAll { (x: Int, y: Int) in
            return (y != 0) ==> {
                let (quot, rem) = x.quotRem(y)
                if (quot * y) + rem == x {
                    return true
                } else {
                    return false
                }
            }
        }

        property("(x ‘div‘ y)⋆y + (x ‘mod‘ y) == x ") <- forAll { (x: Int, y: Int) in
            return (y != 0) ==> {
                let (div, mod) = x.divMod(y)
                if (div * y) + mod == x {
                    return true
                } else {
                    return false
                }
            }
        }
    }

    func testDivMod() {
        XCTAssertTrue((-25).divMod( 12) == (quotient:  -3, modulus:  11))
        XCTAssertTrue((-24).divMod( 12) == (quotient:  -2, modulus:   0))
        XCTAssertTrue((-23).divMod( 12) == (quotient:  -2, modulus:   1))
        XCTAssertTrue((-22).divMod( 12) == (quotient:  -2, modulus:   2))
        XCTAssertTrue((-21).divMod( 12) == (quotient:  -2, modulus:   3))
        XCTAssertTrue((-20).divMod( 12) == (quotient:  -2, modulus:   4))
        XCTAssertTrue((-19).divMod( 12) == (quotient:  -2, modulus:   5))
        XCTAssertTrue((-18).divMod( 12) == (quotient:  -2, modulus:   6))
        XCTAssertTrue((-17).divMod( 12) == (quotient:  -2, modulus:   7))
        XCTAssertTrue((-16).divMod( 12) == (quotient:  -2, modulus:   8))
        XCTAssertTrue((-15).divMod( 12) == (quotient:  -2, modulus:   9))
        XCTAssertTrue((-14).divMod( 12) == (quotient:  -2, modulus:  10))
        XCTAssertTrue((-13).divMod( 12) == (quotient:  -2, modulus:  11))
        XCTAssertTrue((-12).divMod( 12) == (quotient:  -1, modulus:   0))
        XCTAssertTrue((-11).divMod( 12) == (quotient:  -1, modulus:   1))
        XCTAssertTrue((-10).divMod( 12) == (quotient:  -1, modulus:   2))
        XCTAssertTrue(( -9).divMod( 12) == (quotient:  -1, modulus:   3))
        XCTAssertTrue(( -8).divMod( 12) == (quotient:  -1, modulus:   4))
        XCTAssertTrue(( -7).divMod( 12) == (quotient:  -1, modulus:   5))
        XCTAssertTrue(( -6).divMod( 12) == (quotient:  -1, modulus:   6))
        XCTAssertTrue(( -5).divMod( 12) == (quotient:  -1, modulus:   7))
        XCTAssertTrue(( -4).divMod( 12) == (quotient:  -1, modulus:   8))
        XCTAssertTrue(( -3).divMod( 12) == (quotient:  -1, modulus:   9))
        XCTAssertTrue(( -2).divMod( 12) == (quotient:  -1, modulus:  10))
        XCTAssertTrue(( -1).divMod( 12) == (quotient:  -1, modulus:  11))
        XCTAssertTrue((  0).divMod( 12) == (quotient:   0, modulus:   0))
        XCTAssertTrue((  1).divMod( 12) == (quotient:   0, modulus:   1))
        XCTAssertTrue((  2).divMod( 12) == (quotient:   0, modulus:   2))
        XCTAssertTrue((  3).divMod( 12) == (quotient:   0, modulus:   3))
        XCTAssertTrue((  4).divMod( 12) == (quotient:   0, modulus:   4))
        XCTAssertTrue((  5).divMod( 12) == (quotient:   0, modulus:   5))
        XCTAssertTrue((  6).divMod( 12) == (quotient:   0, modulus:   6))
        XCTAssertTrue((  7).divMod( 12) == (quotient:   0, modulus:   7))
        XCTAssertTrue((  8).divMod( 12) == (quotient:   0, modulus:   8))
        XCTAssertTrue((  9).divMod( 12) == (quotient:   0, modulus:   9))
        XCTAssertTrue(( 10).divMod( 12) == (quotient:   0, modulus:  10))
        XCTAssertTrue(( 11).divMod( 12) == (quotient:   0, modulus:  11))
        XCTAssertTrue(( 12).divMod( 12) == (quotient:   1, modulus:   0))
        XCTAssertTrue(( 13).divMod( 12) == (quotient:   1, modulus:   1))
        XCTAssertTrue(( 14).divMod( 12) == (quotient:   1, modulus:   2))
        XCTAssertTrue(( 15).divMod( 12) == (quotient:   1, modulus:   3))
        XCTAssertTrue(( 16).divMod( 12) == (quotient:   1, modulus:   4))
        XCTAssertTrue(( 17).divMod( 12) == (quotient:   1, modulus:   5))
        XCTAssertTrue(( 18).divMod( 12) == (quotient:   1, modulus:   6))
        XCTAssertTrue(( 19).divMod( 12) == (quotient:   1, modulus:   7))
        XCTAssertTrue(( 20).divMod( 12) == (quotient:   1, modulus:   8))
        XCTAssertTrue(( 21).divMod( 12) == (quotient:   1, modulus:   9))
        XCTAssertTrue(( 22).divMod( 12) == (quotient:   1, modulus:  10))
        XCTAssertTrue(( 23).divMod( 12) == (quotient:   1, modulus:  11))
        XCTAssertTrue(( 24).divMod( 12) == (quotient:   2, modulus:   0))
        XCTAssertTrue(( 25).divMod( 12) == (quotient:   2, modulus:   1))

        XCTAssertTrue((-25).divMod(-12) == (quotient:   2, modulus:  -1))
        XCTAssertTrue((-24).divMod(-12) == (quotient:   2, modulus:   0))
        XCTAssertTrue((-23).divMod(-12) == (quotient:   1, modulus: -11))
        XCTAssertTrue((-22).divMod(-12) == (quotient:   1, modulus: -10))
        XCTAssertTrue((-21).divMod(-12) == (quotient:   1, modulus:  -9))
        XCTAssertTrue((-20).divMod(-12) == (quotient:   1, modulus:  -8))
        XCTAssertTrue((-19).divMod(-12) == (quotient:   1, modulus:  -7))
        XCTAssertTrue((-18).divMod(-12) == (quotient:   1, modulus:  -6))
        XCTAssertTrue((-17).divMod(-12) == (quotient:   1, modulus:  -5))
        XCTAssertTrue((-16).divMod(-12) == (quotient:   1, modulus:  -4))
        XCTAssertTrue((-15).divMod(-12) == (quotient:   1, modulus:  -3))
        XCTAssertTrue((-14).divMod(-12) == (quotient:   1, modulus:  -2))
        XCTAssertTrue((-13).divMod(-12) == (quotient:   1, modulus:  -1))
        XCTAssertTrue((-12).divMod(-12) == (quotient:   1, modulus:   0))
        XCTAssertTrue((-11).divMod(-12) == (quotient:   0, modulus: -11))
        XCTAssertTrue((-10).divMod(-12) == (quotient:   0, modulus: -10))
        XCTAssertTrue(( -9).divMod(-12) == (quotient:   0, modulus:  -9))
        XCTAssertTrue(( -8).divMod(-12) == (quotient:   0, modulus:  -8))
        XCTAssertTrue(( -7).divMod(-12) == (quotient:   0, modulus:  -7))
        XCTAssertTrue(( -6).divMod(-12) == (quotient:   0, modulus:  -6))
        XCTAssertTrue(( -5).divMod(-12) == (quotient:   0, modulus:  -5))
        XCTAssertTrue(( -4).divMod(-12) == (quotient:   0, modulus:  -4))
        XCTAssertTrue(( -3).divMod(-12) == (quotient:   0, modulus:  -3))
        XCTAssertTrue(( -2).divMod(-12) == (quotient:   0, modulus:  -2))
        XCTAssertTrue(( -1).divMod(-12) == (quotient:   0, modulus:  -1))
        XCTAssertTrue((  0).divMod(-12) == (quotient:   0, modulus:   0))
        XCTAssertTrue((  1).divMod(-12) == (quotient:  -1, modulus: -11))
        XCTAssertTrue((  2).divMod(-12) == (quotient:  -1, modulus: -10))
        XCTAssertTrue((  3).divMod(-12) == (quotient:  -1, modulus:  -9))
        XCTAssertTrue((  4).divMod(-12) == (quotient:  -1, modulus:  -8))
        XCTAssertTrue((  5).divMod(-12) == (quotient:  -1, modulus:  -7))
        XCTAssertTrue((  6).divMod(-12) == (quotient:  -1, modulus:  -6))
        XCTAssertTrue((  7).divMod(-12) == (quotient:  -1, modulus:  -5))
        XCTAssertTrue((  8).divMod(-12) == (quotient:  -1, modulus:  -4))
        XCTAssertTrue((  9).divMod(-12) == (quotient:  -1, modulus:  -3))
        XCTAssertTrue(( 10).divMod(-12) == (quotient:  -1, modulus:  -2))
        XCTAssertTrue(( 11).divMod(-12) == (quotient:  -1, modulus:  -1))
        XCTAssertTrue(( 12).divMod(-12) == (quotient:  -1, modulus:   0))
        XCTAssertTrue(( 13).divMod(-12) == (quotient:  -2, modulus: -11))
        XCTAssertTrue(( 14).divMod(-12) == (quotient:  -2, modulus: -10))
        XCTAssertTrue(( 15).divMod(-12) == (quotient:  -2, modulus:  -9))
        XCTAssertTrue(( 16).divMod(-12) == (quotient:  -2, modulus:  -8))
        XCTAssertTrue(( 17).divMod(-12) == (quotient:  -2, modulus:  -7))
        XCTAssertTrue(( 18).divMod(-12) == (quotient:  -2, modulus:  -6))
        XCTAssertTrue(( 19).divMod(-12) == (quotient:  -2, modulus:  -5))
        XCTAssertTrue(( 20).divMod(-12) == (quotient:  -2, modulus:  -4))
        XCTAssertTrue(( 21).divMod(-12) == (quotient:  -2, modulus:  -3))
        XCTAssertTrue(( 22).divMod(-12) == (quotient:  -2, modulus:  -2))
        XCTAssertTrue(( 23).divMod(-12) == (quotient:  -2, modulus:  -1))
        XCTAssertTrue(( 24).divMod(-12) == (quotient:  -2, modulus:   0))
        XCTAssertTrue(( 25).divMod(-12) == (quotient:  -3, modulus: -11))
    }

    func testQuotRem() {
        XCTAssertTrue((-25).quotRem( 12) == (quotient:  -2, remainder:  -1))
        XCTAssertTrue((-24).quotRem( 12) == (quotient:  -2, remainder:   0))
        XCTAssertTrue((-23).quotRem( 12) == (quotient:  -1, remainder: -11))
        XCTAssertTrue((-22).quotRem( 12) == (quotient:  -1, remainder: -10))
        XCTAssertTrue((-21).quotRem( 12) == (quotient:  -1, remainder:  -9))
        XCTAssertTrue((-20).quotRem( 12) == (quotient:  -1, remainder:  -8))
        XCTAssertTrue((-19).quotRem( 12) == (quotient:  -1, remainder:  -7))
        XCTAssertTrue((-18).quotRem( 12) == (quotient:  -1, remainder:  -6))
        XCTAssertTrue((-17).quotRem( 12) == (quotient:  -1, remainder:  -5))
        XCTAssertTrue((-16).quotRem( 12) == (quotient:  -1, remainder:  -4))
        XCTAssertTrue((-15).quotRem( 12) == (quotient:  -1, remainder:  -3))
        XCTAssertTrue((-14).quotRem( 12) == (quotient:  -1, remainder:  -2))
        XCTAssertTrue((-13).quotRem( 12) == (quotient:  -1, remainder:  -1))
        XCTAssertTrue((-12).quotRem( 12) == (quotient:  -1, remainder:   0))
        XCTAssertTrue((-11).quotRem( 12) == (quotient:   0, remainder: -11))
        XCTAssertTrue((-10).quotRem( 12) == (quotient:   0, remainder: -10))
        XCTAssertTrue(( -9).quotRem( 12) == (quotient:   0, remainder:  -9))
        XCTAssertTrue(( -8).quotRem( 12) == (quotient:   0, remainder:  -8))
        XCTAssertTrue(( -7).quotRem( 12) == (quotient:   0, remainder:  -7))
        XCTAssertTrue(( -6).quotRem( 12) == (quotient:   0, remainder:  -6))
        XCTAssertTrue(( -5).quotRem( 12) == (quotient:   0, remainder:  -5))
        XCTAssertTrue(( -4).quotRem( 12) == (quotient:   0, remainder:  -4))
        XCTAssertTrue(( -3).quotRem( 12) == (quotient:   0, remainder:  -3))
        XCTAssertTrue(( -2).quotRem( 12) == (quotient:   0, remainder:  -2))
        XCTAssertTrue(( -1).quotRem( 12) == (quotient:   0, remainder:  -1))
        XCTAssertTrue((  0).quotRem( 12) == (quotient:   0, remainder:   0))
        XCTAssertTrue((  1).quotRem( 12) == (quotient:   0, remainder:   1))
        XCTAssertTrue((  2).quotRem( 12) == (quotient:   0, remainder:   2))
        XCTAssertTrue((  3).quotRem( 12) == (quotient:   0, remainder:   3))
        XCTAssertTrue((  4).quotRem( 12) == (quotient:   0, remainder:   4))
        XCTAssertTrue((  5).quotRem( 12) == (quotient:   0, remainder:   5))
        XCTAssertTrue((  6).quotRem( 12) == (quotient:   0, remainder:   6))
        XCTAssertTrue((  7).quotRem( 12) == (quotient:   0, remainder:   7))
        XCTAssertTrue((  8).quotRem( 12) == (quotient:   0, remainder:   8))
        XCTAssertTrue((  9).quotRem( 12) == (quotient:   0, remainder:   9))
        XCTAssertTrue(( 10).quotRem( 12) == (quotient:   0, remainder:  10))
        XCTAssertTrue(( 11).quotRem( 12) == (quotient:   0, remainder:  11))
        XCTAssertTrue(( 12).quotRem( 12) == (quotient:   1, remainder:   0))
        XCTAssertTrue(( 13).quotRem( 12) == (quotient:   1, remainder:   1))
        XCTAssertTrue(( 14).quotRem( 12) == (quotient:   1, remainder:   2))
        XCTAssertTrue(( 15).quotRem( 12) == (quotient:   1, remainder:   3))
        XCTAssertTrue(( 16).quotRem( 12) == (quotient:   1, remainder:   4))
        XCTAssertTrue(( 17).quotRem( 12) == (quotient:   1, remainder:   5))
        XCTAssertTrue(( 18).quotRem( 12) == (quotient:   1, remainder:   6))
        XCTAssertTrue(( 19).quotRem( 12) == (quotient:   1, remainder:   7))
        XCTAssertTrue(( 20).quotRem( 12) == (quotient:   1, remainder:   8))
        XCTAssertTrue(( 21).quotRem( 12) == (quotient:   1, remainder:   9))
        XCTAssertTrue(( 22).quotRem( 12) == (quotient:   1, remainder:  10))
        XCTAssertTrue(( 23).quotRem( 12) == (quotient:   1, remainder:  11))
        XCTAssertTrue(( 24).quotRem( 12) == (quotient:   2, remainder:   0))
        XCTAssertTrue(( 25).quotRem( 12) == (quotient:   2, remainder:   1))

        XCTAssertTrue((-25).quotRem(-12) == (quotient:   2, remainder:  -1))
        XCTAssertTrue((-24).quotRem(-12) == (quotient:   2, remainder:   0))
        XCTAssertTrue((-23).quotRem(-12) == (quotient:   1, remainder: -11))
        XCTAssertTrue((-22).quotRem(-12) == (quotient:   1, remainder: -10))
        XCTAssertTrue((-21).quotRem(-12) == (quotient:   1, remainder:  -9))
        XCTAssertTrue((-20).quotRem(-12) == (quotient:   1, remainder:  -8))
        XCTAssertTrue((-19).quotRem(-12) == (quotient:   1, remainder:  -7))
        XCTAssertTrue((-18).quotRem(-12) == (quotient:   1, remainder:  -6))
        XCTAssertTrue((-17).quotRem(-12) == (quotient:   1, remainder:  -5))
        XCTAssertTrue((-16).quotRem(-12) == (quotient:   1, remainder:  -4))
        XCTAssertTrue((-15).quotRem(-12) == (quotient:   1, remainder:  -3))
        XCTAssertTrue((-14).quotRem(-12) == (quotient:   1, remainder:  -2))
        XCTAssertTrue((-13).quotRem(-12) == (quotient:   1, remainder:  -1))
        XCTAssertTrue((-12).quotRem(-12) == (quotient:   1, remainder:   0))
        XCTAssertTrue((-11).quotRem(-12) == (quotient:   0, remainder: -11))
        XCTAssertTrue((-10).quotRem(-12) == (quotient:   0, remainder: -10))
        XCTAssertTrue(( -9).quotRem(-12) == (quotient:   0, remainder:  -9))
        XCTAssertTrue(( -8).quotRem(-12) == (quotient:   0, remainder:  -8))
        XCTAssertTrue(( -7).quotRem(-12) == (quotient:   0, remainder:  -7))
        XCTAssertTrue(( -6).quotRem(-12) == (quotient:   0, remainder:  -6))
        XCTAssertTrue(( -5).quotRem(-12) == (quotient:   0, remainder:  -5))
        XCTAssertTrue(( -4).quotRem(-12) == (quotient:   0, remainder:  -4))
        XCTAssertTrue(( -3).quotRem(-12) == (quotient:   0, remainder:  -3))
        XCTAssertTrue(( -2).quotRem(-12) == (quotient:   0, remainder:  -2))
        XCTAssertTrue(( -1).quotRem(-12) == (quotient:   0, remainder:  -1))
        XCTAssertTrue((  0).quotRem(-12) == (quotient:   0, remainder:   0))
        XCTAssertTrue((  1).quotRem(-12) == (quotient:   0, remainder:   1))
        XCTAssertTrue((  2).quotRem(-12) == (quotient:   0, remainder:   2))
        XCTAssertTrue((  3).quotRem(-12) == (quotient:   0, remainder:   3))
        XCTAssertTrue((  4).quotRem(-12) == (quotient:   0, remainder:   4))
        XCTAssertTrue((  5).quotRem(-12) == (quotient:   0, remainder:   5))
        XCTAssertTrue((  6).quotRem(-12) == (quotient:   0, remainder:   6))
        XCTAssertTrue((  7).quotRem(-12) == (quotient:   0, remainder:   7))
        XCTAssertTrue((  8).quotRem(-12) == (quotient:   0, remainder:   8))
        XCTAssertTrue((  9).quotRem(-12) == (quotient:   0, remainder:   9))
        XCTAssertTrue(( 10).quotRem(-12) == (quotient:   0, remainder:  10))
        XCTAssertTrue(( 11).quotRem(-12) == (quotient:   0, remainder:  11))
        XCTAssertTrue(( 12).quotRem(-12) == (quotient:  -1, remainder:   0))
        XCTAssertTrue(( 13).quotRem(-12) == (quotient:  -1, remainder:   1))
        XCTAssertTrue(( 14).quotRem(-12) == (quotient:  -1, remainder:   2))
        XCTAssertTrue(( 15).quotRem(-12) == (quotient:  -1, remainder:   3))
        XCTAssertTrue(( 16).quotRem(-12) == (quotient:  -1, remainder:   4))
        XCTAssertTrue(( 17).quotRem(-12) == (quotient:  -1, remainder:   5))
        XCTAssertTrue(( 18).quotRem(-12) == (quotient:  -1, remainder:   6))
        XCTAssertTrue(( 19).quotRem(-12) == (quotient:  -1, remainder:   7))
        XCTAssertTrue(( 20).quotRem(-12) == (quotient:  -1, remainder:   8))
        XCTAssertTrue(( 21).quotRem(-12) == (quotient:  -1, remainder:   9))
        XCTAssertTrue(( 22).quotRem(-12) == (quotient:  -1, remainder:  10))
        XCTAssertTrue(( 23).quotRem(-12) == (quotient:  -1, remainder:  11))
        XCTAssertTrue(( 24).quotRem(-12) == (quotient:  -2, remainder:   0))
        XCTAssertTrue(( 25).quotRem(-12) == (quotient:  -2, remainder:   1))
    }
}
