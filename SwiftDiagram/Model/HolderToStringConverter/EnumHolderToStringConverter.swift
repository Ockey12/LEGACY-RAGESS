//
//  EnumHolderToStringConverter.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/13.
//

import Foundation

struct EnumHolderToStringConverter {
    func convertToString(enumHolder: EnumHolder) -> ConvertedToStringEnumHolder {
        var convertedHolder = ConvertedToStringEnumHolder()
        
        convertedHolder.name = enumHolder.name
        convertedHolder.accessLevelIcon = enumHolder.accessLevel.icon
        
        // genericをString型に変換する
        let genericConverter = GenericHolderToStringConverter()
        let stringGenerics = genericConverter.convertToString(genericHolders: enumHolder.generics)
        convertedHolder.generics = stringGenerics
        
        // rawvalueの型を格納する
        convertedHolder.rawvalueType = enumHolder.rawvalueType

        // protocolをString型に変換する
        for protocolName in enumHolder.conformingProtocolNames {
            convertedHolder.conformingProtocolNames.append(protocolName)
        }
        
        // typealiasをString型に変換する
        let typealiasConverter = TypealiasHolderToStringConverter()
        let stringTypealiases = typealiasConverter.convertToString(typealiasHolders: enumHolder.typealiases)
        convertedHolder.typealiases = stringTypealiases
        
        // initializerをString型に変換する
        let initializerConverter = InitializerHolderToStringConverter()
        let stringInitializers = initializerConverter.convertToString(initializerHolders: enumHolder.initializers)
        convertedHolder.initializers = stringInitializers
        
        // caseをString型に変換する
        for aCase in enumHolder.cases {
            var stringCase = aCase.caseName
            if let rawvalue = aCase.rawvalue {
                stringCase += " = " + rawvalue
            }
            if 0 < aCase.associatedValueTypes.count {
                stringCase += "("
                for (index, type) in aCase.associatedValueTypes.enumerated() {
                    stringCase += type
                    if index != aCase.associatedValueTypes.count - 1 {
                        stringCase += ", "
                    }
                }
                stringCase += ")"
            }
            convertedHolder.cases.append(stringCase)
        } // for aCase in enumHolder.cases
        
        // variableをString型に変換する
        let variableConverter = VariableHolderToStringConverter()
        let stringVariables = variableConverter.convertToString(variableHolders: enumHolder.variables)
        convertedHolder.variables = stringVariables
        
        // functionをString型に変換する
        let functionConverter = FunctionHolderToStringConverter()
        let stringFunctions = functionConverter.convertToString(functionHolders: enumHolder.functions)
        convertedHolder.functions = stringFunctions
        
        // ネストしているStructHolderをConvertedToStringStructHolder型に変換する
        if 0 < enumHolder.nestingStructs.count {
            let converter = StructHolderToStringConverter()
            for nestedStruct in enumHolder.nestingStructs {
                let convertedContent = converter.convertToString(structHolder: nestedStruct)
                convertedHolder.nestingConvertedToStringStructHolders.append(convertedContent)
            }
        } // if 0 < structHolder.nestingStructs.count
        
        // ネストしているClassHolderをString型に変換する
        if 0 < enumHolder.nestingClasses.count {
            let converter = ClassHolderToStringConverter()
            for nestedClass in enumHolder.nestingClasses {
                let convertedContent = converter.convertToString(classHolder: nestedClass)
                convertedHolder.nestingConvertedToStringClassHolders.append(convertedContent)
            }
        } // if 0 < classHolder.nestingClasses.count
        
        // ネストしているEnumHolderをString型に変換する
        if 0 < enumHolder.nestingEnums.count {
            let converter = EnumHolderToStringConverter()
            for nestedEnum in enumHolder.nestingEnums {
                let convertedContent = converter.convertToString(enumHolder: nestedEnum)
                convertedHolder.nestingConvertedToStringEnumHolders.append(convertedContent)
            }
        }
        
        // ExtensionHolderをConvertedToStringExtensionHolder型に変換する
        if 0 < enumHolder.extensions.count {
            let converter = ExtensionHolderToStringConverter()
            for extensionHolder in enumHolder.extensions {
                let convertedContent = converter.convertToString(extensionHolder: extensionHolder)
                convertedHolder.extensions.append(convertedContent)
            }
        }
        
        return convertedHolder
    } // func convertToString(enumHolder: EnumHolder) -> ConvertedToStringEnumHolder
}
