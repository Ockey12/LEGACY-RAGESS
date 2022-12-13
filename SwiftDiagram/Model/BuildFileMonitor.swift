//
//  ObservableMonitor.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/08.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxParser

class BuildFileMonitor: ObservableObject {
    @Published var content = ""
    @Published var convertedContent = ""
    private var monitoredFolderFileDescriptor: CInt = -1
    private let folderMonitorQueue = DispatchQueue(label: "BuildFileMonitorQueue", attributes: .concurrent)
    private var buildFileMonitorSource: DispatchSourceFileSystemObject?
    var buildFileURL: URL = FileManager.default.temporaryDirectory
    var projectDirectoryURL: URL = FileManager.default.temporaryDirectory
    
    @Published var counter = 1
    
    func startMonitoring() {
        guard (buildFileMonitorSource == nil) &&
                (monitoredFolderFileDescriptor == -1) else {
            return
        }
        
        // URLで参照されるディレクトリを、監視用で開く
        monitoredFolderFileDescriptor = open(buildFileURL.path, O_EVTONLY)
        // ディレクトリの変更を監視するディスパッチソースを定義する
        buildFileMonitorSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: monitoredFolderFileDescriptor,
                                                                           eventMask: .all,
                                                                           queue: folderMonitorQueue)
        // 変更が検出されたときに呼び出される
        buildFileMonitorSource?.setEventHandler { [weak self] in
            // 変更を検出した日時を取得する
            let dt = Date()
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
            // 変更を検出した日時と、監視しているURLを表示する
            print("\(dateFormatter.string(from: dt)): \(self!.buildFileURL) did change")
            // プロジェクトディレクトリのURLを表示する
            print("Project Directory: \(self!.projectDirectoryURL)")
            //  プロジェクトディレクトリ下にあるSwiftファイルのURLを表示する
            self!.printSubFiles(url: self!.projectDirectoryURL)
//            DispatchQueue.main.async {
//                self!.counter += 1
//            }
//            self!.counter += 1
            
            DispatchQueue.main.async {
                self!.content = "\(dateFormatter.string(from: dt)): \(self!.projectDirectoryURL) was build.\n\n"
                self!.convertedContent = ""
                self!.parseSwiftFiles(url: self!.projectDirectoryURL)
            }
        }
        
        // ソースがキャンセルされたときにディレクトリが閉じられるように、キャンセルハンドラを定義する
        buildFileMonitorSource?.setCancelHandler { [weak self] in
            guard let strongSelf = self else {
                return
            }
            close(strongSelf.monitoredFolderFileDescriptor)
            strongSelf.monitoredFolderFileDescriptor = -1
            strongSelf.buildFileMonitorSource = nil
        }
        
