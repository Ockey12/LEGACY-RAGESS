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
                    
                    for structHolder in syntaxArrayParser.getResultStructHolders() {
                        content += "Struct\n"
                        content += "name: \(structHolder.name)\n"
                        content += "accessLevel: \(structHolder.accessLevel)\n"
                        
                        if 0 < structHolder.conformingProtocolNames.count {
                            for name in structHolder.conformingProtocolNames {
                                content += "conformingProtocolName: \(name)\n"
                            }
                        }
                        
                        for variableHolder in structHolder.variables {
                            content += "Variable\n"
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
                        
                        content += "\n"
                    } // for structHolder
                    
                    for classHolder in syntaxArrayParser.getResultClassHolders() {
                        content += "Class\n"
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
                        
                        for variableHolder in classHolder.variables {
                            content += "Variable\n"
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
                        
                        content += "\n"
                    } // for structHolder
                    
                    content += "===== Dependencies =====\n"
                    for element in syntaxArrayParser.getWhomThisTypeAffectArray() {
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
                } else if url.hasDirectoryPath {
                    parseSwiftFiles(url: url)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
