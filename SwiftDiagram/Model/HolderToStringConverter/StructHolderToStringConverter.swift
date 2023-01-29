//
//  StructHolderToStringConverter.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/12.
//

import Foundation

struct StructHolderToStringConverter: HolderToStringConverter {
    typealias BeforeConvertedHolder = StructHolder
    typealias AfterConbertedHolder = ConvertedToStringStructHolder
    
    func convertToString(holder: BeforeConvertedHolder) -> AfterConbertedHolder {
        var convertedHolder = ConvertedToStringStructHolder()
        
        convertedHolder.name = holder.name
        convertedHolder.accessLevelIcon = holder.accessLevel.icon
        
        // genericをString型に変換する
        let genericConverter = GenericHolderToStringConverter()
        let stringGenerics = genericConverter.convertToString(genericHolders: holder.generics)
        convertedHolder.generics = stringGenerics
        
        // protocolをString型に変換する
        for protocolName in holder.conformingProtocolNames {
            convertedHolder.conformingProtocolNames.append(protocolName)
        }
        
        // typealiasをString型に変換する
        let typealiasConverter = TypealiasHolderToStringConverter()
        let stringTypealiases = typealiasConverter.convertToString(typealiasHolders: holder.typealiases)
        convertedHolder.typealiases = stringTypealiases
        
        // initializerをString型に変換する
        let initializerConverter = InitializerHolderToStringConverter()
        let stringInitializers = initializerConverter.convertToString(initializerHolders: holder.initializers)
        convertedHolder.initializers = stringInitializers
        
        // variableをString型に変換する
        let variableConverter = VariableHolderToStringConverter()
        let stringVariables = variableConverter.convertToString(variableHolders: holder.variables)
        convertedHolder.variables = stringVariables
        
        // functionをString型に変換する
        let functionConverter = FunctionHolderToStringConverter()
        let stringFunctions = functionConverter.convertToString(functionHolders: holder.functions)
        convertedHolder.functions = stringFunctions
        
        // ネストしているStructHolderをConvertedToStringStructHolder型に変換する
        if 0 < holder.nestingStructs.count {
            let converter = StructHolderToStringConverter()
            for nestedStruct in holder.nestingStructs {
                let convertedContent = converter.convertToString(holder: nestedStruct)
                convertedHolder.nestingConvertedToStringStructHolders.append(convertedContent)
            }
        }
        
        // ネストしているClassHolderをString型に変換する
        if 0 < holder.nestingClasses.count {
            let converter = ClassHolderToStringConverter()
            for nestedClass in holder.nestingClasses {
                let convertedContent = converter.convertToString(classHolder: nestedClass)
                convertedHolder.nestingConvertedToStringClassHolders.append(convertedContent)
            }
        }
        
        // ネストしているEnumHolderをString型に変換する
        if 0 < holder.nestingEnums.count {
            let converter = EnumHolderToStringConverter()
            for nestedEnum in holder.nestingEnums {
                let convertedContent = converter.convertToString(enumHolder: nestedEnum)
                convertedHolder.nestingConvertedToStringEnumHolders.append(convertedContent)
            }
        }

        // ExtensionHolderをConvertedToStringExtensionHolder型に変換する
        if 0 < holder.extensions.count {
            let converter = ExtensionHolderToStringConverter()
            for extensionHolder in holder.extensions {
                let convertedContent = converter.convertToString(extensionHolder: extensionHolder)
                convertedHolder.extensions.append(convertedContent)
            }
        }
        
        return convertedHolder
    } // func convertToString(structHolder: StructHolder) -> ConvertedToStringStructHolder
}
