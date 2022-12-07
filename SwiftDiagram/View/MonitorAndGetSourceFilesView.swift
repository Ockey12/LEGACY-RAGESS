//
//  MonitorAndGetSourceFilesView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/07.
//

import SwiftUI

struct MonitorAndGetSourceFilesView: View {
//    @EnvironmentObject var urlsAndAST: URLsAndAST
    @ObservedObject var urlsAndAST = URLsAndAST()
//    @State var urlsAndAST = StaticURLsAndAST.instance
    
    @State private var importerPresented = false
    @State private var importType = ImportType.none
    
    @State private var buildFileMonitor: BuildFileMonitor?
    @State private var buildFileUrl: URL?
    
    @State private var projectDirectoryUrl: URL?
    @State private var swiftFilesURL = [URL]()
    
    private enum ImportType {
        case buildFile
        case projectDirectory
        case none
    }
    
    var body: some View {
        VStack {
            Text("\(urlsAndAST.counter)")
            HStack {
                // プロジェクトのディレクトリを選択するボタン
                Button {
                    importerPresented = true
                    importType = .projectDirectory
                } label: {
                    Text("Select Project Directory")
                }
                .padding()
                
                // 監視するビルドファイルを選択するボタン
                Button {
                    importerPresented = true
                    importType = .buildFile
                } label: {
                    Text("Select Build File")
                }
                .padding()
            }
        } // VStack
        .fileImporter(isPresented: $importerPresented, allowedContentTypes: [.directory]) { result in
            switch result {
            case .success(let url):
                switch importType {
                case .buildFile:
                    // 監視するビルドファイルを選択するモード
                    print("Monitoring URL: \(url)")
                    // 既存のBuildFileMonitorの監視を終了する
                    if let _ = buildFileMonitor {
                        buildFileMonitor!.stopMonitoring()
                    }
                    // 新しくBuildFileMonitorを生成する
                    buildFileMonitor = BuildFileMonitor(url: url)
                    // ビルドファイルの監視を開始する
                    buildFileMonitor!.startMonitoring()
                    self.buildFileUrl = url
                    urlsAndAST.buildFileURL = url
                case .projectDirectory:
                    // プロジェクトのディレクトリを選択するモード
                    // swiftソースファイルのパスを保持する配列を空に初期化する
                    swiftFilesURL.removeAll()
//                    urlsAndAST.swiftFilesURL.removeAll()
                    print("Project Directory URL: \(url)")
                    printFiles(url: url)
                    print("\nSwiftFilesURL")
                    swiftFilesURL.forEach { url in
                        print(url)
                    }
                    self.projectDirectoryUrl = url
                    urlsAndAST.projectDirectoryURL = url
                case .none:
                    break
                }
            case .failure:
                print("ERROR: Failed fileImporter")
            }
        } // .fileImporter
    } // var body
    
    // 選択したプロジェクトのディレクトリ下にあるファイルとディレクトリのパスをprint()する
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

struct MonitorAndGetSourceFilesView_Previews: PreviewProvider {
    static var previews: some View {
        MonitorAndGetSourceFilesView()
    }
}
