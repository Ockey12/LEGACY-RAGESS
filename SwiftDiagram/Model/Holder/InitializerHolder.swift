//
//  InitializerHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/06.
//

import Foundation

struct InitializerHolder: Holder {
    var isConvenience = false
    var isFailable = false
    var parameters = [ParameterHolder]()
    
    struct ParameterHolder: Holder, Typeable {
        var name: String?
        var variableKind: VariableKind = .literal
        var literalType: String?
        var arrayType: String?
        var dictionaryKeyType: String?
        var dictionaryValueType: String?
        var tupleTypes = [String]()
        var isOptionalType = false
        var initialValue: String?
    }
}
