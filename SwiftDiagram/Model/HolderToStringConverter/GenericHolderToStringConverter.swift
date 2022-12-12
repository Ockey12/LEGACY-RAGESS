//
//  GenericHolderToStringConverter.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/13.
//

import Foundation

struct GenericHolderToStringConverter {
    func convertToString(genericHolders: [GenericHolder]) -> [String] {
        var stringGenericsArray = [String]()
        for generic in genericHolders {
            var stringGeneric = generic.parameterType!
            if let protocolName = generic.conformedProtocolName {
                stringGeneric += ": " + protocolName
            } else if let className = generic.inheritedClassName {
                stringGeneric += ": " + className
            }
            stringGenericsArray.append(stringGeneric)
        }
        return stringGenericsArray
    }
}
