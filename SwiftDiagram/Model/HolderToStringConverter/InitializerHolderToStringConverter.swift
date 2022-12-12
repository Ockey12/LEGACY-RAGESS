//
//  InitializerHolderToStringConverter.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/13.
//

import Foundation

struct InitializerHolderToStringConverter {
    func convertToString(initializerHolders: [InitializerHolder]) -> [String] {
        var stringInitializerArray = [String]()
        
        for initializer in initializerHolders {
            var stringInit = ""
            if initializer.isConvenience {
                stringInit += "convenience "
            }
            stringInit += "init"
            if initializer.isFailable {
                stringInit += "?"
            }
            stringInit += "("
            for (index, param) in initializer.parameters.enumerated() {
                stringInit += param.name! + ": "
                switch param.kind {
                case .literal:
                    stringInit += param.literalType!
                case .array:
                    stringInit += "[" + param.arrayType! + "]"
                case .dictionary:
                    stringInit += "[" + param.dictionaryKeyType! + ": " + param.dictionaryValueType! + "]"
                case .tuple:
                    stringInit += "("
                    for (index, type) in param.tupleTypes.enumerated() {
                        stringInit += type
                        // 配列の最後の要素以外のとき、要素を区切る ", " を追加する
                        if index != param.tupleTypes.count - 1 {
                            stringInit += ", "
                        }
                    } // for (index, type) in param.tupleTypes.enumerated()
                    stringInit += ")"
                case .opaqueResultType:
                    break
                } // switch param.kind
                if param.isOptionalType {
                    stringInit += "?"
                }
                if let initialValue = param.initialValue {
                    stringInit += " = " + initialValue
                }
                
                // 配列の最後の要素以外のとき、要素を区切る ", " を追加する
                if index != initializer.parameters.count - 1 {
                    stringInit += ", "
                }
            } // for param in initializer.parameters
            stringInit += ")"
            stringInitializerArray.append(stringInit)
        } // for initializer in initializerHolders
        
        return stringInitializerArray
    } // func convertToString(initializerHolders: [InitializerHolder]) -> [String]
}
