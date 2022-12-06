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
    
    var customAttribute: String?
    var isStatic = false
    var isLazy = false
    var isConstant = false
    
    var literalType: String?
    var arrayType: String?
    var dictionaryKeyType: String?
    var dictionaryValueType: String?
    var tupleTypes = [String]()
    
    var conformedProtocolByOpaqueResultType: String?
    
    var isOptionalType = false
    
    var initialValue: String?
    
    var haveWillSet = false
    var haveDidSet = false
    var haveGetter = false
    var haveSetter = false
    
    // これに影響を及ぼす型の名前
    var typeThatAffectsThis = [String]()
}
