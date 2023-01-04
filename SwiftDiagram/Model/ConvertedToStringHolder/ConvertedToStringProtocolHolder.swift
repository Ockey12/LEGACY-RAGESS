//
//  ConvertedToStringProtocolHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/13.
//

import Foundation

struct ConvertedToStringProtocolHolder {
    var changeDate = ""
    
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

extension ConvertedToStringProtocolHolder: Hashable {
    static func == (lhs: ConvertedToStringProtocolHolder, rhs: ConvertedToStringProtocolHolder) -> Bool {
        return (lhs.name == rhs.name) && (lhs.changeDate == rhs.changeDate)
    }

    func hash(into hasher: inout Hasher) {
        name.hash(into: &hasher)
        changeDate.hash(into: &hasher)
    }
}
