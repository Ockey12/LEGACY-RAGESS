//
//  ProtocolHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

struct ProtocolHolder: HaveNameAndAccessLevelHolder {
    var name: String = ""
    var accessLevel: AccessLevel = .internal
    
    var conformingProtocolNames = [String]()
    
    var associatedTypes = [AssociatedType]()
    
    var typealiases = [TypealiasHolder]()
    
    var initializers = [InitializerHolder]()
    
    var variables = [VariableHolder]()
    
    var functions = [FunctionHolder]()
    
    var extensions = [ExtensionHolder]()
    
    struct AssociatedType {
        var name: String
        var protocolOrSuperClassName: String?
    }
}
