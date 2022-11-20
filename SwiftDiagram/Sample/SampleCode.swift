//
//  SampleCode.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/19.
//

import Foundation
import SwiftUI

protocol Prtocol1 {}

protocol Protocol2 {}

private struct SomeStruct: Prtocol1, Protocol2 {
    @State private var statePrivateVariable: Int
    public var publicSample: Int
    internal var internalSample: Int
    fileprivate var fileprivateSample: Int
}
