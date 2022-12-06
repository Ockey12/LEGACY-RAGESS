//
//  ProtocolHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

struct ProtocolHolder: HaveNameAndAccessLevelHolder {
    var ID: Int?
    var name: String = ""
    var accessLevel: AccessLevel = .internal
}
