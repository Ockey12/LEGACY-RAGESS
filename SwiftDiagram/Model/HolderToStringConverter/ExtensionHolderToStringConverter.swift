//
//  ExtensionHolderToStringConverter.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/13.
//

import Foundation

struct ExtensionHolderToStringConverter {
    func convertToString(extensionHolder: ExtensionHolder) -> ConvertedToStringExtensionHolder {
        var convertedHolder = ConvertedToStringExtensionHolder()
        
        // protocolをString型に変換する
        for protocolName in extensionHolder.conformingProtocolNames {
            convertedHolder.conformingProtocolNames.append(protocolName)
        }
        
        // typealiasをString型に変換する
        let typealiasConverter = TypealiasHolderToStringConverter()
        let stringTypealiases = typealiasConverter.convertToString(typealiasHolders: extensionHolder.typealiases)
        convertedHolder.typealiases = stringTypealiases
        
        // initializerをString型に変換する
        let initializerConverter = InitializerHolderToStringConverter()
        let stringInitializers = initializerConverter.convertToString(initializerHolders: extensionHolder.initializers)
        convertedHolder.initializers = stringInitializers
        
        // variableをString型に変換する
        let variableConverter = VariableHolderToStringConverter()
        let stringVariables = variableConverter.convertToString(variableHolders: extensionHolder.variables)
        convertedHolder.variables = stringVariables
        
        // functionをString型に変換する
        let functionConverter = FunctionHolderToStringConverter()
        let stringFunctions = functionConverter.convertToString(functionHolders: extensionHolder.functions)
        convertedHolder.functions = stringFunctions
        
        // ネストしているStructHolderをConvertedToStringStructHolder型に変換する
        if 0 < extensionHolder.nestingStructs.count {
            let converter = StructHolderToStringConverter()
            for nestedStruct in extensionHolder.nestingStructs {
                let convertedContent = converter.convertToString(holder: nestedStruct)
                convertedHolder.nestingConvertedToStringStructHolders.append(convertedContent)
            }
        }
        
        // ネストしているClassHolderをString型に変換する
        if 0 < extensionHolder.nestingClasses.count {
            let converter = ClassHolderToStringConverter()
            for nestedClass in extensionHolder.nestingClasses {
                let convertedContent = converter.convertToString(classHolder: nestedClass)
                convertedHolder.nestingConvertedToStringClassHolders.append(convertedContent)
            }
        }
        
        // ネストしているEnumHolderをString型に変換する
        if 0 < extensionHolder.nestingEnums.count {
            let converter = EnumHolderToStringConverter()
            for nestedEnum in extensionHolder.nestingEnums {
                let convertedContent = converter.convertToString(enumHolder: nestedEnum)
                convertedHolder.nestingConvertedToStringEnumHolders.append(convertedContent)
            }
        }
        
        return convertedHolder
    } // func convertToString(extensionHolder: ExtensionHolder) -> ConvertedToStringExtensionHolder
}
