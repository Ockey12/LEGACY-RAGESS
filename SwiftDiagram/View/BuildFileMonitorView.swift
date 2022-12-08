//
//  BuildFileMonitorView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/07.
//

import SwiftUI

//struct BuildFileMonitorView: View {
//    @State private var buildFileMonitor: BuildFileMonitor?
//    @State private var importerPresented = false
//    @State private var url: URL?
//    
//    var body: some View {
//        
//        VStack {
//            
//        }
//        .frame(minWidth: 1200, maxWidth: .infinity, minHeight: 700, maxHeight: .infinity)
//        .onAppear {
//            if let _ = buildFileMonitor {
//                
//            } else {
//                importerPresented = true
//            }
//        }
//        .fileImporter(isPresented: $importerPresented, allowedContentTypes: [.directory]) { result in
//            switch result {
//            // Libraryを表示するには、ターミナルであらかじめ"chflags nohidden ~/Library"を実行しておく
//            // urlは指定したファイルのURL
//            // サンプルのパス: Macintosh HD > ユーザ > onaga > ライブラリ > Developer > Xcode > DerivedData > SampleOfSwiftDiagram-alotmpgxvtakmreubfndzbondzlm > Build > Products > Debug-iphoneos > SampleOfSwiftDiagram.swiftmodule > Project > arm64-apple-ios.swiftsourceinfo
//            case .success(let url):
//                print("Monitoring URL: \(url)")
//                if let _ = buildFileMonitor {
//                    buildFileMonitor!.stopMonitoring()
//                }
//                buildFileMonitor = BuildFileMonitor(url: url)
////                buildFileMonitor?.buildFileDidChange = self.buildFileDidChange()
//                buildFileMonitor!.startMonitoring()
//                self.url = url
//            case .failure:
//                print("failure")
//            }
//        } // .fileImporter
//    } // var body
//    
//    private func buildFileDidChange()  {
//        print("\(url!) did change")
//    }
//} // BuildFileMonitorView
//
//struct BuildFileMonitorView_Previews: PreviewProvider {
//    static var previews: some View {
//        BuildFileMonitorView()
//    }
//}
