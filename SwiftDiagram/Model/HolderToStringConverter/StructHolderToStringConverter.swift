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
        for generic in structHolder.generics {
            var stringGeneric = generic.parameterType!
            if let protocolName = generic.conformedProtocolName {
                stringGeneric += ": " + protocolName
            } else if let className = generic.inheritedClassName {
                stringGeneric += ": " + className
            }
            convertedHolder.generics.append(stringGeneric)
        } // for generic in structHolder.generics
        
        // protocolをString型に変換する
        for protocolName in structHolder.conformingProtocolNames {
            convertedHolder.conformingProtocolNames.append(protocolName)
        }
        
        // typealiasをString型に変換する
        for alias in structHolder.typealiases {
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
            }
            convertedHolder.typealiases.append(stringAlias)
        } // for alias in structHolder.typealiases
        
        // initializerをString型に変換する
        for initializer in structHolder.initializers {
            var stringInit = ""
            if initializer.isConvenience {
                stringInit += "convenience "
            }
            stringInit += "init"
            if initializer.isFailable {
                stringInit += "?"
            }
            stringInit += "("
            for param in initializer.parameters {
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
                } // switch param.kind
                if param.isOptionalType {
                    stringInit += "?"
                }
                if let initialValue = param.initialValue {
                    stringInit += " = " + initialValue
                }
            } // for param in initializer.parameters
            stringInit += ")"
        } // for initializer in structHolder.initializers
        
        // variableをString型に変換する
        for variable in structHolder.variables {
            var stringVar = variable.accessLevel.icon + " "
            if let attribute = variable.customAttribute {
                stringVar += attribute
            }
            if variable.isStatic {
                stringVar += "static "
            }
            if variable.isLazy {
                stringVar += "lazy "
            }
            if variable.isConstant {
                stringVar += "let "
            } else {
                stringVar += "var "
            }
            stringVar += variable.name
            stringVar += ": "
            
            switch variable.kind {
            case .literal:
                stringVar += variable.literalType!
            case .array:
                stringVar += "[" + variable.arrayType! + "]"
            case .dictionary:
                stringVar += "[" + variable.dictionaryKeyType! + ": " + variable.dictionaryValueType! + "]"
            case .tuple:
                stringVar += "("
                for (index, type) in variable.tupleTypes.enumerated() {
                    stringVar += type
                    if index != variable.tupleTypes.count - 1 {
                        stringVar += ", "
                    }
                } // for (index, type) in variable.tupleTypes.enumerated()
                stringVar += ")"
            } // switch variable.kind
            
            if variable.isOptionalType {
                stringVar += "?"
            }
            
            if let protocolName = variable.conformedProtocolByOpaqueResultType {
                stringVar += "some " + protocolName
            }
            
            if variable.haveWillSet || variable.haveDidSet || variable.haveGetter || variable.haveSetter  {
                stringVar += " { "
                if variable.haveWillSet {
                    stringVar += "willSet "
                }
                if variable.haveDidSet {
                    stringVar += "didSet "
                }
                if variable.haveGetter {
                    stringVar += "get "
                }
                if variable.haveSetter {
                    stringVar += "set "
                }
                stringVar += "}"
            } // if variable.haveWillSet || variable.haveDidSet || variable.haveGetter || variable.haveSetter
            convertedHolder.variables.append(stringVar)
        } // for variable in structHolder.variables
        
        // functionをString型に変換する
        for function in structHolder.functions {
            var stringFunc = function.accessLevel.icon + " "
            
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
            
            for param in function.parameters {
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
        
        return convertedHolder
    } // func convertToString(structHolder: StructHolder) -> ConvertedToStringStructHolder
}
