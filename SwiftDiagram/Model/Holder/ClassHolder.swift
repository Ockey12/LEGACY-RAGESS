//
//  ClassHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

struct ClassHolder: Nameable, AccessControllable, TypeHolder, Nestable, Extensionable {
    var name: String = ""
    var accessLevel: AccessLevel = .internal
    
    var generics = [GenericHolder]()
    
    var superClassName: String?
    var conformingProtocolNames = [String]()
    
    var typealiases = [TypealiasHolder]()
    
    var initializers = [InitializerHolder]()
    
    var variables = [VariableHolder]()
    
    var functions = [FunctionHolder]()
    
    var nestingStructs = [StructHolder]()
    var nestingClasses = [ClassHolder]()
    var nestingEnums = [EnumHolder]()
    
    var extensions = [ExtensionHolder]()
}
