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
    @State private var statePrivateVariable: Int
    static let staticVariable = 100000000
}
