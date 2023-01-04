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
    
    var CircleView: some View {
        ForEach(arrowPoint.points, id: \.self) { point in
            ZStack {
                if let startRight = point.startRight {
                    Circle()
                        .frame(width: 30, height: 30)
                        .position(x: startRight.x, y: startRight.y)
                        .foregroundColor(.red)
                }
                if let startLeft = point.startLeft {
                    Circle()
                        .frame(width: 30, height: 30)
                        .position(x: startLeft.x, y: startLeft.y)
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
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
                            if let start = point.start,
                               let end = point.end {
                                ArrowView(start: start, end: end)
                                    .opacity(arrowOpacity)
                            }
                        }
                    } // ZStack
                    .scaleEffect(diagramViewScale)
                    .frame(width: diagramViewSize.width*diagramViewScale,
                           height: diagramViewSize.height*diagramViewScale)
                    
                } // ScrollView
                .background(Color("Background"))
            } // GeometryReader
            
            HStack {
                Text("Scale: \(diagramViewScale)")
                    .padding(.leading)
                Slider(value: $diagramViewScale, in: minScale...maxScale)
                    .padding(.trailing)
            }
            
            HStack {
                Text("Arrow Opacity: \(arrowOpacity)")
                    .padding(.leading)
                Slider(value: $arrowOpacity, in: 0...1.0)
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
                    Text("Change Date: \(monitor.getChangeDate())")
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
