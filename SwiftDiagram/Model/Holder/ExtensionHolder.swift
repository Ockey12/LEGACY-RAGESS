//
//  ExtensionHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

struct ExtensionHolder: Holder {
    var ID: Int?
    var extensionedTypeName: String?
    
    var conformingProtocolNames = [String]()
    
    var initializers = [InitializerHolder]()
    
    var variables = [VariableHolder]()
    
    var functions = [FunctionHolder]()
    
    var nestingStructs = [StructHolder]()
    var nestingClasses = [ClassHolder]()
    var nestingEnums = [EnumHolder]()
}
