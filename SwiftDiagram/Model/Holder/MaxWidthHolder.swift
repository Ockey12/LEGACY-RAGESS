//
//  MaxWidthHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/28.
//

import Foundation

class MaxWidthHolder: ObservableObject {
    @Published var maxWidthDict = [String: Double]()
    var array: [NameAndWidth] {
        var newArray = [NameAndWidth]()
        for element in maxWidthDict {
            let nameAndWidth = NameAndWidth(name: element.key, width: element.value)
            newArray.append(nameAndWidth)
        }
        return newArray
    }
    struct NameAndWidth: Hashable {
        var name: String
        var width: Double
    }
}
