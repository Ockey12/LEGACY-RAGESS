//
//  DirectoryHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/20.
//

import Foundation

struct DirectoryHolder {
    var url: URL? = nil
    
    var haveSwiftFileFlag = false
    
    var subDirectorys = [DirectoryHolder]()
    var convertedStructHolders = [ConvertedToStringStructHolder]()
    var convertedClassHolders = [ConvertedToStringClassHolder]()
    var convertedEnumHolders = [ConvertedToStringEnumHolder]()
    var convertedProtocolHolders = [ConvertedToStringProtocolHolder]()
}

extension DirectoryHolder: Hashable {
    
}
