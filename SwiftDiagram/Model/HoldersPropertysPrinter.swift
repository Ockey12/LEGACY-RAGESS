//
//  HoldersPropertysPrinter.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/18.
//

import Foundation

struct HoldersPropertysPrinter {
    
    private func addStructToContent(structHolders: [StructHolder]) -> String {
        var content = ""
        for structHolder in structHolders {
            content += "-----Struct-----\n"
            content += "name: \(structHolder.name)\n"
            content += "accessLevel: \(structHolder.accessLevel)\n"
            
            content += addGenericsToContent(generics: structHolder.generics)
            
            if 0 < structHolder.conformingProtocolNames.count {
                for name in structHolder.conformingProtocolNames {
                    content += "conformingProtocolName: \(name)\n"
                }
            }
            content += addTypealiasToContent(typealiases: structHolder.typealiases)
            content += addInitializerToContent(initializerHolders: structHolder.initializers)
            content += addVariableToContent(variableHolders: structHolder.variables)
            content += addFunctionsToContent(functionHolders: structHolder.functions)
            
            content += addStructToContent(structHolders: structHolder.nestingStructs)
            content += addClassToContent(classHolders: structHolder.nestingClasses)
            content += addEnumToContent(enumHolders: structHolder.nestingEnums)
            
            content += addExtensionToContent(extensionHolders: structHolder.extensions)
            content += "\n"
        } // for structHolder
        return content
    } // func addStructToContent(structHolders: [StructHolder]) -> String
    
    private func addClassToContent(classHolders: [ClassHolder]) -> String {
        var content = ""
        for classHolder in classHolders {
            content += "-----Class-----\n"
            content += "name: \(classHolder.name)\n"
            content += "accessLevel: \(classHolder.accessLevel)\n"
            
            content += addGenericsToContent(generics: classHolder.generics)
            
            if let superClass = classHolder.superClassName {
                content += "superClass: \(superClass)\n"
            }
            
            if 0 < classHolder.conformingProtocolNames.count {
                for name in classHolder.conformingProtocolNames {
                    content += "conformingProtocolName: \(name)\n"
                }
            }
            content += addTypealiasToContent(typealiases: classHolder.typealiases)
            content += addInitializerToContent(initializerHolders: classHolder.initializers)
            content += addVariableToContent(variableHolders: classHolder.variables)
            content += addFunctionsToContent(functionHolders: classHolder.functions)
            
            content += addStructToContent(structHolders: classHolder.nestingStructs)
            content += addClassToContent(classHolders: classHolder.nestingClasses)
            content += addEnumToContent(enumHolders: classHolder.nestingEnums)
            
            content += addExtensionToContent(extensionHolders: classHolder.extensions)
            content += "\n"
        } // for classHolder
        return content
    } // func addClassToContent(classHolders: [ClassHolder]) -> String
    
    private func addEnumToContent(enumHolders: [EnumHolder]) -> String {
        var content = ""
        for enumHolder in enumHolders {
            content += "-----Enum-----\n"
            content += "name: \(enumHolder.name)\n"
            content += "accessLevel: \(enumHolder.accessLevel)\n"
            
            content += addGenericsToContent(generics: enumHolder.generics)
            
            if let rawvalueType = enumHolder.rawvalueType {
                content += "rawvalueType: \(rawvalueType)\n"
            }
            
            if 0 < enumHolder.conformingProtocolNames.count {
                for name in enumHolder.conformingProtocolNames {
                    content += "conformingProtocolName: \(name)\n"
                }
            }
            
            content += addTypealiasToContent(typealiases: enumHolder.typealiases)
            
            for aCase in enumHolder.cases {
                content += "--case--\n"
                content += "caseName: \(aCase.caseName)\n"
                if let rawValue = aCase.rawvalue {
                    content += "rawValue: \(rawValue)\n"
                }
                for associatedValueType in aCase.associatedValueTypes {
                    content += ("associatedValueType: \(associatedValueType)\n")
                }
            }
            content += addInitializerToContent(initializerHolders: enumHolder.initializers)
            content += addVariableToContent(variableHolders: enumHolder.variables)
            content += addFunctionsToContent(functionHolders: enumHolder.functions)
            
            content += addStructToContent(structHolders: enumHolder.nestingStructs)
            content += addClassToContent(classHolders: enumHolder.nestingClasses)
            content += addEnumToContent(enumHolders: enumHolder.nestingEnums)
            
            content += addExtensionToContent(extensionHolders: enumHolder.extensions)
            content += "\n"
        } // for enumHolder
        return content
    } // func addEnumToContent(enumHolders: [EnumHolder]) -> String
    
