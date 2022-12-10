//
//  ContentView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/14.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
//        Text("Debug Now")
//            .onAppear {
//                let printer = TokenVisitorPrinter()
//                printer.printResultArray()
//            }
//            .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 1000, maxHeight: .infinity)
//        ScrollView {
//            SyntaxArrayParserView()
//                .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 1000, maxHeight: .infinity)
//        }
//        BuildFileMonitorView()
//        GetFilesListOfDirectoryView()
//        MonitorAndGetSourceFilesView()
        ScrollView {
            MonitorView()
//            TokenVisitorView()
                .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 1000, maxHeight: .infinity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
