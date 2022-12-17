//
//  MonitorView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/08.
//

import SwiftUI

struct MonitorView: View {
//    @ObservedObject var monitor = BuildFileMonitor()
    @StateObject var monitor = BuildFileMonitor()
    
    @State private var importerPresented = false
    @State private var importType = ImportType.none
    
    @State private var buildFileURL = FileManager.default.temporaryDirectory
    @State private var projectDirectoryURL = FileManager.default.temporaryDirectory
    
    var body: some View {
        
        return VStack {
//            HStack {
//                ScrollView {
//                    Text("Content")
//                    Divider()
//                    Text(monitor.content)
//                }
//                ScrollView {
//                    Text("ConvertedContent")
//                    Divider()
//                    Text(monitor.convertedContent)
//                }
//            }
            ScrollView([.vertical, .horizontal]) {
                HStack {
                    ForEach(monitor.convertedStructHolders, id: \.self) { holder in
                        StructView(holder: holder)
                            .padding()
                        Text(holder.changeDate)
                    }
                }
                .scaleEffect(0.3)
            }
            .background(.white)
            
            Divider()
            
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
            
            VStack {
                Text("Build File URL: \(buildFileURL)")
                Text("Project Directory URL: \(projectDirectoryURL)")
                Text("Change Date: \(monitor.changeDate)")
                    .onChange(of: monitor.changeDate, perform: { newValue in
                        self.monitor.objectWillChange.send()
                    })
//                    .onAppear {
//                        self.monitor.objectWillChange.send()
//                    }
            }
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

struct MonitorView_Previews: PreviewProvider {
    static var previews: some View {
        MonitorView()
    }
}
