//
//  NestComponentView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/15.
//

import SwiftUI

struct NestComponentView: View {
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
                                                                "variablevariablevariablevariable"]
    )
    
    let bodyWidth: CGFloat
    var numberOfItems: Int
    
    let borderWidth = ComponentSettingValues.borderWidth
    
    var body: some View {
        ZStack {
            NestComponentFrame(bodyWidth: bodyWidth, numberOfItems: numberOfItems)
                .stroke(lineWidth: borderWidth)
                .fill(.black)
            
//            StructView(holder: structHolder)
//                .scaleEffect(0.8)
//            NestStructView(holder: structHolder)
            HeaderComponentView(accessLevelIcon: AccessLevel.private.icon,
                                indexType: .enum,
                                nameOfType: "NestedEnum",
                                bodyWidth: bodyWidth)
            .scaleEffect(0.8)
            .offset(y: ComponentSettingValues.nestBottomPadding)
        }
    }
}

//struct NestComponentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NestComponentView()
//    }
//}
