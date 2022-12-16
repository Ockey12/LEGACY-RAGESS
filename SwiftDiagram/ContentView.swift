//
//  ContentView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/14.
//

import SwiftUI


struct ContentView: View {
    let nestedStructHolder1 = ConvertedToStringStructHolder(name: "nestedStructHolder1",
                                                     accessLevelIcon: AccessLevel.private.icon,

                                                     conformingProtocolNames: ["Protocol", "ProtocolProtocolProtocolProtocol", "ProtocolProtocol"],
                                                     typealiases: ["typealias", "typealiastypealiastypealias", "typealiastypealias"],
                                                     initializers: ["initializer",
                                                                   "initializerinitializer",
                                                                   "initializerinitializerinitializerinitializer",
                                                                   "initializerinitializer"],
                                                     variables: ["variable",
                                                                "variablevariablevariable",
                                                                "variablevariablevariablevariablevariablevariablevariablevariablevariablevariablevariablevariablevariablevariable",
                                                                "variablevariablevariablevariable"],
                                                     functions: ["functionfunctionfunctionfunction",
                                                                "functionfunctionfunction",
                                                                "functionfunction",
                                                                "functionfunctionfunctionfunctionfunction",
                                                                 "function"]
    )
    let nestedStructHolder2 = ConvertedToStringStructHolder(name: "nestedStructHolder2",
                                                            functions: ["functionfunctionfunctionfunction",
                                                                       "functionfunctionfunction",
                                                                       "functionfunction",
                                                                       "functionfunctionfunctionfunctionfunction",
                                                                        "function"]
    )
    let nestedClassHolder1 = ConvertedToStringClassHolder(name: "nestedClassHolder1",
                                                     accessLevelIcon: AccessLevel.private.icon,
                                                     superClassName: "SuperClass",
                                                     conformingProtocolNames: ["Protocol", "ProtocolProtocolProtocolProtocol", "ProtocolProtocol"],
                                                     typealiases: ["typealias", "typealiastypealiastypealias", "typealiastypealias"],
                                                     initializers: ["initializer",
                                                                   "initializerinitializer",
                                                                   "initializerinitializerinitializerinitializer",
                                                                   "initializerinitializer"],
                                                     variables: ["variable",
                                                                "variablevariablevariable",
                                                                "variablevariablevariablevariablevariab",
                                                                "variablevariablevariablevariable"],
                                                     functions: ["functionfunctionfunctionfunction",
                                                                "functionfunctionfunction",
                                                                "functionfunction",
                                                                "functionfunctionfunctionfunctionfunction",
                                                                 "function"]
    )
    let nestedClassHolder2 = ConvertedToStringClassHolder(name: "nestedClassHolder2",
                                                     accessLevelIcon: AccessLevel.private.icon,
                                                     superClassName: "SuperClassSuperClassSuperClassSuperClassSuperClassSuperClassSuperClass",
                                                     functions: ["functionfunctionfunctionfunction",
                                                                "functionfunctionfunction",
                                                                "functionfunction",
                                                                "functionfunctionfunctionfunctionfunction",
                                                                 "function"]
    )
    var structHolder: ConvertedToStringStructHolder {
        return ConvertedToStringStructHolder(name: "NameNameNameName",
                                             accessLevelIcon: AccessLevel.private.icon,

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
                                             functions: ["functionfunctionfunctionfunction",
                                                        "functionfunctionfunction",
                                                        "functionfunction",
                                                        "functionfunctionfunctionfunctionfunction",
                                                         "function"],
                                             nestingConvertedToStringStructHolders: [nestedStructHolder1, nestedStructHolder2],
                                             nestingConvertedToStringClassHolders: [nestedClassHolder1, nestedClassHolder2]
)
    }
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
                        .scaleEffect(0.3)
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
