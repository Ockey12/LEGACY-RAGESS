//
//  StructHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

struct StructHolder: TypeHolder {
    var ID: Int?
    var name: String = ""
    var accessLevel: AccessLevel = .internal
    
    var conformingProtocolNames = [String]()
    
    var variables = [VariableHolder]()
    
    var functions = [FunctionHolder]()
    
    var nestingStructs = [StructHolder]()
    var nestingClasses = [ClassHolder]()
    var nestingEnums = [EnumHolder]()
    
    var nestSuperTypeName: String? = nil
}

