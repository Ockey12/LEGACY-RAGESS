//
//  BuildFileMonitor.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/07.
//

import Foundation
import SwiftUI

// ビルドファイルの変更を監視する
class BuildFileMonitor {
    private var monitoredFolderFileDescriptor: CInt = -1
    private let folderMonitorQueue = DispatchQueue(label: "BuildFileMonitorQueue", attributes: .concurrent)
    private var buildFileMonitorSource: DispatchSourceFileSystemObject?
    let buildFileUrl: URL
    var buildFileDidChange: (() -> Void)?
//    @EnvironmentObject var urlsAndAST: URLsAndAST
//    let urlsAndAST = StaticURLsAndAST.instance
    @ObservedObject var urlsAndAST = URLsAndAST()
    private var swiftFilesURL = [URL]()
    
    init(url: URL) {
        self.buildFileUrl = url
    }
    
    func startMonitoring() {
        guard (buildFileMonitorSource == nil) &&
                (monitoredFolderFileDescriptor == -1) else {
            return
        }
        
        monitoredFolderFileDescriptor = open(buildFileUrl.path, O_EVTONLY)
        buildFileMonitorSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: monitoredFolderFileDescriptor,
                                                                           eventMask: .all,
                                                                           queue: folderMonitorQueue)
        buildFileMonitorSource?.setEventHandler { [weak self] in
//            self?.buildFileDidChange?()
            let dt = Date()
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
            print("\(dateFormatter.string(from: dt)): \(self!.buildFileUrl) did change")
            
            print("Monitored Swift Files")
            print("Count: \(self!.urlsAndAST.counter)")
            self!.urlsAndAST.counter += 1
//            for url in self!.urlsAndAST.swiftFilesURL {
//                print(url)
//            }
            let url = self!.urlsAndAST.projectDirectoryURL
            self!.swiftFilesURL.removeAll()
            self!.printFiles(url: url)
        }
        
        buildFileMonitorSource?.setCancelHandler { [weak self] in
            guard let strongSelf = self else {
                return
            }
            close(strongSelf.monitoredFolderFileDescriptor)
            strongSelf.monitoredFolderFileDescriptor = -1
            strongSelf.buildFileMonitorSource = nil
        }
        
        buildFileMonitorSource?.resume()
    } // end func startMonitoring()
    
    func stopMonitoring() {
        buildFileMonitorSource?.cancel()
    }
    
    private func printFiles(url: URL) {
        do {
            let tempDirContentsUrls = try FileManager.default.contentsOfDirectory(at: url,
                                                                                  includingPropertiesForKeys: nil,
                                                                                  options: [.skipsHiddenFiles])
            print("")
            print("Directory: \(url)")
            tempDirContentsUrls.forEach { url in
                print(url)
                if url.pathExtension == "swift" {
                    swiftFilesURL.append(url)
//                    urlsAndAST.swiftFilesURL.append(url)
                } else if url.hasDirectoryPath {
                    printFiles(url: url)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    } // printFiles()
}
