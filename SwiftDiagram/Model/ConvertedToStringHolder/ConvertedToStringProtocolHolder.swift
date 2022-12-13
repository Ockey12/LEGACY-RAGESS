//
//  ConvertedToStringProtocolHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/13.
//

import Foundation

struct ConvertedToStringProtocolHolder {
    var name = ""
    var accessLevelIcon = ""
    var conformingProtocolNames = [String]()
    var associatedTypes = [String]()
    
    var typealiases = [String]()
    
    var initializers = [String]()
    
    var variables = [String]()
    
    var functions = [String]()
    
    var extensions = [ConvertedToStringExtensionHolder]()
}
