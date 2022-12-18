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
    @Published var convertedStructHolders = [ConvertedToStringStructHolder]()
    @Published var convertedClassHolders = [ConvertedToStringClassHolder]()
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
            //  プロジェクトディレクトリ下にあるSwiftファイルのURLを表示する
            self!.printSubFiles(url: self!.projectDirectoryURL)
            
            DispatchQueue.main.async {
//                self!.content = "\(dateFormatter.string(from: dt)): \(self!.projectDirectoryURL) was build.\n\n"
//                self!.convertedContent = ""
                
                // 配列を空にする
                self!.convertedStructHolders.removeAll()
                self!.convertedClassHolders.removeAll()
                
                self!.parseSwiftFiles(url: self!.projectDirectoryURL)
                
                self!.changeDate = "\(dateFormatter.string(from: dt))"
                
                // ビルドされた時間を追加することで、値の変更がpublishされる
                for i in 0..<self!.convertedStructHolders.count {
                    self!.convertedStructHolders[i].changeDate = "\(dateFormatter.string(from: dt))"
                }
                for i in 0..<self!.convertedClassHolders.count {
                    self!.convertedClassHolders[i].changeDate = "\(dateFormatter.string(from: dt))"
                }
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

            tempDirContentsUrls.forEach { url in
                if url.pathExtension == "swift" {
                    print(url)
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
                    for structHolder in resultStructHolders {
                        let converter = StructHolderToStringConverter()
                        let convertedStructHolder = converter.convertToString(structHolder: structHolder)
                        convertedStructHolders.append(convertedStructHolder)
                    }

                    let resultClassHolders = syntaxArrayParser.getResultClassHolders()
//                    addClassToContent(classHolders: resultClassHolders)
                    for classHolder in resultClassHolders {
                        let converter = ClassHolderToStringConverter()
                        let convertedClassHolder = converter.convertToString(classHolder: classHolder)
//                        addStringClassToConvertedContent(stringClassHolder: convertedClassHolder)
                        convertedClassHolders.append(convertedClassHolder)
                    }
//
//                    let resultEnumHolders = syntaxArrayParser.getResultEnumHolders()
//                    addEnumToContent(enumHolders: resultEnumHolders)
//                    for enumHolder in resultEnumHolders {
//                        let converter = EnumHolderToStringConverter()
//                        let convertedEnumHolder = converter.convertToString(enumHolder: enumHolder)
//                        addStringEnumToConvertedContent(stringEnumHolder: convertedEnumHolder)
//                    }
//
//                    let resultProtocolHolders = syntaxArrayParser.getResultProtocolHolders()
//                    addProtocolToContent(protocolHolders: resultProtocolHolders)
//                    for protocolHolder in resultProtocolHolders {
//                        let converter = ProtocolHolderToStringConverter()
//                        let convertedProtocolHolder = converter.convertToString(protocolHolder: protocolHolder)
//                        addStringProtocolToConvertedContent(stringProtocoltHolder: convertedProtocolHolder)
//                    }
//                    addDependenciesToContent(dependencies: syntaxArrayParser.getWhomThisTypeAffectArray())
                } else if url.hasDirectoryPath {
                    parseSwiftFiles(url: url)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    } // func parseSwiftFiles(url: URL)
} // class BuildFileMonitor
