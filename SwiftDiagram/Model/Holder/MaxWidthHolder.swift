//
//  MaxWidthHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/28.
//

import Foundation

class MaxWidthHolder: ObservableObject {
    @Published var maxWidthDict = [String: Value]()
    
    var array: [NameAndWidth] {
        var newArray = [NameAndWidth]()
        for element in maxWidthDict {
            let nameAndWidth = NameAndWidth(name: element.key, width: element.value.maxWidth)
            newArray.append(nameAndWidth)
        }
        return newArray
    }
    
    struct Value {
        var maxWidth: Double
        var extensionWidth = [Int: Double]()
    }
    
    struct NameAndWidth: Hashable {
        var name: String
        var width: Double
    }
}
