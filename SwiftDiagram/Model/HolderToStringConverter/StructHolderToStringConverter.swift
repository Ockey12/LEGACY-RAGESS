//
//  StructHolderToStringConverter.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/12.
//

import Foundation

struct StructHolderToStringConverter {
    func convertToString(structHolder: StructHolder) -> ConvertedToStringStructHolder {
        var convertedHolder = ConvertedToStringStructHolder()
        
        convertedHolder.name = structHolder.name
        convertedHolder.accessLevelIcon = structHolder.accessLevel.icon
        
        // genericをString型に変換する
        let genericConverter = GenericHolderToStringConverter()
        let stringGenerics = genericConverter.convertToString(genericHolders: structHolder.generics)
        convertedHolder.generics = stringGenerics
        
        // protocolをString型に変換する
        for protocolName in structHolder.conformingProtocolNames {
            convertedHolder.conformingProtocolNames.append(protocolName)
        }
        
        // typealiasをString型に変換する
        let typealiasConverter = TypealiasHolderToStringConverter()
        let stringTypealiases = typealiasConverter.convertToString(typealiasHolders: structHolder.typealiases)
        convertedHolder.typealiases = stringTypealiases
        
        // initializerをString型に変換する
        let initializerConverter = InitializerHolderToStringConverter()
        let stringInitializers = initializerConverter.convertToString(initializerHolders: structHolder.initializers)
        convertedHolder.initializers = stringInitializers
        
        // variableをString型に変換する
        let variableConverter = VariableHolderToStringConverter()
        let stringVariables = variableConverter.convertToString(variableHolders: structHolder.variables)
        convertedHolder.variables = stringVariables
        
        // functionをString型に変換する
        for function in structHolder.functions {
            let icon = function.accessLevel.icon
            var stringFunc = icon
            if icon != AccessLevel.internal.icon {
                stringFunc += " "
            }
//            var stringFunc = function.accessLevel.icon + " "
            
            if function.isStatic {
                stringFunc += "static "
            }
            if function.isOverride {
                stringFunc += "override "
            }
            if function.isMutating {
                stringFunc += "mutating "
            }
            
            stringFunc += function.name + " "
            
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
                
                switch param.kind {
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
                    } // for (index, type) in param.tupleTypes.enumerated()
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
                switch returnValue.kind {
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
                    } // for (index, type) in returnValue.tupleTypes.enumerated()
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
            convertedHolder.functions.append(stringFunc)
        } // for function in structHolder.functions
        
        // ネストしているStructHolderをConvertedToStringStructHolder型に変換する
        if 0 < structHolder.nestingStructs.count {
            let converter = StructHolderToStringConverter()
            for nestedStruct in structHolder.nestingStructs {
                let convertedContent = converter.convertToString(structHolder: nestedStruct)
                convertedHolder.nestingConvertedToStringStructHolders.append(convertedContent)
            }
        } // if 0 < structHolder.nestingStructs.count
        
        /**
         ネストしているClassHolderをString型に変換する
         */
        
        /**
         ネストしているEnumHolderをString型に変換する
         */
        
        /**
         ExtensionHolderをConvertedToStringExtensionHolder型に変換する
         */
        return convertedHolder
    } // func convertToString(structHolder: StructHolder) -> ConvertedToStringStructHolder
}
