//
//  ConvertedToStringExtensionHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/12.
//

import Foundation

struct ConvertedToStringExtensionHolder {
    var conformingProtocolNames = [String]()
    var typealiases = [String]()
    var initializers = [String]()
    var variables = [String]()
    var functions = [String]()
    
    var nestingConvertedToStringStructHolders = [ConvertedToStringStructHolder]()
    var nestingConvertedToStringClassHolders = [ConvertedToStringClassHolder]()
    var nestingConvertedToStringEnumHolders = [ConvertedToStringEnumHolder]()
}
