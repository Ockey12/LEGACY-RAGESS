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

        // ExtensionHolderをConvertedToStringExtensionHolder型に変換する
        if 0 < protocolHolder.extensions.count {
            let converter = ExtensionHolderToStringConverter()
            for extensionHolder in protocolHolder.extensions {
                let convertedContent = converter.convertToString(extensionHolder: extensionHolder)
                convertedHolder.extensions.append(convertedContent)
            }
        }
        
        return convertedHolder
    } // func convertToString(protocolHolder: ProtocolHolder) -> ConvertedToStringProtocolHolder
}
