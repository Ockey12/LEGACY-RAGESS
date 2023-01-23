//
//  VariableHolderToStringConverter.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/13.
//

import Foundation

struct VariableHolderToStringConverter {
    func convertToString(variableHolders: [VariableHolder]) -> [String] {
        var stringVariableArray = [String]()
        
        for variable in variableHolders {
            let icon = variable.accessLevel.icon
            var stringVar = icon + " "
//            if icon != AccessLevel.internal.icon {
//                stringVar += " "
//            }
            
            if let attribute = variable.customAttribute {
                stringVar += attribute + " "
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
            
            switch variable.variableKind {
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
            case .opaqueResultType:
                stringVar += "some " + variable.conformedProtocolByOpaqueResultType!
            } // switch variable.kind
            
            if variable.isOptionalType {
                stringVar += "?"
            }
            
            if let initialValue = variable.initialValue {
                stringVar += " = " + initialValue
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
            stringVariableArray.append(stringVar)
        } // for variable in variableHolders
        
        return stringVariableArray
    } // func convertToString(variableHolders: [VariableHolder]) -> [String]
}