    private func addProtocolToContent(protocolHolders: [ProtocolHolder]) -> String {
        var content = ""
        for protocolHolder in protocolHolders {
            content += "-----Protocol-----\n"
            content += "name: \(protocolHolder.name)\n"
            content += "accessLevel: \(protocolHolder.accessLevel)\n"
            
            if 0 < protocolHolder.conformingProtocolNames.count {
                for name in protocolHolder.conformingProtocolNames {
                    content += "conformingProtocolName: \(name)\n"
                }
            }
            
            for associatedType in protocolHolder.associatedTypes {
                content += "associatedTypeName: \(associatedType.name)\n"
                if let protocolOrClass = associatedType.protocolOrSuperClassName {
                    content += "associatedTypeProtocolOrSuperClass: \(protocolOrClass)\n"
                }
            }
            content += addTypealiasToContent(typealiases: protocolHolder.typealiases)
            content += addInitializerToContent(initializerHolders: protocolHolder.initializers)
            content += addVariableToContent(variableHolders: protocolHolder.variables)
            content += addFunctionsToContent(functionHolders: protocolHolder.functions)
            
            content += addExtensionToContent(extensionHolders: protocolHolder.extensions)
            content += "\n"
        } // for protocolHolder
        return content
    } // func protocolToContent(protocolHolders: [ProtocolHolder]) -> String
    
    private func addVariableToContent(variableHolders: [VariableHolder]) -> String {
        var content = ""
        for variableHolder in variableHolders {
            content += "--Variable--\n"
            content += "name: \(variableHolder.name)\n"
            content += "accessLevel: \(variableHolder.accessLevel)\n"
            content += "kind: \(variableHolder.kind)\n"
            if let customAttribute = variableHolder.customAttribute {
                content += "customAttribute: \(customAttribute)\n"
            }
            if variableHolder.isStatic {
                content += "isStatic\n"
            }
            if variableHolder.isLazy {
                content += "isLazy\n"
            }
            if variableHolder.isConstant {
                content += "isConstant\n"
            }
            if let literalType = variableHolder.literalType {
                content += "literalType: \(literalType)\n"
            }
            if let arrayType = variableHolder.arrayType {
                content += "arrayType: \(arrayType)\n"
            }
            if let key = variableHolder.dictionaryKeyType {
                content += "dictionaryKeyType: \(key)\n"
            }
            if let value = variableHolder.dictionaryValueType {
                content += "dictionaryValueType: \(value)\n"
            }
            if 0 < variableHolder.tupleTypes.count {
                for element in variableHolder.tupleTypes {
                    content += "tupleType: \(element)\n"
                }
            }
            if let conformedProtocolByOpaqueResultType = variableHolder.conformedProtocolByOpaqueResultType {
                content += "conformedProtocolByOpaqueResultType: \(conformedProtocolByOpaqueResultType)\n"
            }
            if variableHolder.isOptionalType {
                content += "isOptionalType\n"
            }
            if let initialValue = variableHolder.initialValue {
                content += "initialValue: \(initialValue)\n"
            }
            if variableHolder.haveWillSet {
                content += "haveWillSet\n"
            }
            if variableHolder.haveDidSet {
                content += "haveDidSet\n"
            }
            if variableHolder.haveGetter {
                content += "haveGetter\n"
            }
            if variableHolder.haveSetter {
                content += "haveSetter\n"
            }
        } // for variableHolder
        return content
    } // func addVariableToContent(variableHolders: [VariableHolder]) -> String
    
