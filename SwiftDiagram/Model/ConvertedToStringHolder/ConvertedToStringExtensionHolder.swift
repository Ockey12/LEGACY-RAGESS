//
//  ConvertedToStringExtensionHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/12.
//

import Foundation

struct ConvertedToStringExtensionHolder: ConvertedTypeHolder, ConvertedNestable {
    var conformingProtocolNames = [String]()
    var typealiases = [String]()
    var initializers = [String]()
    var variables = [String]()
    var functions = [String]()
    
    var nestingConvertedToStringStructHolders = [ConvertedToStringStructHolder]()
    var nestingConvertedToStringClassHolders = [ConvertedToStringClassHolder]()
    var nestingConvertedToStringEnumHolders = [ConvertedToStringEnumHolder]()
}

extension ConvertedToStringExtensionHolder: Hashable {
    static func == (lhs: ConvertedToStringExtensionHolder, rhs: ConvertedToStringExtensionHolder) -> Bool {
        return (lhs.conformingProtocolNames == rhs.conformingProtocolNames) &&
                (lhs.typealiases == rhs.typealiases) &&
                (lhs.initializers == rhs.initializers) &&
                (lhs.variables == rhs.variables) &&
                (lhs.functions == rhs.functions) &&
                (lhs.nestingConvertedToStringStructHolders == rhs.nestingConvertedToStringStructHolders) &&
                (lhs.nestingConvertedToStringClassHolders == rhs.nestingConvertedToStringClassHolders) &&
                (lhs.nestingConvertedToStringEnumHolders == rhs.nestingConvertedToStringEnumHolders)
//        return lhs.conformingProtocolNames == rhs.conformingProtocolNames
    }

    func hash(into hasher: inout Hasher) {
        conformingProtocolNames.hash(into: &hasher)
        typealiases.hash(into: &hasher)
        initializers.hash(into: &hasher)
        variables.hash(into: &hasher)
        functions.hash(into: &hasher)
        nestingConvertedToStringStructHolders.hash(into: &hasher)
        nestingConvertedToStringClassHolders.hash(into: &hasher)
        nestingConvertedToStringEnumHolders.hash(into: &hasher)
//        ObjectIdentifier(self).hash(into: &hasher)
    }
}
