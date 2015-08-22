//: Playground - noun: a place where people can play

import Rational

let original = Rational(25, 21)!
let intermediate = Double(rational: original)
let result = Rational(intermediate)

Double(rational: original - result)





