//
//  BuildFileMonitor.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/07.
//

import Foundation

// ビルドファイルの変更を監視する
class BuildFileMonitor {
    private var monitoredFolderFileDescriptor: CInt = -1
    private let folderMonitorQueue = DispatchQueue(label: "BuildFileMonitorQueue", attributes: .concurrent)
    private var buildFileMonitorSource: DispatchSourceFileSystemObject?
    let url: URL
    var buildFileDidChange: (() -> Void)?
    
    init(url: URL) {
        self.url = url
    }
    
    func startMonitoring() {
        guard (buildFileMonitorSource == nil) &&
                (monitoredFolderFileDescriptor == -1) else {
            return
        }
        
        monitoredFolderFileDescriptor = open(url.path, O_EVTONLY)
        buildFileMonitorSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: monitoredFolderFileDescriptor,
                                                                           eventMask: .all,
                                                                           queue: folderMonitorQueue)
        buildFileMonitorSource?.setEventHandler { [weak self] in
//            self?.buildFileDidChange?()
            let dt = Date()
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
            print("\(dateFormatter.string(from: dt)): \(self!.url) did change")
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
}
