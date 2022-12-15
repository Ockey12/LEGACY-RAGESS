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
    
    let borderWidth = ComponentSettingValues.borderWidth
    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    let textTrailPadding = ComponentSettingValues.textTrailPadding
    
    let headerItemHeight = ComponentSettingValues.itemHeight*2 + ComponentSettingValues.bottomPaddingForLastText
    
    let connectionHeight = ComponentSettingValues.connectionHeight
    let itemHeight = ComponentSettingValues.itemHeight
    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    
    let bodyWidth: CGFloat
    var numberOfItems: Int
    
    var frameWidth: Double {
        return bodyWidth + arrowTerminalWidth*2 + CGFloat(4)
    }
    
    var body: some View {
        ZStack {
            NestComponentFrame(bodyWidth: bodyWidth, numberOfItems: numberOfItems)
                .stroke(lineWidth: borderWidth)
                .fill(.black)
//                .background(.blue)
            
//            StructView(holder: structHolder)
//                .scaleEffect(0.8)
//            NestStructView(holder: structHolder)
            VStack(spacing: 0) {
                HeaderComponentView(accessLevelIcon: AccessLevel.private.icon,
                                    indexType: .enum,
                                    nameOfType: "NestedEnum",
                                    bodyWidth: bodyWidth)
                .offset(x: 0, y: 2)
                .frame(width: frameWidth ,
                       height: headerItemHeight)
//                .offset(y: ComponentSettingValues.nestBottomPadding)
//                .scaleEffect(0.8)

                // property
                if 0 < structHolder.variables.count {
                    DetailComponentView(componentType: .property,
                                        strings: structHolder.variables,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: connectionHeight + itemHeight*CGFloat(structHolder.variables.count) + bottomPaddingForLastText)
//                    .offset(y: ComponentSettingValues.nestBottomPadding)
//                    .scaleEffect(0.8)
//                    .background(.cyan)
                } // if 0 < holder.variables.count
            }
            .scaleEffect(0.8)
            .offset(y: ComponentSettingValues.nestBottomPadding*3)
            
        }
//        .background(.pink)
    }
}

//struct NestComponentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NestComponentView()
//    }
//}
