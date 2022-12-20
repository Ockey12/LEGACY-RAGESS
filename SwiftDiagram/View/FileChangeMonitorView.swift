//
//  FileChangeMonitorView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/20.
//

import SwiftUI

struct FileChangeMonitorView: View {
    @EnvironmentObject var monitor: FileChangeMonitor
    
    @State private var importerPresented = false
    @State private var importType = ImportType.none
    
    @State private var buildFileURL = FileManager.default.temporaryDirectory
    @State private var projectDirectoryURL = FileManager.default.temporaryDirectory
    
    @State private var diagramViewSize = CGSize(width: 1000, height: 1000)
    @State private var diagramViewScale: CGFloat = 0.2
    
    let minScale: CGFloat = 0.1
    let maxScale: CGFloat = 0.95
    
    // DiagramView()の周囲の余白
    // .frame()のwidthとheightに加算する
    let diagramViewPadding: CGFloat = 300
    
    var body: some View {
        
        VStack {
            GeometryReader { geometry in
                ScrollView([.vertical, .horizontal]) {
                    DiagramView()
                        
                    .background() {
                        GeometryReader { geometry in
                            Path { path in
                                let width = geometry.size.width
                                let height = geometry.size.height
                                DispatchQueue.main.async {
                                    self.diagramViewSize = CGSize(width: width + diagramViewPadding, height: height + diagramViewPadding)
                                } // DispatchQueue
                            } // Path
                        } // GeometryReader
                    } // .background()
                    .scaleEffect(diagramViewScale)
                    .frame(width: diagramViewSize.width*diagramViewScale,
                           height: diagramViewSize.height*diagramViewScale)
                } // ScrollView
                .background(Color(red: 248/256, green: 239/256, blue: 226/256))
            } // GeometryReader
            
            
            Divider()
            
            HStack {
                Text("拡大率: \(diagramViewScale)")
                    .padding(.leading)
                Slider(value: $diagramViewScale, in: minScale...maxScale)
                    .padding(.trailing)
            }
            
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
            } // HStack
            
            // ビルドファイルとプロジェクトディレクトリのURL、ビルドされた時間を表示する
            VStack {
                HStack {
                    Text("Build File URL: \(buildFileURL)")
                    Spacer()
                }
                HStack {
                    Text("Project Directory URL: \(projectDirectoryURL)")
                    Spacer()
                }
                HStack {
                    Text("Change Date: \(monitor.changeDate)")
                    Spacer()
                }
            } // VStack
            .padding()
        } // VStack
        .fileImporter(isPresented: $importerPresented, allowedContentTypes: [.directory]) { result in
            switch result {
            case .success(let url):
                switch importType {
                case .buildFile:
                    // 監視するビルドファイルを選択するモード
                    monitor.stopMonitoring()
                    monitor.buildFileURL = url
                    monitor.startMonitoring()
                    buildFileURL = url
                case .projectDirectory:
                    // プロジェクトのディレクトリを選択するモード
                    monitor.projectDirectoryURL = url
                    projectDirectoryURL = url
                case .none:
                    break
                }
            case .failure:
                print("ERROR: Failed fileImporter")
            }
        } // .fileImporter
    } // var body
    
    // fileImporterを開くとき、監視するビルドファイルを選択するのか、プロジェクトのディレクトリを選択するのかを表す
    private enum ImportType {
        case buildFile
        case projectDirectory
        case none
    }
}

//struct FileChangeMonitorView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileChangeMonitorView()
//    }
//}