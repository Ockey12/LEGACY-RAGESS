//
//  ConvertedToStringClassHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/12.
//

import Foundation

struct ConvertedToStringClassHolder {
    var changeDate = ""
    
    var name = ""
    var accessLevelIcon = ""
    var generics = [String]()
    var superClassName: String?
    var conformingProtocolNames = [String]()
    var typealiases = [String]()
    var initializers = [String]()
    var variables = [String]()
    var functions = [String]()
    
    var nestingConvertedToStringStructHolders = [ConvertedToStringStructHolder]()
    var nestingConvertedToStringClassHolders = [ConvertedToStringClassHolder]()
    var nestingConvertedToStringEnumHolders = [ConvertedToStringEnumHolder]()
    
    var extensions = [ConvertedToStringExtensionHolder]()
}

extension ConvertedToStringClassHolder: Hashable {
    static func == (lhs: ConvertedToStringClassHolder, rhs: ConvertedToStringClassHolder) -> Bool {
        return (lhs.name == rhs.name) && (lhs.changeDate == rhs.changeDate)
    }

    var hashValue: Int {
        return self.name.hashValue
    }

    func hash(into hasher: inout Hasher) {
        name.hash(into: &hasher)
        changeDate.hash(into: &hasher)
    }
}
