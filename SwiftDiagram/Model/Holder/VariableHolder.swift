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
    var kind: VariableKind = .literal
    
    var literalType: String?
    var arrayType: String?
    var dictionaryKeyType: String?
    var dictionaryValueType: String?
    var tupleTypes: [String]?
    
    // これに影響を及ぼす型の名前
    var typeThatAffectsThis = [String]()
}
