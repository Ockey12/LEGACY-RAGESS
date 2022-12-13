//
//  ProtocolHolderToStringConverter.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/13.
//

import Foundation

struct ProtocolHolderToStringConverter {
    func convertToString(protocolHolder: ProtocolHolder) -> ConvertedToStringProtocolHolder {
        var convertedHolder = ConvertedToStringProtocolHolder()
        
        convertedHolder.name = protocolHolder.name
        convertedHolder.accessLevelIcon = protocolHolder.accessLevel.icon
        
        // protocolをString型に変換する
        for protocolName in protocolHolder.conformingProtocolNames {
            convertedHolder.conformingProtocolNames.append(protocolName)
        }
        
        // associatedtypeをString型に格納する
        for type in protocolHolder.associatedTypes {
            var stringAssociatedtype = type.name
            if let protocolName = type.protocolOrSuperClassName {
                stringAssociatedtype += ": " + protocolName
            }
            convertedHolder.associatedTypes.append(stringAssociatedtype)
        }
        
        // typealiasをString型に変換する
        let typealiasConverter = TypealiasHolderToStringConverter()
        let stringTypealiases = typealiasConverter.convertToString(typealiasHolders: protocolHolder.typealiases)
        convertedHolder.typealiases = stringTypealiases
        
        // initializerをString型に変換する
        let initializerConverter = InitializerHolderToStringConverter()
        let stringInitializers = initializerConverter.convertToString(initializerHolders: protocolHolder.initializers)
        convertedHolder.initializers = stringInitializers
        
        // variableをString型に変換する
        let variableConverter = VariableHolderToStringConverter()
        let stringVariables = variableConverter.convertToString(variableHolders: protocolHolder.variables)
        convertedHolder.variables = stringVariables
        
        // functionをString型に変換する
        let functionConverter = FunctionHolderToStringConverter()
        let stringFunctions = functionConverter.convertToString(functionHolders: protocolHolder.functions)
        convertedHolder.functions = stringFunctions
        
        // ネストしているStructHolderをConvertedToStringStructHolder型に変換する
        if 0 < protocolHolder.nestingStructs.count {
            let converter = StructHolderToStringConverter()
            for nestedStruct in protocolHolder.nestingStructs {
                let convertedContent = converter.convertToString(structHolder: nestedStruct)
                convertedHolder.nestingConvertedToStringStructHolders.append(convertedContent)
            }
        } // if 0 < protocolHolder.nestingStructs.count
        
        // ネストしているClassHolderをString型に変換する
        if 0 < protocolHolder.nestingClasses.count {
            let converter = ClassHolderToStringConverter()
            for nestedClass in protocolHolder.nestingClasses {
                let convertedContent = converter.convertToString(classHolder: nestedClass)
                convertedHolder.nestingConvertedToStringClassHolders.append(convertedContent)
            }
        } // if 0 < protocolHolder.nestingClasses.count
        
        // ネストしているEnumHolderをString型に変換する
        if 0 < protocolHolder.nestingEnums.count {
            let converter = EnumHolderToStringConverter()
            for nestedEnum in protocolHolder.nestingEnums {
                let convertedContent = converter.convertToString(enumHolder: nestedEnum)
                convertedHolder.nestingConvertedToStringEnumHolders.append(convertedContent)
            }
        } // if 0 < protocolHolder.nestingEnums.count
        
        /**
         ExtensionHolderをConvertedToStringExtensionHolder型に変換する
         */
        return convertedHolder
    } // func convertToString(protocolHolder: ProtocolHolder) -> ConvertedToStringProtocolHolder
}