        // 監視を開始する
        buildFileMonitorSource?.resume()
    } // func startMonitoring()
    
    func stopMonitoring() {
        buildFileMonitorSource?.cancel()
    }
    
    private func printSubFiles(url: URL) {
        do {
            let tempDirContentsUrls = try FileManager.default.contentsOfDirectory(at: url,
                                                                                  includingPropertiesForKeys: nil,
                                                                                  options: [.skipsHiddenFiles])
//            print("")
//            print("Project Directory: \(url)")
            tempDirContentsUrls.forEach { url in
//                print(url)
                if url.pathExtension == "swift" {
                    print(url)
//                    swiftFilesURL.append(url)
//                    urlsAndAST.swiftFilesURL.append(url)
                } else if url.hasDirectoryPath {
                    printSubFiles(url: url)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    } // func printSubFiles(url: URL)
    
    private func parseSwiftFiles(url: URL) {
        do {
            let tempDirContentsUrls = try FileManager.default.contentsOfDirectory(at: url,
                                                                                  includingPropertiesForKeys: nil,
                                                                                  options: [.skipsHiddenFiles])
            tempDirContentsUrls.forEach { url in
                if url.pathExtension == "swift" {
                    print("Swift File URL: \(url)")
                    
                    let parsedContent = try! SyntaxParser.parse(url)
                    let visitor = TokenVisitor()
                    _ = visitor.visit(parsedContent)
                    var syntaxArrayParser = SyntaxArrayParser(classNameArray: visitor.getClassNameArray())
                    syntaxArrayParser.parseResultArray(resultArray: visitor.getResultArray())
                    
                    let resultStructHolders = syntaxArrayParser.getResultStructHolders()
                    addStructToContent(structHolders: resultStructHolders)
                    for structHolder in resultStructHolders {
                        let converter = StructHolderToStringConverter()
                        let convertedStructHolder = converter.convertToString(structHolder: structHolder)
                        addStringStructToConvertedContent(stringStructHolder: convertedStructHolder)
                    }

                    let resultClassHolders = syntaxArrayParser.getResultClassHolders()
                    addClassToContent(classHolders: resultClassHolders)
                    for classHolder in resultClassHolders {
                        let converter = ClassHolderToStringConverter()
                        let convertedClassHolder = converter.convertToString(classHolder: classHolder)
                        addStringClassToConvertedContent(stringClassHolder: convertedClassHolder)
                    }
                    
                    let resultEnumHolders = syntaxArrayParser.getResultEnumHolders()
                    addEnumToContent(enumHolders: resultEnumHolders)
                    for enumHolder in resultEnumHolders {
                        let converter = EnumHolderToStringConverter()
                        let convertedEnumHolder = converter.convertToString(enumHolder: enumHolder)
                        addStringEnumToConvertedContent(stringEnumHolder: convertedEnumHolder)
                    }
                    
                    let resultProtocolHolders = syntaxArrayParser.getResultProtocolHolders()
                    addProtocolToContent(protocolHolders: resultProtocolHolders)
                    for protocolHolder in resultProtocolHolders {
                        let converter = ProtocolHolderToStringConverter()
                        let convertedProtocolHolder = converter.convertToString(protocolHolder: protocolHolder)
                        addStringProtocolToConvertedContent(stringProtocoltHolder: convertedProtocolHolder)
                    }
                    addDependenciesToContent(dependencies: syntaxArrayParser.getWhomThisTypeAffectArray())
                } else if url.hasDirectoryPath {
                    parseSwiftFiles(url: url)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    } // func parseSwiftFiles(url: URL)
    
    private func addStructToContent(structHolders: [StructHolder]) {
//        let converter = StructHolderToStringConverter()
        for structHolder in structHolders {
            content += "-----Struct-----\n"
            content += "name: \(structHolder.name)\n"
            content += "accessLevel: \(structHolder.accessLevel)\n"
            
            addGenericsToContent(generics: structHolder.generics)
            
            if 0 < structHolder.conformingProtocolNames.count {
                for name in structHolder.conformingProtocolNames {
                    content += "conformingProtocolName: \(name)\n"
                }
            }
            addTypealiasToContent(typealiases: structHolder.typealiases)
            addInitializerToContent(initializerHolders: structHolder.initializers)
            addVariableToContent(variableHolders: structHolder.variables)
            addFunctionsToContent(functionHolders: structHolder.functions)
            
            addStructToContent(structHolders: structHolder.nestingStructs)
            addClassToContent(classHolders: structHolder.nestingClasses)
            addEnumToContent(enumHolders: structHolder.nestingEnums)
            
            addExtensionToContent(extensionHolders: structHolder.extensions)
            content += "\n"
            
//            let convertedStructHolder = converter.convertToString(structHolder: structHolder)
//            addStringStructToConvertedContent(stringStructHolder: convertedStructHolder)
        } // for structHolder
    } // func addStructToContent(structHolders: [StructHolder])
    
    private func addClassToContent(classHolders: [ClassHolder]) {
        for classHolder in classHolders {
            content += "-----Class-----\n"
            content += "name: \(classHolder.name)\n"
            content += "accessLevel: \(classHolder.accessLevel)\n"
            
            addGenericsToContent(generics: classHolder.generics)
            
            if let superClass = classHolder.superClassName {
                content += "superClass: \(superClass)\n"
            }
            
            if 0 < classHolder.conformingProtocolNames.count {
                for name in classHolder.conformingProtocolNames {
                    content += "conformingProtocolName: \(name)\n"
                }
            }
            addTypealiasToContent(typealiases: classHolder.typealiases)
            addInitializerToContent(initializerHolders: classHolder.initializers)
            addVariableToContent(variableHolders: classHolder.variables)
            addFunctionsToContent(functionHolders: classHolder.functions)
            
            addStructToContent(structHolders: classHolder.nestingStructs)
            addClassToContent(classHolders: classHolder.nestingClasses)
            addEnumToContent(enumHolders: classHolder.nestingEnums)
            
            addExtensionToContent(extensionHolders: classHolder.extensions)
            content += "\n"
        } // for classHolder
    } // func addClassToContent(classHolders: [ClassHolder])
    
    private func addEnumToContent(enumHolders: [EnumHolder]) {
        for enumHolder in enumHolders {
            content += "-----Enum-----\n"
            content += "name: \(enumHolder.name)\n"
            content += "accessLevel: \(enumHolder.accessLevel)\n"
            
            addGenericsToContent(generics: enumHolder.generics)
            
            if let rawvalueType = enumHolder.rawvalueType {
                content += "rawvalueType: \(rawvalueType)\n"
            }
            
            if 0 < enumHolder.conformingProtocolNames.count {
                for name in enumHolder.conformingProtocolNames {
                    content += "conformingProtocolName: \(name)\n"
                }
            }
            
            addTypealiasToContent(typealiases: enumHolder.typealiases)
            
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
            addInitializerToContent(initializerHolders: enumHolder.initializers)
            addVariableToContent(variableHolders: enumHolder.variables)
            addFunctionsToContent(functionHolders: enumHolder.functions)
            
            addStructToContent(structHolders: enumHolder.nestingStructs)
            addClassToContent(classHolders: enumHolder.nestingClasses)
            addEnumToContent(enumHolders: enumHolder.nestingEnums)
            
            addExtensionToContent(extensionHolders: enumHolder.extensions)
            content += "\n"
        } // for enumHolder
    } // func addEnumToContent(enumHolders: [EnumHolder])
    
    private func addProtocolToContent(protocolHolders: [ProtocolHolder]) {
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
            addTypealiasToContent(typealiases: protocolHolder.typealiases)
            addInitializerToContent(initializerHolders: protocolHolder.initializers)
            addVariableToContent(variableHolders: protocolHolder.variables)
            addFunctionsToContent(functionHolders: protocolHolder.functions)
            
            addExtensionToContent(extensionHolders: protocolHolder.extensions)
            content += "\n"
        } // for protocolHolder
    } // func protocolToContent(protocolHolders: [ProtocolHolder])
    
    private func addVariableToContent(variableHolders: [VariableHolder]) {
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
    } // func addVariableToContent(variableHolders: [VariableHolder])
    
    private func addFunctionsToContent(functionHolders: [FunctionHolder]) {
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
            
            addGenericsToContent(generics: functionHolder.generics)
            
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
    } // func addFunctionsToContent(functionHolders: [FunctionHolder])
    
    private func addInitializerToContent(initializerHolders: [InitializerHolder]) {
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
    } // func addInitializerToContent(initializerHolders: [InitializerHolder])
    
    private func addExtensionToContent(extensionHolders: [ExtensionHolder]) {
        for extensionHolder in extensionHolders {
            content += "---Extensioin---\n"
            if let type = extensionHolder.extensionedTypeName {
                content += "extensionedTypeName: \(type)\n"
            }
            for protocolName in extensionHolder.conformingProtocolNames {
                content += "conformingProtocolName: \(protocolName)\n"
            }
            addTypealiasToContent(typealiases: extensionHolder.typealiases)
            addInitializerToContent(initializerHolders: extensionHolder.initializers)
            addStructToContent(structHolders: extensionHolder.nestingStructs)
            addClassToContent(classHolders: extensionHolder.nestingClasses)
            addEnumToContent(enumHolders: extensionHolder.nestingEnums)
        } // for extensionHolder in extensionHolders
    } // func addExtensionToContent(extensions: [ExtensionHolder])
    
    private func addDependenciesToContent(dependencies: [WhomThisTypeAffect]) {
        content += "===== Dependencies =====\n"
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
    } // func addDependenciesToContent(dependencies: [WhomThisTypeAffect])
    
    private func addGenericsToContent(generics: [GenericHolder]) {
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
    } // func addGenericsToContent(generics: [GenericHolder])
    
    private func addTypealiasToContent(typealiases: [TypealiasHolder]) {
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
    } // func addTypealiasToContent(typealiases: [TypealiasHolder])
    
    private func addStringStructToConvertedContent(stringStructHolder: ConvertedToStringStructHolder) {
        convertedContent += "=== Header ===\n"
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
                addStringStructToConvertedContent(stringStructHolder: nestedStruct)
            }
        }
        
        if 0 < stringStructHolder.nestingConvertedToStringClassHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedClass in stringStructHolder.nestingConvertedToStringClassHolders {
                addStringClassToConvertedContent(stringClassHolder: nestedClass)
            }
        }
        
        if 0 < stringStructHolder.nestingConvertedToStringEnumHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedEnum in stringStructHolder.nestingConvertedToStringEnumHolders {
                addStringEnumToConvertedContent(stringEnumHolder: nestedEnum)
            }
        }
        
        convertedContent += "\n"
    } // func addStringStructToStringType(stringStructHolders: [ConvertedToStringStructHolder])
    
    private func addStringClassToConvertedContent(stringClassHolder: ConvertedToStringClassHolder) {
        convertedContent += "=== Header ===\n"
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
                addStringStructToConvertedContent(stringStructHolder: nestedStruct)
            }
        }
        
        if 0 < stringClassHolder.nestingConvertedToStringClassHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedClass in stringClassHolder.nestingConvertedToStringClassHolders {
                addStringClassToConvertedContent(stringClassHolder: nestedClass)
            }
        }
        
        if 0 < stringClassHolder.nestingConvertedToStringEnumHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedEnum in stringClassHolder.nestingConvertedToStringEnumHolders {
                addStringEnumToConvertedContent(stringEnumHolder: nestedEnum)
            }
        }
        
        convertedContent += "\n"
    } // func addStringClassToConvertedContent(stringClassHolder: ConvertedToStringClassHolder)
    
    private func addStringEnumToConvertedContent(stringEnumHolder: ConvertedToStringEnumHolder) {
        convertedContent += "=== Header ===\n"
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
                addStringStructToConvertedContent(stringStructHolder: nestedStruct)
            }
        }
        
        if 0 < stringEnumHolder.nestingConvertedToStringClassHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedClass in stringEnumHolder.nestingConvertedToStringClassHolders {
                addStringClassToConvertedContent(stringClassHolder: nestedClass)
            }
        }
        
        if 0 < stringEnumHolder.nestingConvertedToStringEnumHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedEnum in stringEnumHolder.nestingConvertedToStringEnumHolders {
                addStringEnumToConvertedContent(stringEnumHolder: nestedEnum)
            }
        }
        
        convertedContent += "\n"
    } // func addStringEnumToConvertedContent(stringEnumHolder: ConvertedToStringEnumHolder)
    
    private func addStringProtocolToConvertedContent(stringProtocoltHolder: ConvertedToStringProtocolHolder) {
        convertedContent += "=== Header ===\n"
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
        
        if 0 < stringProtocoltHolder.nestingConvertedToStringStructHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedStruct in stringProtocoltHolder.nestingConvertedToStringStructHolders {
                addStringStructToConvertedContent(stringStructHolder: nestedStruct)
            }
        }
        
        if 0 < stringProtocoltHolder.nestingConvertedToStringClassHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedClass in stringProtocoltHolder.nestingConvertedToStringClassHolders {
                addStringClassToConvertedContent(stringClassHolder: nestedClass)
            }
        }
        
        if 0 < stringProtocoltHolder.nestingConvertedToStringEnumHolders.count {
            convertedContent += "=== Nest ===\n"
            for nestedEnum in stringProtocoltHolder.nestingConvertedToStringEnumHolders {
                addStringEnumToConvertedContent(stringEnumHolder: nestedEnum)
            }
        }
        
        convertedContent += "\n"
    } // func addStringProtocolToConvertedContent(stringProtocoltHolder: ConvertedToStringProtocolHolder)
}
