//
//  SampleCode.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/19.
//

import Foundation
import SwiftUI

protocol Protocol1 {}

protocol Protocol2 {}

//private struct Struct1: Protocol1, Protocol2 {
//    private var text: String
//    @State fileprivate var array: [Double]?
//    static var staticVariable: [String: Int] = [:]
//    lazy var lazyVariable: (Int, Double, Float) = (1111111111, 2222222222, 3333333333)
//    let constant: Struct2
//    var haveWillSetDidSet: String {
//        willSet {
//
//        }
//        didSet {
//
//        }
//    }
//    var haveGetterSetter: Int {
//        get {
//            return 4444444444
//        }
//        set {
//
//        }
//    }
//}
//
//private struct Struct2: Protocol1 {
//
//}

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
//
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

//enum StringEnum: String, Protocol1, Protocol2 {
//    case north = "NORTH"
//
//    private func DefaultFunction(out in: Int, num: inout Int, nums: Int... ,text: String = "sampleText", clauser: (Int, String) -> String) {
//        print("\(num)")
//    }
//}

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

//enum Color {
//    case rgb(Int, Float, Double)
//    case cmyk(Float, Float ,Float, Float)
//}

//struct SomeStruct {
//    var variableVariableVariable: String = "texttexttexttext"
//    var optionalVariable: Int?
//
//    init?(parameter1: String, parameter2: Int) {
//        self.variableVariableVariable = parameter1
//    }
//}
//
//class SomeClass {
//    var variableVariableVariable: String
//
//    init(parameter1: String) {
//        self.variableVariableVariable = parameter1
//    }
//
//    convenience init(parameter2: String) {
//        self.init(parameter1: parameter2 + parameter2)
//    }
//}

//struct SomeStruct {
//    func SomeFunc(arrayParam: [Double], dictionaryParam: [String: Int], toupleParam: (Character, Float)) {}
//    func arrayFunc(arrayParam: [Double]?, intParam: Int) {}
//    var arrayParam: [Double]?
//    var doubleOptionalParam: Double?
//    init(arrayParam: [Double]?, intParam: Int) {
//        self.arrayParam = arrayParam
//    }
//
//    func dicFunc(dicParam: [String: Int]?, intParame: Int) -> [Character: Float] {
//        return ["#": 0.3333]
//    }
//    var dicVariable: [Character: Double]?
//    init(dicInitParam: [String: Float]?, doubleParam: Double) {}
//
//    private mutating func toupleFunc(toupleParam: (String, Int, Double)? , floatParam: Float) -> String {
//        return "(1111111, 2222222, 3333333)"
//    }
//    fileprivate var toupleVariable: (String, Int, Double)? = (stringName: "STRINGSTRINGSTRING", intName: 2222222222, doubleName: 3333333333)
//    public var initializedToupleVariable = (stringName: "TEXTTEXTTEXTTEXT", intName: 1111111111)
//    init(toupleInitParam: (String, Int, Double)?, floatParam: Float) {}
//}

//protocol SuperSuperProtocol {}
//protocol SuperProtocol {}
//private protocol SomeProtocol {
//    associatedtype ASSOCIATEDTYPE: Equatable
//    func somefunc(num: Int) -> [String]?
//    var variable: String { get }
//}

//struct SomeStruct {
//    func sorted<T: Collection>(_ argument: T) -> [T.Element] where T.Element: Comparable {
//        return argument.sorted()
//    }
//    var structVariable: Int {
//        get {
//            return 1111111111
//        }
//        set {
//
//        }
//    }
//}
//struct SomeStruct {
//    func somefunc(num: Int) -> [String] {
//        return ["9999999999"]
//    }
//}

//open class SuperClass {
//    func methodOfSuperClass() {}
//}
//fileprivate class ChildClass: SuperClass {
//    override func methodOfSuperClass() {
//        super.methodOfSuperClass()
//    }
//}
//protocol Protocol1 {}
//protocol Protocol2 {}
//struct SomeStruct {
//    var name: String
//    var age: Int
//}
//struct GenericsStruct<GGGGGGGGGG: Protocol1, HHHHHHHHHH: Protocol2> {
//
//}
struct SomeStruct {
    var name: String
    var age: Int
}
extension SomeStruct: Protocol1, Protocol2 {
    func addedFunction(external internal: [String: Int]?, double: Double) -> [Float] {
        return [11111]
    }
    var addedProperty: String {
        return "TextTextText"
    }
    init (age: [Int]) {
        self.name = "unknown"
        self.age = age[0]
    }
}
//protocol SomeProtocol: Hashable {}
//struct SomeClass: SomeProtocol {
//    static var staticVariable = "StaticStaticStatic"
//    static func == (lhs: SomeClass, rhs: SomeClass) -> Bool {
//        true
//    }
//    var x: Int
//    var y: Int
//}
//struct SomeStruct {
//    var someVariable: some SomeProtocol {
//        return SomeClass(x: 1111111111)
//    }
//    func someFunction() -> some SomeProtocol {
//        return SomeClass(x: 2222222222)
//    }
//    func arrayFunction() -> [some SomeProtocol] {
//        return [SomeClass(x: 111111, y: 222222)]
//    }
//    func dictionaryFunction() -> [some SomeProtocol: some SomeProtocol] {
//        return [SomeClass(x: 333333, y: 444444): SomeClass(x: 555555, y: 666666)]
//    }
//    func tupleFunction() -> (some SomeProtocol, some SomeProtocol, some SomeProtocol) {
//        return (SomeClass(x: 777777, y: 888888), SomeClass(x: 999999, y: 000000), SomeClass(x: 111111, y: 222222))
//    }
//}
//struct ViewStruct: View {
//    var body: some View {
//        Text("TextTextTextText")
//    }
//}
