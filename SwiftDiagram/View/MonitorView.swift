//
//  MonitorView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/08.
//

import SwiftUI

struct MonitorView: View {
    @EnvironmentObject var monitor: BuildFileMonitor
    @EnvironmentObject var arrowPoint: ArrowPoint
    @EnvironmentObject var maxWidthHolder: MaxWidthHolder
    @EnvironmentObject var redrawCounter: RedrawCounter
    @EnvironmentObject var canDrawArrowFlag: CanDrawArrowFlag
    
    @State private var importerPresented = false
    @State private var importType = ImportType.none
    
    @State private var buildFileURL = FileManager.default.temporaryDirectory
    @State private var projectDirectoryURL = FileManager.default.temporaryDirectory
    
    @State private var diagramViewSize = CGSize(width: 1000, height: 1000)
    @State private var diagramViewScale: CGFloat = 0.1
    
    @State private var arrowOpacity = 1.0
    
    let minScale: CGFloat = 0.05
    let maxScale: CGFloat = 0.7
    
    // DiagramView()の周囲の余白
    // .frame()のwidthとheightに加算する
    let diagramViewPadding: CGFloat = 0

    
    var body: some View {
        
        VStack {
            GeometryReader { geometry in
                ScrollView([.vertical, .horizontal]) {
                    
                    ZStack {
                        GetArrowsPointView()
                        DiagramView()
                        .onChange(of: monitor.getChangeDate(), perform: { _ in
                            redrawCounter.reset()
                            canDrawArrowFlag.flag = false
                        })
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

                        ForEach(arrowPoint.points, id: \.self) { point in
                            if point.isVisible {
                                if let start = point.start,
                                   let end = point.end {
                                    ArrowView(start: start, end: end)
                                        .opacity(arrowOpacity)
                                }
                            }
                        }
                    } // ZStack
                    .scaleEffect(diagramViewScale)
                    .frame(width: diagramViewSize.width*diagramViewScale,
                           height: diagramViewSize.height*diagramViewScale)
                    
                } // ScrollView
                .background(.white)
                .background(Color("Background"))
            } // GeometryReader
            
            HStack {
                Spacer()
                    .frame(width: 50)
                HStack {
                    Text("Scale")
                    Slider(value: $diagramViewScale, in: minScale...maxScale)
                        .padding(.trailing)
                }
                Spacer()
                    .frame(width: 50)
                HStack {
                    Text("Arrow Opacity")
                    Slider(value: $arrowOpacity, in: 0...1.0)
                        .padding(.trailing)
                }
                Spacer()
                    .frame(width: 50)
            }
            
            HStack {
                Spacer()
                
                // すべての依存関係を表示するボタン
                Button {
                    for i in 0..<arrowPoint.points.count {
                        arrowPoint.points[i].isVisible = true
                    }
                } label: {
                    Text("Show All Dependency")
                        .padding()
                }
                .padding()
                
                Spacer()
                // プロジェクトのディレクトリを選択するボタン
                Button {
                    importerPresented = true
                    importType = .projectDirectory
                } label: {
                    Text("Select Project Directory")
                        .padding()
                }
                .padding()
                
                // 監視するビルドファイルを選択するボタン
                Button {
                    importerPresented = true
                    importType = .buildFile
                } label: {
                    Text("Select Build File")
                        .padding()
                }
                .padding()
                
                Spacer()
            } // HStack
            
            // ビルドファイルとプロジェクトディレクトリのURL、ビルドされた時間を表示する
            VStack {
                HStack {
                    HStack {
                        Spacer()
                        Text("Build File URL: ")
                    }
                    .frame(width: 150)
                    Text("\(buildFileURL)")
                    Spacer()
                }
                HStack {
                    HStack {
                        Spacer()
                        Text("Project Directory URL: ")
                    }
                    .frame(width: 150)
                    Text("\(projectDirectoryURL)")
                    Spacer()
                }
                HStack {
                    HStack {
                        Spacer()
                        Text("Change Date: ")
                    }
                    .frame(width: 150)
                    Text("\(monitor.getChangeDate())")
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
