//
//  TypealiasHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/11.
//

import Foundation

struct TypealiasHolder {
    var associatedTypeName: String?
    var variableKind = VariableKind.literal
    
    var literalType: String?
    var arrayType: String?
    var dictionaryKeyType: String?
    var dictionaryValueType: String?
    var tupleTypes = [String]()
}
