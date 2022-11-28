//
//  SampleCode.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/19.
//

import Foundation
//import SwiftUI

protocol Protocol1 {}

protocol Protocol2 {}

//private struct SomeStruct: Protocol1, Protocol2 {
//    @State private var statePrivateVariable: [String: Int]
//    var toupleVariable: (String, Int)
//    static let staticVariable = 1111111111
//    let dictionaryVariable = ["KeyKeyKey": "ValueValueValue"]
//    let toupleVariable = ("KeyKeyKey",2222222222)
//    lazy private var lazyVariable = 222222222
//    var willDidSetVariable = 3333333333 {
//        willSet {
//            print("willSet, willSet, willSet")
//        }
//        didSet {
//            print("didSet, didSet, didSet")
//        }
//    }
//    var computedProperty: Int {
//        get {
//            print(9999999999)
//            return 4444444444
//        }
//        set {
//            self.num = newValue
//        }
//    }
//    var num = 5555555555
    
//    func outsideNameFunction(outside inside: Int..., external internal: inout String) {}
//    func getClauserFunction(clause: ((String) -> Int) -> Void, toupletouple: (String, Int)) {}
    
//    static func staticFunction(num: Int = 6666666666) {}
//    func defaultValueFunction(text: String = "sampl eText") {}
//    private func DefaultFunction(out in: Int, num: inout Int, nums: Int... ,text: String = "sampleText", clauser: (Int, String) -> String) {
//        print("\(num)")
//    }
//    private func privateFunction(
//    func sampleFunction(num: Int) {
//        print("\(num)")
//    }
    
//    let add = { (x: Int, y: Int) -> Int in
//        return x + y
//    }
//}

//class ClassClassClass {}

//open class ParentClass: Protocol1 {
//    private func DefaultFunction(out in: Int, num: inout Int, nums: Int... ,text: String = "sampleText", clauser: (Int, String) -> String) {
//        print("\(num)")
//    }
//}
//
//private class ChildClass: ParentClass, Protocol2 {
//    var computedProperty: Int {
//        get {
//            print(9999999999)
//            return 4444444444
//        }
//        set {
//            self.num = newValue
//        }
//    }
//    var num = 5555555555
//}

//private enum Weekday:Protocol1 {
//    case sunday
//    case monday
//
//
//}

enum StringEnum: String, Protocol1, Protocol2 {
    case north = "NORTH"
    
    private func DefaultFunction(out in: Int, num: inout Int, nums: Int... ,text: String = "sampleText", clauser: (Int, String) -> String) {
        print("\(num)")
    }
}

//enum CharacterEnum: Character, Protocol1 {
//    case c = "C"
//}
//
//enum IntEnum: Int, Protocol1 {
//    case one = 1
//}
//
//enum DoubleEnum: Double, Protocol1 {
//    case one = 1
//}
//
//enum FloatEnum: Float {
//    case one = 1
//}

enum Color {
    case rgb(Int, Float, Double)
    case cmyk(Float, Float ,Float, Float)
}
