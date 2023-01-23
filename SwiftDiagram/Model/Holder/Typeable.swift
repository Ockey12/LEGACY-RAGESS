//
//  Typeable.swift
//  RUISS
//
//  Created by オナガ・ハルキ on 2023/01/24.
//

import Foundation

protocol Typeable {
    var variableKind: VariableKind { get set }
    
    var literalType: String? { get set }
    var arrayType: String? { get set }
    var dictionaryKeyType: String? { get set }
    var dictionaryValueType: String? { get set }
    var tupleTypes: [String] { get set }
}
