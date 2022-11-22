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

private struct SomeStruct: Protocol1, Protocol2 {
//    @State private var statePrivateVariable: [String: Int]
//    var toupleVariable: (String, Int)
    static let staticVariable = 1111111111
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
//            return 4444444444
//        }
//        set {
//            self.num = newValue
//        }
//    }
//    var num = 5555555555
    
    static func staticFunction() {}
    private func DefaultFunction(out in: Int, num: inout Int, nums: Int... ,text: String = "sampleText") {
        print("\(num)")
    }
//    private func privateFunction(
//    func sampleFunction(num: Int) {
//        print("\(num)")
//    }
}
