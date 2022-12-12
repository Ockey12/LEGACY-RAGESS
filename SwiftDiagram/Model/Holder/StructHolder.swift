//
//  StructHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

struct StructHolder: TypeHolder {
    var name: String = ""
    var accessLevel: AccessLevel = .internal
    
    var generics = [GenericHolder]()
    
    var conformingProtocolNames = [String]()
    
    var typealiases = [TypealiasHolder]()
    
    var initializers = [InitializerHolder]()
    
    var variables = [VariableHolder]()
    
    var functions = [FunctionHolder]()
    
    var nestingStructs = [StructHolder]()
    var nestingClasses = [ClassHolder]()
    var nestingEnums = [EnumHolder]()
    
    var extensions = [ExtensionHolder]()
    
    var nestSuperTypeName: String? = nil
}

