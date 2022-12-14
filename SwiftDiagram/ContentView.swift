//
//  ContentView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/14.
//

import SwiftUI


struct ContentView: View {
    let structHolder = ConvertedToStringStructHolder(name: "NameNameNameName",
                                                     accessLevelIcon: AccessLevel.private.icon,
                                                     generics: ["Generics", "GenericsGenericsGenericsGenerics", "GenericsGenerics"],
                                                     conformingProtocolNames: ["Protocol", "ProtocolProtocolProtocolProtocol", "ProtocolProtocol"],
                                                     typealiases: ["typealias", "typealiastypealiastypealias", "typealiastypealias"],
                                                     initializers: ["initializer",
                                                                   "initializerinitializer",
                                                                   "initializerinitializerinitializerinitializer",
                                                                   "initializerinitializer"],
                                                     variables: ["variable",
                                                                "variablevariablevariable",
                                                                "variablevariablevariablevariablevariablevariablevariable",
                                                                "variablevariablevariablevariable"],
                                                     functions: ["functionfunctionfunctionfunctionfunctionfunctionfunctionfunctionfunctionfunction",
                                                                "functionfunctionfunction",
                                                                "functionfunction",
                                                                "functionfunctionfunctionfunctionfunction",
                                                                 "function"]
    )
//variables: ["VariableVariable", "VariableVariableVariableVariable", "Variable"],
//functions: ["FunctionFunction", "FunctionFunctionFunction"]

    var body: some View {
        VStack {
            Spacer()
//            IndexComponentFrameWithText(accessLevelIcon: AccessLevel.private.icon,
//                                        headerComponentIndexType: .protocol)
            HStack {
                Spacer()
                
//                HeaderComponentFrame(bodyWidth: 800)
//                    .stroke(lineWidth: 5)
//                    .fill(.black)
//                    .background(.pink)
//                HeaderComponentFrameWithText(nameOfType: "AAAAAAAAAAAAAAAAAAAAA", bodyWidth: 1000)
//                HeaderComponentView(accessLevelIcon: AccessLevel.internal.icon,
//                                    indexType: .protocol,
//                                    nameOfType: "SomeProtocol",
//                                    bodyWidth: 800)
//                DetailComponentFrame(bodyWidth: 1000,
//                                     numberOfItems: 6)
//                .stroke(lineWidth: 5)
//                .fill(.black)
//                DetailComponentView(componentType: .associatedType,
//                                    strings: ["aaaaaaaaa",
//                                             "bbbbbbbbbbbbbbbbbbb",
//                                             "ccccc",
//                                             "dddddddddddd"],
//                                    bodyWidth: 1000)
                ScrollView([.vertical, .horizontal]) {
                    StructView(holder: structHolder)
                        .frame(width: 5000, height: 5000)
                }
                Spacer()
            } // HStack
            Spacer()
        } // VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
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
//        ScrollView {
//            MonitorView()
//            TokenVisitorView()
//                .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 1000, maxHeight: .infinity)
//        }
        
//        IndexComponentFrame()
//            .stroke(lineWidth: 3)
//            .frame(width: 300, height: 90)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
