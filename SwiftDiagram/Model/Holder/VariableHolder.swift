//
//  VariableHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

struct VariableHolder: HaveNameAndAccessLevelHolder {
    var ID: Int?
    var name: String = ""
    var accessLevel: AccessLevel = .internal
}