    private func addFunctionsToContent(functionHolders: [FunctionHolder]) -> String {
        var content = ""
        for functionHolder in functionHolders {
            content += "-----Function-----\n"
            content += "name: \(functionHolder.name)\n"
            content += "accessLevel: \(functionHolder.accessLevel)\n"
            
            if functionHolder.isStatic {
                content += "isStatic\n"
            }
            if functionHolder.isOverride {
                content += "isOverride\n"
            }
            if functionHolder.isMutating {
                content += "isMutating\n"
            }
            
            content += addGenericsToContent(generics: functionHolder.generics)
            
            for parameter in functionHolder.parameters {
                content += "---Parameter---\n"
                if let externalName = parameter.externalName {
                    content += "externalName: \(externalName)\n"
                }
                if let internalName = parameter.internalName {
                    content += "internalName: \(internalName)\n"
                }
                if parameter.haveInoutKeyword {
                    content += "haveInoutKeyword\n"
                }
                if parameter.isVariadic {
                    content += "isVariadic\n"
                }
                if let literalType = parameter.literalType {
                    content += "literalType: \(literalType)\n"
                }
                if let arrayType = parameter.arrayType {
                    content += "arrayType: \(arrayType)\n"
                }
                if let keyType = parameter.dictionaryKeyType {
                    content += "dictionaryKeyType: \(keyType)\n"
                }
                if let valueType = parameter.dictionaryValueType {
                    content += "dictionaryValueType: \(valueType)\n"
                }
                for tupleType in parameter.tupleTypes {
                    content += "tupleType: \(tupleType)\n"
                }
                if parameter.isOptionalType {
                    content += "isOptionalType\n"
                }
                if let initialValue = parameter.initialValue {
                    content += "initialValue: \(initialValue)\n"
                }
            } // for parameter in functionHolder.parameters
            
            if let returnValue = functionHolder.returnValue {
                content += "---ReturnValue---\n"
                if let literalType = returnValue.literalType {
                    content += "literalType: \(literalType)\n"
                }
                if let arrayType = returnValue.arrayType {
                    content += "arrayType: \(arrayType)\n"
                }
                if let keyType = returnValue.dictionaryKeyType {
                    content += "dictionaryKeyType: \(keyType)\n"
                }
                if let valueType = returnValue.dictionaryValueType {
                    content += "dictionaryValueType: \(valueType)\n"
                }
                for tupleType in returnValue.tupleTypes {
                    content += "tupleType: \(tupleType)\n"
                }
                if returnValue.isOptional {
                    content += "isOptionalType\n"
                }
                if let protocolName = returnValue.conformedProtocolByOpaqueResultTypeOfReturnValue {
                    content += "conformedProtocolByOpaqueResultTypeOfReturnValue: \(protocolName)\n"
                }
            } // if let returnValue = functionHolder.returnValue
        } // for functionHolder
        return content
    } // func addFunctionsToContent(functionHolders: [FunctionHolder]) -> String
    
    private func addInitializerToContent(initializerHolders: [InitializerHolder]) -> String {
        var content = ""
        for initializerHolder in initializerHolders {
            content += "---Initializer---\n"
            if initializerHolder.isConvenience {
                content += "isConvenience\n"
            }
            if initializerHolder.isFailable {
                content += "isFailable\n"
            }
            
            for parameter in initializerHolder.parameters {
                print("---Parameter---\n")
                if let name = parameter.name {
                    content += "parameterName: \(name)\n"
                }
                if let literalType = parameter.literalType {
                    content += "literalType: \(literalType)\n"
                }
                if let arrayType = parameter.arrayType {
                    content += "arrayType: \(arrayType)\n"
                }
                if let keyType = parameter.dictionaryKeyType {
                    content += "dictionaryKeyType: \(keyType)\n"
                }
                if let valueType = parameter.dictionaryValueType {
                    content += "dictionaryValueType: \(valueType)\n"
                }
                for tuple in parameter.tupleTypes {
                    content += "tupleType: \(tuple)\n"
                }
                if parameter.isOptionalType {
                    content += "isOptionalType\n"
                }
                if let initialValue = parameter.initialValue {
                    content += "initialValue: \(initialValue)\n"
                }
            } // for parameter
        } // for initializerHolder in initializerHolders
        return content
    } // func addInitializerToContent(initializerHolders: [InitializerHolder]) -> String
    
