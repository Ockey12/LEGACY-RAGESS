//
//  GetFilesListOfDirectoryView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/07.
//

import SwiftUI

struct GetFilesListOfDirectoryView: View {
    @State private var importerPresented = false
    @State private var url: URL?
    @State private var swiftFilesURL = [URL]()
    
    var body: some View {
        VStack {
            Button {
                importerPresented = true
            } label: {
                Text("Open")
            }
            .padding()
        }
        .fileImporter(isPresented: $importerPresented, allowedContentTypes: [.directory]) { result in
            switch result {
            case .success(let url):
                print("Monitoring URL: \(url)")
                printFiles(url: url)
                self.url = url
            case .failure:
                print("failure")
            }
        } // .fileImporter
    } // var body
    
    func printFiles(url: URL) {
        do {
            let tempDirContentsUrls = try FileManager.default.contentsOfDirectory(at: url,
                                                                                  includingPropertiesForKeys: nil,
                                                                                  options: [.skipsHiddenFiles])
            print("")
            print("Directory: \(url)")
            tempDirContentsUrls.forEach { url in
                print(url)
                if url.pathExtension == "swift" {
                    print("↑SWIFT!")
                    swiftFilesURL.append(url)
                } else if url.hasDirectoryPath {
                    print("↑DIRECTORY")
                    printFiles(url: url)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    } // printFiles()
    
    private func isDerectory(url: URL) -> Bool {
//        let fileManager = FileManager.default
//        var isDir: ObjCBool = false
//        if fileManager.fileExists(atPath: url, isDirectory: &isDir) {
//            if isDir.boolValue {
//                return true
//            }
//        }
//        if url.ha
        return false
    }
}

struct GetFilesListOfDirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        GetFilesListOfDirectoryView()
    }
}
