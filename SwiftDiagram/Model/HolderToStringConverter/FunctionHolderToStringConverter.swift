//
//  FunctionHolderToStringConverter.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/13.
//

import Foundation

struct FunctionHolderToStringConverter {
    func convertToString(functionHolders: [FunctionHolder]) -> [String] {
        var stringFunctionArray = [String]()
        
        for function in functionHolders {
            let icon = function.accessLevel.icon
            var stringFunc = icon + " "
//            if icon != AccessLevel.internal.icon {
//                stringFunc += " "
//            }
            
            if function.isStatic {
                stringFunc += "static "
            }
            if function.isOverride {
                stringFunc += "override "
            }
            if function.isMutating {
                stringFunc += "mutating "
            }
            
            stringFunc += function.name
            
            if 0 < function.generics.count {
                stringFunc += "<"
                for (index, generic) in function.generics.enumerated() {
                    stringFunc += generic.parameterType!
                    if let protocolName = generic.conformedProtocolName {
                        stringFunc += ": " + protocolName
                    } else if let className = generic.inheritedClassName {
                        stringFunc += ": " + className
                    }
                    // 配列の最後の要素以外のとき、要素を区切る ", " を追加する
                    if index != function.generics.count - 1 {
                        stringFunc += ", "
                    }
                } // for (index, generic) in function.generics.enumerated()
                stringFunc += ">"
            } // if 0 < function.generics.count
            stringFunc += "("
            
            for (index, param) in function.parameters.enumerated() {
                if let externalName = param.externalName {
                    stringFunc += externalName + " "
                }
                stringFunc += param.internalName!
                stringFunc += ": "
                if param.haveInoutKeyword {
                    stringFunc += "inout "
                }
                
                switch param.variableKind {
                case .literal:
                    stringFunc += param.literalType!
                case .array:
                    stringFunc += "[" + param.arrayType! + "]"
                case .dictionary:
                    stringFunc += "[" + param.dictionaryKeyType! + ": " + param.dictionaryValueType! + "]"
                case .tuple:
                    stringFunc += "("
                    for (index, type) in param.tupleTypes.enumerated() {
                        stringFunc += type
                        // 配列の最後の要素以外のとき、要素を区切る ", " を追加する
                        if index != param.tupleTypes.count - 1 {
                            stringFunc += ", "
                        }
                    }
                    stringFunc += ")"
                case .opaqueResultType:
                    break
                } // switch param.kind
                
                if param.isOptionalType {
                    stringFunc += "?"
                }
                if param.isVariadic {
                    stringFunc += "..."
                }
                if let initialValue = param.initialValue {
                    stringFunc += " = " + initialValue
                }
                
                // 配列の最後の要素以外のとき、要素を区切る ", " を追加する
                if index != function.parameters.count - 1 {
                    stringFunc += ", "
                }
            } // for param in function.parameters
            stringFunc += ")"
            
            if let returnValue = function.returnValue {
                stringFunc += " -> "
                switch returnValue.variableKind {
                case .literal:
                    stringFunc += returnValue.literalType!
                case .array:
                    stringFunc += "[" + returnValue.arrayType! + "]"
                case .dictionary:
                    stringFunc += "[" + returnValue.dictionaryKeyType! + ": " + returnValue.dictionaryValueType! + "]"
                case .tuple:
                    stringFunc += "("
                    for (index, type) in returnValue.tupleTypes.enumerated() {
                        stringFunc += type
                        // 配列の最後の要素以外のとき、要素を区切る ", " を追加する
                        if index != returnValue.tupleTypes.count - 1 {
                            stringFunc += ", "
                        }
                    }
                    stringFunc += ")"
                case .opaqueResultType:
                    break
                } // switch returnValue.kind
                
                if returnValue.isOptional {
                    stringFunc += "?"
                }
                if let protocolName = returnValue.conformedProtocolByOpaqueResultTypeOfReturnValue {
                    stringFunc += " some " + protocolName
                }
            } // if let returnValue = function.returnValue
            stringFunctionArray.append(stringFunc)
        } // for function in functionHolders
        
        return stringFunctionArray
    } // func convertToString(functionHolders: [FunctionHolder]) -> [String]
}