    private func addExtensionToContent(extensionHolders: [ExtensionHolder]) -> String {
        var content = ""
        for extensionHolder in extensionHolders {
            content += "---Extensioin---\n"
            if let type = extensionHolder.extensionedTypeName {
                content += "extensionedTypeName: \(type)\n"
            }
            for protocolName in extensionHolder.conformingProtocolNames {
                content += "conformingProtocolName: \(protocolName)\n"
            }
            content += addTypealiasToContent(typealiases: extensionHolder.typealiases)
            content += addInitializerToContent(initializerHolders: extensionHolder.initializers)
            content += addStructToContent(structHolders: extensionHolder.nestingStructs)
            content += addClassToContent(classHolders: extensionHolder.nestingClasses)
            content += addEnumToContent(enumHolders: extensionHolder.nestingEnums)
        } // for extensionHolder in extensionHolders
        return content
    } // func addExtensionToContent(extensions: [ExtensionHolder]) -> String
    
    private func addDependenciesToContent(dependencies: [WhomThisTypeAffect]) -> String {
        var content = "===== Dependencies =====\n"
        for element in dependencies {
            let affectingTypeName = element.affectingTypeName
            for affectedTypeName in element.affectedTypesName {
                content += "\(affectingTypeName) -> \(affectedTypeName.typeName)"
                if let elementName = affectedTypeName.elementName {
                    content += ".\(elementName)"
                }
                content += "\n"
            }
        } // for element in dependencies
        content += "\n"
        return content
    } // func addDependenciesToContent(dependencies: [WhomThisTypeAffect]) -> String
    
    private func addGenericsToContent(generics: [GenericHolder]) -> String {
        var content = ""
        if 0 < generics.count {
            content += "---Generics---\n"
            for generic in generics {
                if let parameterType = generic.parameterType {
                    content += "parameterType: \(parameterType)\n"
                }
                if let protocolName = generic.conformedProtocolName {
                    content += "conformedProtocolName: \(protocolName)\n"
                }
                if let superClass = generic.inheritedClassName {
                    content += "inheritedClassName: \(superClass)\n"
                }
            } // for generic in generics
        } // if 0 < generics.count
        return content
    } // func addGenericsToContent(generics: [GenericHolder]) -> String
    
    private func addTypealiasToContent(typealiases: [TypealiasHolder]) -> String {
        var content = ""
        if 0 < typealiases.count {
            content += "---Typealias---\n"
            for typealiasHolder in typealiases {
                if let type = typealiasHolder.associatedTypeName {
                    content += "associatedTypeName: \(type)\n"
                }
                content += "variableKind: \(typealiasHolder.variableKind)"
                if let literalType = typealiasHolder.literalType {
                    content += "literalType: \(literalType)\n"
                }
                if let arrayType = typealiasHolder.arrayType {
                    content += "arrayType: \(arrayType)\n"
                }
                if let key = typealiasHolder.dictionaryKeyType {
                    content += "dictionaryKeyType: \(key)\n"
                }
                if let value = typealiasHolder.dictionaryValueType {
                    content += "dictionaryValueType: \(value)\n"
                }
                for tupleType in typealiasHolder.tupleTypes {
                    content += "tupleType: \(tupleType)\n"
                }
            } // for typealiasHolder in typealiases
        } // if 0 < typealiases.count
        return content
    } // func addTypealiasToContent(typealiases: [TypealiasHolder]) -> String
    
    private func addStringStructToConvertedContent(stringStructHolder: ConvertedToStringStructHolder) -> String {
        var convertedContent = "=== Header ===\n"
        if stringStructHolder.accessLevelIcon == AccessLevel.internal.icon {
            convertedContent += "Struct\n"
        } else {
            convertedContent += stringStructHolder.accessLevelIcon + " Struct\n"
        }
        convertedContent += stringStructHolder.name + "\n"
        
        if 0 < stringStructHolder.generics.count {
            convertedContent += "=== Generic ===\n"
            for generic in stringStructHolder.generics {
                convertedContent += generic + "\n"
            }
        }
        
        if 0 < stringStructHolder.conformingProtocolNames.count {
            convertedContent += "=== Protocol ===\n"
            for protocolName in stringStructHolder.conformingProtocolNames {
                convertedContent += protocolName + "\n"
            }
        }
        
        if 0 < stringStructHolder.typealiases.count {
            convertedContent += "=== Typealias ===\n"
            for alias in stringStructHolder.typealiases {
                convertedContent += alias + "\n"
            }
        }
        
        if 0 < stringStructHolder.initializers.count {
            convertedContent += "=== Initializer ===\n"
            for initializer in stringStructHolder.initializers {
                convertedContent += initializer + "\n"
            }
        }
        
        if 0 < stringStructHolder.variables.count {
            convertedContent += "=== Property ===\n"
            for variable in stringStructHolder.variables {
                convertedContent += variable + "\n"
            }
        }
        
        if 0 < stringStructHolder.functions.count {
            convertedContent += "=== Function ===\n"
            for function in stringStructHolder.functions {
                convertedContent += function + "\n"
            }
        }
        
        if 0 < stringStructHolder.nestingConvertedToStringStructHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedStruct in stringStructHolder.nestingConvertedToStringStructHolders {
                convertedContent += addStringStructToConvertedContent(stringStructHolder: nestedStruct)
            }
        }
        
