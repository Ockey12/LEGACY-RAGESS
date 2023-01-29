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
    @Published private var convertedStructHolders = [ConvertedToStringStructHolder]()
    @Published private var convertedClassHolders = [ConvertedToStringClassHolder]()
    @Published private var convertedEnumHolders = [ConvertedToStringEnumHolder]()
    @Published private var convertedProtocolHolders = [ConvertedToStringProtocolHolder]()
    @Published private var dependenceHolders = [DependenceHolder]()
    @Published private var changeDate = ""
    
    private var allTypeNames = [String]()
    
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
//            self!.printSubFiles(url: self!.projectDirectoryURL)
            
            DispatchQueue.main.async {
                // 配列を空にする
                self!.convertedStructHolders.removeAll()
                self!.convertedClassHolders.removeAll()
                self!.convertedEnumHolders.removeAll()
                self!.convertedProtocolHolders.removeAll()
                self!.dependenceHolders.removeAll()
                self!.allTypeNames.removeAll()
                
                self!.parseSwiftFiles(url: self!.projectDirectoryURL)
                
                // 抽出した依存関係をフィルタリングする
                // 組み込まれている型が影響を与える依存関係を取り除く
                self!.dependenceHolders = self!.filterDependence(allTypeNames: self!.allTypeNames, dependenceHolders: self!.dependenceHolders)
                self!.printDependencies(self!.dependenceHolders)
                
                print("---All Type Name---")
                for name in self!.allTypeNames {
                    print(name)
                }
                
                self!.changeDate = "\(dateFormatter.string(from: dt))"
                
                // ビルドされた時間を追加することで、値の変更がpublishされる
                for i in 0..<self!.convertedStructHolders.count {
                    self!.convertedStructHolders[i].changeDate = "\(dateFormatter.string(from: dt))"
                }
                for i in 0..<self!.convertedClassHolders.count {
                    self!.convertedClassHolders[i].changeDate = "\(dateFormatter.string(from: dt))"
                }
                for i in 0..<self!.convertedEnumHolders.count {
                    self!.convertedEnumHolders[i].changeDate = "\(dateFormatter.string(from: dt))"
                }
                for i in 0..<self!.convertedProtocolHolders.count {
                    self!.convertedProtocolHolders[i].changeDate = "\(dateFormatter.string(from: dt))"
                }
                
                print("-----------------------------------------------------")
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
//                    print("Swift File URL: \(url)")

                    let parsedContent = try! SyntaxParser.parse(url)
                    let visitor = TokenVisitor()
                    _ = visitor.visit(parsedContent)
                    var syntaxArrayParser = SyntaxArrayParser(classNameArray: visitor.getClassNameArray())
                    syntaxArrayParser.parseResultArray(resultArray: visitor.getResultArray())
                    
                    // Struct
                    let resultStructHolders = syntaxArrayParser.getResultStructHolders()
                    for structHolder in resultStructHolders {
                        let converter = StructHolderToStringConverter()
                        let convertedStructHolder = converter.convertToString(holder: structHolder)
                        convertedStructHolders.append(convertedStructHolder)
                    }

                    // Class
                    let resultClassHolders = syntaxArrayParser.getResultClassHolders()
                    for classHolder in resultClassHolders {
                        let converter = ClassHolderToStringConverter()
                        let convertedClassHolder = converter.convertToString(classHolder: classHolder)
                        convertedClassHolders.append(convertedClassHolder)
                    }

                    // Enum
                    let resultEnumHolders = syntaxArrayParser.getResultEnumHolders()
                    for enumHolder in resultEnumHolders {
                        let converter = EnumHolderToStringConverter()
                        let convertedEnumHolder = converter.convertToString(enumHolder: enumHolder)
                        convertedEnumHolders.append(convertedEnumHolder)
                    }

                    // Protocol
                    let resultProtocolHolders = syntaxArrayParser.getResultProtocolHolders()
                    for protocolHolder in resultProtocolHolders {
                        let converter = ProtocolHolderToStringConverter()
                        let convertedProtocolHolder = converter.convertToString(protocolHolder: protocolHolder)
                        convertedProtocolHolders.append(convertedProtocolHolder)
                    }

                    // dependence
                    self.dependenceHolders += syntaxArrayParser.getResultDependenceHolders()
                    
                    // 宣言された全ての型の名前を取得する
                    var currentAllTypeNames = syntaxArrayParser.getAllTypeNames()
                    // 応急処置
                    // @main struct の main attributeを取り除く
                    currentAllTypeNames.removeAll(where: {$0 == "main"})
                    allTypeNames += currentAllTypeNames
                } else if url.hasDirectoryPath {
//                    print("Directory URL: \(url)")
                    parseSwiftFiles(url: url)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    } // func parseSwiftFiles(url: URL)
    
    // allTypeNamesに格納された、コード内で宣言された型がaffectingTypeな依存関係のみにフィルタリングする
    private func filterDependence(allTypeNames: [String], dependenceHolders: [DependenceHolder]) -> [DependenceHolder] {
        var newArray = [DependenceHolder]()
        
        for typeName in allTypeNames {
            for dependenceHolder in dependenceHolders {
                if typeName == dependenceHolder.affectingTypeName {
//                    print("typeName: \(typeName), affectingTypeName: \(dependenceHolder.affectingTypeName)")
                    newArray.append(dependenceHolder)
                }
            } // for dependenceHolder in dependenceHolders
        } // for typeName in allTypeNames
        
        return newArray
    } // func filterDependence(allTypeNames: [String], dependenceHolders: [DependenceHolder]) -> [DependenceHolder]
    
    private func printDependencies(_ dependenceHolder: [DependenceHolder]) {
        for dependency in dependenceHolder {
            for affectedType in dependency.affectedTypes {
                var text = "---Dependence---\n"
                text += "affectingTypeName: " + dependency.affectingTypeName + "\n"
                text += "affectedTypeKind: \(affectedType.affectedTypeKind)\n"
                text += "affectedTypeName: " + affectedType.affectedTypeName + "\n"
                if let numberOfExtension = affectedType.numberOfExtension {
                    text += "  numberOfExtension: \(numberOfExtension)\n"
                }
                text += "componentKind: \(affectedType.componentKind)\n"
                text += "numberOfComponent: \(affectedType.numberOfComponent)\n"
                print(text)
            }
        } // for dependency in dependencies
    } // func printDependencies(_ dependenceHolder: [DependenceHolder])
    
    func getStruct() -> [ConvertedToStringStructHolder] {
        return convertedStructHolders
    }
    
    func getClass() -> [ConvertedToStringClassHolder] {
        return convertedClassHolders
    }
    
    func getEnum() -> [ConvertedToStringEnumHolder] {
        return convertedEnumHolders
    }
    
    func getProtocol() -> [ConvertedToStringProtocolHolder] {
        return convertedProtocolHolders
    }
    
    func getDependence() -> [DependenceHolder] {
        return dependenceHolders
    }
    
    func getChangeDate() -> String {
        return changeDate
    }
    
    func numerOfAllType() -> Int {
        allTypeNames.count
    }
} // class BuildFileMonitor

extension BuildFileMonitor: Equatable {
    static func == (lhs: BuildFileMonitor, rhs: BuildFileMonitor) -> Bool {
        return (lhs.convertedStructHolders == rhs.convertedStructHolders) &&
                (lhs.convertedClassHolders == rhs.convertedClassHolders) &&
                (lhs.convertedEnumHolders == rhs.convertedEnumHolders) &&
                (lhs.convertedProtocolHolders == rhs.convertedProtocolHolders) &&
                (lhs.dependenceHolders == rhs.dependenceHolders) &&
                (lhs.changeDate == rhs.changeDate)
    }
}
