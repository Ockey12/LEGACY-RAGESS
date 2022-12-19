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
    let nestedStructHolder3 = ConvertedToStringStructHolder(name: "nestedStructHolder2",
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
    let nestedEnumHolder1 = ConvertedToStringEnumHolder(name: "nestedEnumHolder1",
                                                     accessLevelIcon: AccessLevel.private.icon,
                                                        rawvalueType: "rawvaluerawvaluerawvalue",
                                                     conformingProtocolNames: ["Protocol", "ProtocolProtocolProtocolProtocol", "ProtocolProtocol"],
                                                        
                                                     typealiases: ["typealias", "typealiastypealiastypealias", "typealiastypealias"],
                                                     initializers: ["initializer",
                                                                   "initializerinitializer",
                                                                   "initializerinitializerinitializerinitializer",
                                                                   "initializerinitializer"],
                                                        cases: ["casecase",
                                                               "casecasecasecasecasecase",
                                                               "casecasecasecasecasecase"],
                                                     variables: ["variable",
                                                                "variablevariablevariable",
                                                                "variablevariablevariablevariablevariablevariablevariablevariablevariablevariable",
                                                                "variablevariablevariablevariable"],
                                                     functions: ["functionfunctionfunctionfunction",
                                                                "functionfunctionfunction",
                                                                "functionfunction",
                                                                "functionfunctionfunctionfunctionfunction",
                                                                 "function"]
    )
    let nestedEnumHolder2 = ConvertedToStringEnumHolder(name: "nestedEnumHolder2",
                                                     accessLevelIcon: AccessLevel.private.icon,
                                                        rawvalueType: "rawvaluerawvaluerawvaluerawvaluerawvaluerawvaluerawvaluerawvaluerawvaluerawvaluerawvaluerawvaluerawvaluee",
                                                        cases: ["casecase",
                                                               "casecasecasecasecasecase",
                                                               "casecasecasecasecasecase",
                                                               "casecasecasecasecasecasecasecasecasecasecasecase",
                                                               "casecasecasecasecase"]
    )
//    let extensionHolder1 = ConvertedToStringExtensionHolder(conformingProtocolNames: ["Protocol", "ProtocolProtocolProtocolProtocol", "ProtocolProtocol"],
//                                                     typealiases: ["typealias", "typealiastypealiastypealias", "typealiastypealias"],
//                                                     initializers: ["initializer",
//                                                                   "initializerinitializer",
//                                                                   "initializerinitializerinitializerinitializer",
//                                                                   "initializerinitializer"],
//                                                     variables: ["variable",
//                                                                "variablevariablevariable",
//                                                                "variablevariablevariablevariable",
//                                                                "variablevariablevariablevariable"],
//                                                     functions: ["functionfunctionfunctionfunction",
//                                                                "functionfunctionfunction",
//                                                                "functionfunction",
//                                                                "functionfunctionfunctionfunctionfunction",
//                                                                 "function"],
//                                                            nestingConvertedToStringStructHolders: []
//    )
    var extensionHolder1: ConvertedToStringExtensionHolder {
        ConvertedToStringExtensionHolder(conformingProtocolNames: ["Protocol", "ProtocolProtocolProtocolProtocol", "ProtocolProtocol"],
                                                         typealiases: ["typealias", "typealiastypealiastypealias", "typealiastypealias"],
                                                         initializers: ["initializer",
                                                                       "initializerinitializer",
                                                                       "initializerinitializerinitializerinitializerinitializerinitializerinitializerinitializerinitializerinitializerinitializerinitializerinitializerinitializerinitializerinitializer",
                                                                       "initializerinitializer"],
                                                         variables: ["variable",
                                                                    "variablevariablevariable",
                                                                    "variablevariablevariablevariable",
                                                                    "variablevariablevariablevariable"],
                                                         functions: ["functionfunctionfunctionfunction",
                                                                    "functionfunctionfunction",
                                                                    "functionfunction",
                                                                    "functionfunctionfunctionfunctionfunction",
                                                                     "function"],
                                         nestingConvertedToStringStructHolders: [nestedStructHolder3]
        )
    }
    let extensionHolder2 = ConvertedToStringExtensionHolder(conformingProtocolNames: ["Protocol"]
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
                                             nestingConvertedToStringClassHolders: [nestedClassHolder1, nestedClassHolder2],
                                             nestingConvertedToStringEnumHolders: [nestedEnumHolder1, nestedEnumHolder2],
                                             extensions: [extensionHolder1, extensionHolder2]
)
    }
//variables: ["VariableVariable", "VariableVariableVariableVariable", "Variable"],
//functions: ["FunctionFunction", "FunctionFunctionFunction"]

    var body: some View {
//        MonitorView()
        ScaleChangeableView()
            .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 1000, maxHeight: .infinity)
    }  // var body
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
