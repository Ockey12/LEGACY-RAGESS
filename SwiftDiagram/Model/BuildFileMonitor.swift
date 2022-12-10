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
    } // end func startMonitoring()
    
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
    } // printFiles()
    
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
                    
                    addStructToContent(structHolders: syntaxArrayParser.getResultStructHolders())
                    addClassToContent(classHolders: syntaxArrayParser.getResultClassHolders())
                    addEnumToContent(enumHolders: syntaxArrayParser.getResultEnumHolders())
                    addProtocolToContent(protocolHolders: syntaxArrayParser.getResultProtocolHolders())
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
        for structHolder in structHolders {
            content += "-----Struct-----\n"
            content += "name: \(structHolder.name)\n"
            content += "accessLevel: \(structHolder.accessLevel)\n"
            
            if 0 < structHolder.conformingProtocolNames.count {
                for name in structHolder.conformingProtocolNames {
                    content += "conformingProtocolName: \(name)\n"
                }
            }
            addInitializerToContent(initializerHolders: structHolder.initializers)
            addVariableToContent(variableHolders: structHolder.variables)
            addFunctionsToContent(functionHolders: structHolder.functions)
            content += "\n"
        } // for structHolder
    } // func addStructToContent(structHolders: [StructHolder])
    
    private func addClassToContent(classHolders: [ClassHolder]) {
        for classHolder in classHolders {
            content += "-----Class-----\n"
            content += "name: \(classHolder.name)\n"
            content += "accessLevel: \(classHolder.accessLevel)\n"
            
            if let superClass = classHolder.superClassName {
                content += "superClass: \(superClass)\n"
            }
            
            if 0 < classHolder.conformingProtocolNames.count {
                for name in classHolder.conformingProtocolNames {
                    content += "conformingProtocolName: \(name)\n"
                }
            }
            addInitializerToContent(initializerHolders: classHolder.initializers)
            addVariableToContent(variableHolders: classHolder.variables)
            addFunctionsToContent(functionHolders: classHolder.functions)
            content += "\n"
        } // for classHolder
    } // func addClassToContent(classHolders: [ClassHolder])
    
    private func addEnumToContent(enumHolders: [EnumHolder]) {
        for enumHolder in enumHolders {
            content += "-----Enum-----\n"
            content += "name: \(enumHolder.name)\n"
            content += "accessLevel: \(enumHolder.accessLevel)\n"
            
            if let rawvalueType = enumHolder.rawvalueType {
                content += "rawvalueType: \(rawvalueType)\n"
            }
            
            if 0 < enumHolder.conformingProtocolNames.count {
                for name in enumHolder.conformingProtocolNames {
                    content += "conformingProtocolName: \(name)\n"
                }
            }
            
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
            addVariableToContent(variableHolders: protocolHolder.variables)
            addFunctionsToContent(functionHolders: protocolHolder.functions)
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
                content += "isOptional\n"
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
                if let initialValue = parameter.initialValue {
                    content += "initialValue: \(initialValue)\n"
                }
            } // for parameter
            
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
                if let protocolName = returnValue.conformedProtocolByOpaqueResultTypeOfReturnValue {
                    content += "conformedProtocolByOpaqueResultTypeOfReturnValue: \(protocolName)\n"
                }
            }
            
            content += "\n"
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
                    content += "name: \(name)\n"
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
            } // for parameter
        }
    } // func addInitializerToContent(initializerHolders: [InitializerHolder])
    
    private func addExtensionToContent(extensionHolders: [ExtensionHolder]) {
        for extensionHolder in extensionHolders {
            content += "---Extensioin---\n"
            if let type = extensionHolder.extensionedTypeName {
                content += "extensionedTypeName: \(type)"
            }
            for protocolName in extensionHolder.conformingProtocolNames {
                content += "conformingProtocolName: \(protocolName)"
            }
            addInitializerToContent(initializerHolders: extensionHolder.initializers)
        }
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
        }
        content += "\n"
    } // func addDependenciesToContent(dependencies: [WhomThisTypeAffect])
}