        if 0 < stringStructHolder.nestingConvertedToStringClassHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedClass in stringStructHolder.nestingConvertedToStringClassHolders {
                convertedContent += addStringClassToConvertedContent(stringClassHolder: nestedClass)
            }
        }
        
        if 0 < stringStructHolder.nestingConvertedToStringEnumHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedEnum in stringStructHolder.nestingConvertedToStringEnumHolders {
                convertedContent += addStringEnumToConvertedContent(stringEnumHolder: nestedEnum)
            }
        }
        
        if 0 < stringStructHolder.extensions.count {
            for extensionHolder in stringStructHolder.extensions {
                convertedContent += addStringExtensionToConvertedContent(stringExtensionHolder: extensionHolder)
            }
        }
        
        convertedContent += "\n"
        return convertedContent
    } // func addStringStructToStringType(stringStructHolders: [ConvertedToStringStructHolder]) -> String
    
    private func addStringClassToConvertedContent(stringClassHolder: ConvertedToStringClassHolder) -> String {
        var convertedContent = "=== Header ===\n"
        if stringClassHolder.accessLevelIcon == AccessLevel.internal.icon {
            convertedContent += "Class\n"
        } else {
            convertedContent += stringClassHolder.accessLevelIcon + " Class\n"
        }
        convertedContent += stringClassHolder.name + "\n"
        
        if 0 < stringClassHolder.generics.count {
            convertedContent += "=== Generic ===\n"
            for generic in stringClassHolder.generics {
                convertedContent += generic + "\n"
            }
        }
        
        if let superClass = stringClassHolder.superClassName {
            convertedContent += "=== SuperClass ===\n"
            convertedContent += superClass + "\n"
        }
        
        if 0 < stringClassHolder.conformingProtocolNames.count {
            convertedContent += "=== Protocol ===\n"
            for protocolName in stringClassHolder.conformingProtocolNames {
                convertedContent += protocolName + "\n"
            }
        }
        
        if 0 < stringClassHolder.typealiases.count {
            convertedContent += "=== Typealias ===\n"
            for alias in stringClassHolder.typealiases {
                convertedContent += alias + "\n"
            }
        }
        
        if 0 < stringClassHolder.initializers.count {
            convertedContent += "=== Initializer ===\n"
            for initializer in stringClassHolder.initializers {
                convertedContent += initializer + "\n"
            }
        }
        
        if 0 < stringClassHolder.variables.count {
            convertedContent += "=== Property ===\n"
            for variable in stringClassHolder.variables {
                convertedContent += variable + "\n"
            }
        }
        
        if 0 < stringClassHolder.functions.count {
            convertedContent += "=== Function ===\n"
            for function in stringClassHolder.functions {
                convertedContent += function + "\n"
            }
        }
        
        if 0 < stringClassHolder.nestingConvertedToStringStructHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedStruct in stringClassHolder.nestingConvertedToStringStructHolders {
                convertedContent += addStringStructToConvertedContent(stringStructHolder: nestedStruct)
            }
        }
        
        if 0 < stringClassHolder.nestingConvertedToStringClassHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedClass in stringClassHolder.nestingConvertedToStringClassHolders {
                convertedContent += addStringClassToConvertedContent(stringClassHolder: nestedClass)
            }
        }
        
        if 0 < stringClassHolder.nestingConvertedToStringEnumHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedEnum in stringClassHolder.nestingConvertedToStringEnumHolders {
                convertedContent += addStringEnumToConvertedContent(stringEnumHolder: nestedEnum)
            }
        }
        
        if 0 < stringClassHolder.extensions.count {
            for extensionHolder in stringClassHolder.extensions {
                convertedContent += addStringExtensionToConvertedContent(stringExtensionHolder: extensionHolder)
            }
        }
        
        convertedContent += "\n"
        return convertedContent
    } // func addStringClassToConvertedContent(stringClassHolder: ConvertedToStringClassHolder) -> String
    
    private func addStringEnumToConvertedContent(stringEnumHolder: ConvertedToStringEnumHolder) -> String {
        var convertedContent = "=== Header ===\n"
        if stringEnumHolder.accessLevelIcon == AccessLevel.internal.icon {
            convertedContent += "Enum\n"
        } else {
            convertedContent += stringEnumHolder.accessLevelIcon + " Enum\n"
        }
        convertedContent += stringEnumHolder.name + "\n"
        
        if 0 < stringEnumHolder.generics.count {
            convertedContent += "=== Generic ===\n"
            for generic in stringEnumHolder.generics {
                convertedContent += generic + "\n"
            }
        }
        
        if let rawvalueType = stringEnumHolder.rawvalueType {
            convertedContent += "=== RawvalueType ===\n"
            convertedContent += rawvalueType + "\n"
        }
        
        if 0 < stringEnumHolder.conformingProtocolNames.count {
            convertedContent += "=== Protocol ===\n"
            for protocolName in stringEnumHolder.conformingProtocolNames {
                convertedContent += protocolName + "\n"
            }
        }
        
        if 0 < stringEnumHolder.typealiases.count {
            convertedContent += "=== Typealias ===\n"
            for alias in stringEnumHolder.typealiases {
                convertedContent += alias + "\n"
            }
        }
        
        if 0 < stringEnumHolder.initializers.count {
            convertedContent += "=== Initializer ===\n"
            for initializer in stringEnumHolder.initializers {
                convertedContent += initializer + "\n"
            }
        }
        
        if 0 < stringEnumHolder.cases.count {
            convertedContent += "=== Case ===\n"
            for aCase in stringEnumHolder.cases {
                convertedContent += aCase + "\n"
            }
        }
        
        if 0 < stringEnumHolder.variables.count {
            convertedContent += "=== Property ===\n"
            for variable in stringEnumHolder.variables {
                convertedContent += variable + "\n"
            }
        }
        
        if 0 < stringEnumHolder.functions.count {
            convertedContent += "=== Function ===\n"
            for function in stringEnumHolder.functions {
                convertedContent += function + "\n"
            }
        }
        
        if 0 < stringEnumHolder.nestingConvertedToStringStructHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedStruct in stringEnumHolder.nestingConvertedToStringStructHolders {
                convertedContent += addStringStructToConvertedContent(stringStructHolder: nestedStruct)
            }
        }
        
        if 0 < stringEnumHolder.nestingConvertedToStringClassHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedClass in stringEnumHolder.nestingConvertedToStringClassHolders {
                convertedContent += addStringClassToConvertedContent(stringClassHolder: nestedClass)
            }
        }
        
        if 0 < stringEnumHolder.nestingConvertedToStringEnumHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedEnum in stringEnumHolder.nestingConvertedToStringEnumHolders {
                convertedContent += addStringEnumToConvertedContent(stringEnumHolder: nestedEnum)
            }
        }
        
        if 0 < stringEnumHolder.extensions.count {
            for extensionHolder in stringEnumHolder.extensions {
                convertedContent += addStringExtensionToConvertedContent(stringExtensionHolder: extensionHolder)
            }
        }
        
        convertedContent += "\n"
        return convertedContent
    } // func addStringEnumToConvertedContent(stringEnumHolder: ConvertedToStringEnumHolder) -> String
    
    private func addStringProtocolToConvertedContent(stringProtocoltHolder: ConvertedToStringProtocolHolder) -> String {
        var convertedContent = "=== Header ===\n"
        if stringProtocoltHolder.accessLevelIcon == AccessLevel.internal.icon {
            convertedContent += "Protocol\n"
        } else {
            convertedContent += stringProtocoltHolder.accessLevelIcon + " Protocol\n"
        }
        convertedContent += stringProtocoltHolder.name + "\n"
        
        if 0 < stringProtocoltHolder.conformingProtocolNames.count {
            convertedContent += "=== Protocol ===\n"
            for protocolName in stringProtocoltHolder.conformingProtocolNames {
                convertedContent += protocolName + "\n"
            }
        }
        
        if 0 < stringProtocoltHolder.associatedTypes.count {
            convertedContent += "=== AssociatedType ===\n"
            for type in stringProtocoltHolder.associatedTypes {
                convertedContent += type + "\n"
            }
        }
        
        if 0 < stringProtocoltHolder.typealiases.count {
            convertedContent += "=== Typealias ===\n"
            for alias in stringProtocoltHolder.typealiases {
                convertedContent += alias + "\n"
            }
        }
        
        if 0 < stringProtocoltHolder.initializers.count {
            convertedContent += "=== Initializer ===\n"
            for initializer in stringProtocoltHolder.initializers {
                convertedContent += initializer + "\n"
            }
        }
        
        if 0 < stringProtocoltHolder.variables.count {
            convertedContent += "=== Property ===\n"
            for variable in stringProtocoltHolder.variables {
                convertedContent += variable + "\n"
            }
        }
        
        if 0 < stringProtocoltHolder.functions.count {
            convertedContent += "=== Function ===\n"
            for function in stringProtocoltHolder.functions {
                convertedContent += function + "\n"
            }
        }
        
        if 0 < stringProtocoltHolder.extensions.count {
            for extensionHolder in stringProtocoltHolder.extensions {
                convertedContent += addStringExtensionToConvertedContent(stringExtensionHolder: extensionHolder)
            }
        }
        
        convertedContent += "\n"
        return convertedContent
    } // func addStringProtocolToConvertedContent(stringProtocoltHolder: ConvertedToStringProtocolHolder) -> String
    
    private func addStringExtensionToConvertedContent(stringExtensionHolder: ConvertedToStringExtensionHolder) -> String {
        var convertedContent = "=== Extension ===\n"
        
        if 0 < stringExtensionHolder.conformingProtocolNames.count {
            convertedContent += "=== Protocol ===\n"
            for protocolName in stringExtensionHolder.conformingProtocolNames {
                convertedContent += protocolName + "\n"
            }
        }
        
        if 0 < stringExtensionHolder.typealiases.count {
            convertedContent += "=== Typealias ===\n"
            for alias in stringExtensionHolder.typealiases {
                convertedContent += alias + "\n"
            }
        }
        
        if 0 < stringExtensionHolder.initializers.count {
            convertedContent += "=== Initializer ===\n"
            for initializer in stringExtensionHolder.initializers {
                convertedContent += initializer + "\n"
            }
        }
        
        if 0 < stringExtensionHolder.variables.count {
            convertedContent += "=== Property ===\n"
            for variable in stringExtensionHolder.variables {
                convertedContent += variable + "\n"
            }
        }
        
        if 0 < stringExtensionHolder.functions.count {
            convertedContent += "=== Function ===\n"
            for function in stringExtensionHolder.functions {
                convertedContent += function + "\n"
            }
        }
        
        if 0 < stringExtensionHolder.nestingConvertedToStringStructHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedStruct in stringExtensionHolder.nestingConvertedToStringStructHolders {
                convertedContent += addStringStructToConvertedContent(stringStructHolder: nestedStruct)
            }
        }
        
        if 0 < stringExtensionHolder.nestingConvertedToStringClassHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedClass in stringExtensionHolder.nestingConvertedToStringClassHolders {
                convertedContent += addStringClassToConvertedContent(stringClassHolder: nestedClass)
            }
        }
        
        if 0 < stringExtensionHolder.nestingConvertedToStringEnumHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedEnum in stringExtensionHolder.nestingConvertedToStringEnumHolders {
                convertedContent += addStringEnumToConvertedContent(stringEnumHolder: nestedEnum)
            }
        }
        
        convertedContent += "\n"
        return convertedContent
    } // func addStringExtensionToConvertedContent(stringExtensionHolder: ConvertedToStringExtensionHolder) -> String
} // struct HoldersPropertysPrinter
