//
//  TypealiasHolderToStringConverter.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/13.
//

import Foundation

struct TypealiasHolderToStringConverter {
    func convertToString(typealiasHolders: [TypealiasHolder]) -> [String] {
        var stringTypealiasArray = [String]()
        
        for alias in typealiasHolders {
            var stringAlias = alias.associatedTypeName! + " = "
            
            switch alias.variableKind {
            case .literal:
                stringAlias += alias.literalType!
            case .array:
                stringAlias += "[" + alias.arrayType! + "]"
            case .dictionary:
                stringAlias += "[" + alias.dictionaryKeyType! + ": " + alias.dictionaryValueType! + "]"
            case .tuple:
                stringAlias += "("
                for (index, type) in alias.tupleTypes.enumerated() {
                    stringAlias += type
                    // 配列の最後の要素以外のとき、要素を区切る ", " を追加する
                    if index != alias.tupleTypes.count - 1 {
                        stringAlias += ", "
                    }
                }
                stringAlias += ")"
            case .opaqueResultType:
                break
            }
            stringTypealiasArray.append(stringAlias)
        } // for alias in typealiasHolders
        
        return stringTypealiasArray
    } // func convertToString(typealiasHolders: [TypealiasHolder]) -> [String]
}
