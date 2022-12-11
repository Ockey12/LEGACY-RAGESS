//
//  EnumHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

struct EnumHolder: TypeHolder {
    var ID: Int?
    var name: String = ""
    var accessLevel: AccessLevel = .internal
    
    var generics = [GenericHolder]()
    
    var rawvalueType: String?
    
    var conformingProtocolNames = [String]()
    
    var typealiases = [TypealiasHolder]()
    
    var initializers = [InitializerHolder]()
    
    var cases = [CaseHolder]()
    
    var variables = [VariableHolder]()
    
    var functions = [FunctionHolder]()
    
    var nestingStructs = [StructHolder]()
    var nestingClasses = [ClassHolder]()
    var nestingEnums = [EnumHolder]()
    
    var extensions = [ExtensionHolder]()
    
    var nestSuperTypeName: String? = nil
    
    struct CaseHolder: Holder {
        var caseName: String = ""
        var rawvalue: String?
        var associatedValueTypes = [String]()
    }
}
