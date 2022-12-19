//
//  FileChangeMonitor.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/20.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxParser

class FileChangeMonitor: ObservableObject {
    @Published var directoryHolder = DirectoryHolder()
    @Published var changeDate = ""
    
    private var monitoredFolderFileDescriptor: CInt = -1
    private let folderMonitorQueue = DispatchQueue(label: "BuildFileMonitorQueue", attributes: .concurrent)
    private var buildFileMonitorSource: DispatchSourceFileSystemObject?
    var buildFileURL: URL = FileManager.default.temporaryDirectory
    var projectDirectoryURL: URL = FileManager.default.temporaryDirectory
    
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
            
            DispatchQueue.main.async {
                // directoryHolderを初期化する
                self!.directoryHolder = DirectoryHolder()
                
                self!.parseSwiftFiles(url: self!.projectDirectoryURL, superDirectory: &self!.directoryHolder)
                
                self!.changeDate = "\(dateFormatter.string(from: dt))"
                
                // ビルドされた時間を追加することで、値の変更がpublishされる
                self!.changeHoldersChangeDate(directoryHolder: &self!.directoryHolder)
            } // DispatchQueue.main.async
        } // buildFileMonitorSource?.setEventHandler { [weak self] in
        
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
    
    private func parseSwiftFiles(url: URL, superDirectory: inout DirectoryHolder) {
        var directoryHolder = DirectoryHolder()
        directoryHolder.url = url
        do {
            let tempDirContentsUrls = try FileManager.default.contentsOfDirectory(at: url,
                                                                                  includingPropertiesForKeys: nil,
                                                                                  options: [.skipsHiddenFiles])
            tempDirContentsUrls.forEach { url in
                if url.pathExtension == "swift" {
                    // urlがSwiftファイルを示すとき
                    print("Swift File URL: \(url)")
                    directoryHolder.haveSwiftFileFlag = true
                    superDirectory.haveSwiftFileFlag = true
                    
                    let parsedContent = try! SyntaxParser.parse(url)
                    let visitor = TokenVisitor()
                    _ = visitor.visit(parsedContent)
                    var syntaxArrayParser = SyntaxArrayParser(classNameArray: visitor.getClassNameArray())
                    syntaxArrayParser.parseResultArray(resultArray: visitor.getResultArray())
                    
                    // Struct
                    let resultStructHolders = syntaxArrayParser.getResultStructHolders()
                    for structHolder in resultStructHolders {
                        let converter = StructHolderToStringConverter()
                        let convertedStructHolder = converter.convertToString(structHolder: structHolder)
                        directoryHolder.convertedStructHolders.append(convertedStructHolder)
                    }
                    
                    // Class
                    let resultClassHolders = syntaxArrayParser.getResultClassHolders()
                    for classHolder in resultClassHolders {
                        let converter = ClassHolderToStringConverter()
                        let convertedClassHolder = converter.convertToString(classHolder: classHolder)
                        directoryHolder.convertedClassHolders.append(convertedClassHolder)
                    }

                    // Enum
                    let resultEnumHolders = syntaxArrayParser.getResultEnumHolders()
                    for enumHolder in resultEnumHolders {
                        let converter = EnumHolderToStringConverter()
                        let convertedEnumHolder = converter.convertToString(enumHolder: enumHolder)
                        directoryHolder.convertedEnumHolders.append(convertedEnumHolder)
                    }

                    // Protocol
                    let resultProtocolHolders = syntaxArrayParser.getResultProtocolHolders()
                    for protocolHolder in resultProtocolHolders {
                        let converter = ProtocolHolderToStringConverter()
                        let convertedProtocolHolder = converter.convertToString(protocolHolder: protocolHolder)
                        directoryHolder.convertedProtocolHolders.append(convertedProtocolHolder)
                    }
                } else if url.hasDirectoryPath {
                    // urlがディレクトリを示すとき
                    print("Directory URL: \(url)")
                    parseSwiftFiles(url: url, superDirectory: &directoryHolder)
                }
            } // tempDirContentsUrls.forEach
            
            superDirectory.subDirectorys.append(directoryHolder)
        } catch {
            print(error.localizedDescription)
        }
    } // func parseSwiftFiles(url: URL)
    
    func changeHoldersChangeDate(directoryHolder: inout DirectoryHolder) {
        let dt = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        let date = "\(dateFormatter.string(from: dt))"
        
        for i in 0..<directoryHolder.convertedStructHolders.count {
            directoryHolder.convertedStructHolders[i].changeDate = date
        }
        for i in 0..<directoryHolder.convertedClassHolders.count {
            directoryHolder.convertedClassHolders[i].changeDate = date
        }
        for i in 0..<directoryHolder.convertedEnumHolders.count {
            directoryHolder.convertedEnumHolders[i].changeDate = date
        }
        for i in 0..<directoryHolder.convertedProtocolHolders.count {
            directoryHolder.convertedProtocolHolders[i].changeDate = date
        }
        for i in 0..<directoryHolder.subDirectorys.count {
            changeHoldersChangeDate(directoryHolder: &directoryHolder.subDirectorys[i])
        }
    } // func changeHoldersChangeDate(directoryHolder: inout DirectoryHolder)
} // class FileChangeMonitor
