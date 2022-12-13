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
        let functionConverter = FunctionHolderToStringConverter()
        let stringFunctions = functionConverter.convertToString(functionHolders: structHolder.functions)
        convertedHolder.functions = stringFunctions
        
        // ネストしているStructHolderをConvertedToStringStructHolder型に変換する
        if 0 < structHolder.nestingStructs.count {
            let converter = StructHolderToStringConverter()
            for nestedStruct in structHolder.nestingStructs {
                let convertedContent = converter.convertToString(structHolder: nestedStruct)
                convertedHolder.nestingConvertedToStringStructHolders.append(convertedContent)
            }
        } // if 0 < structHolder.nestingStructs.count
        
        // ネストしているClassHolderをString型に変換する
        if 0 < structHolder.nestingClasses.count {
            let converter = ClassHolderToStringConverter()
            for nestedClass in structHolder.nestingClasses {
                let convertedContent = converter.convertToString(classHolder: nestedClass)
                convertedHolder.nestingConvertedToStringClassHolders.append(convertedContent)
            }
        } // if 0 < structHolder.nestingClasses.count
        
        // ネストしているEnumHolderをString型に変換する
        if 0 < structHolder.nestingEnums.count {
            let converter = EnumHolderToStringConverter()
            for nestedEnum in structHolder.nestingEnums {
                let convertedContent = converter.convertToString(enumHolder: nestedEnum)
                convertedHolder.nestingConvertedToStringEnumHolders.append(convertedContent)
            }
        } // if 0 < structHolder.nestingEnums.count
        
        /**
         ExtensionHolderをConvertedToStringExtensionHolder型に変換する
         */
        return convertedHolder
    } // func convertToString(structHolder: StructHolder) -> ConvertedToStringStructHolder
}
