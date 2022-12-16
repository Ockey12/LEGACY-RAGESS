//
//  StructView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/15.
//

import SwiftUI

struct StructView: View {
    
    let holder: ConvertedToStringStructHolder
    @State private var maxTextWidth = ComponentSettingValues.minWidth
    
    let borderWidth = ComponentSettingValues.borderWidth
    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    let textTrailPadding = ComponentSettingValues.textTrailPadding
    
    let headerItemHeight = ComponentSettingValues.headerItemHeight
    
    let connectionHeight = ComponentSettingValues.connectionHeight
    let itemHeight = ComponentSettingValues.itemHeight
    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    
    var allStrings: [String] {
        var strings = [holder.name]
        strings += holder.generics
        strings += holder.conformingProtocolNames
        strings += holder.typealiases
        strings += holder.initializers
        strings += holder.variables
        strings += holder.functions
        
        let nestedStructs = holder.nestingConvertedToStringStructHolders
        for nestesStruct in nestedStructs {
            strings += nestesStruct.generics
            strings += nestesStruct.conformingProtocolNames
            strings += nestesStruct.typealiases
            strings += nestesStruct.initializers
            strings += nestesStruct.variables
            strings += nestesStruct.functions
        }
        
        return strings
    }
    
    var bodyWidth: Double {
        return maxTextWidth + textTrailPadding
    }
    
    var frameWidth: Double {
        return bodyWidth + arrowTerminalWidth*2 + 4
    }
    
    var body: some View {
        ZStack {
            GetTextsMaxWidthView(strings: allStrings, maxWidth: $maxTextWidth)
            VStack(spacing: 0) {
                // Header
                HeaderComponentView(accessLevelIcon: holder.accessLevelIcon,
                                    indexType: .struct,
                                    nameOfType: holder.name,
                                    bodyWidth: bodyWidth)
                .offset(x: 0, y: 2)
                .frame(width: frameWidth ,
                       height: headerItemHeight)
//                .background(.pink)
                
                // generic
                if 0 < holder.generics.count {
                    DetailComponentView(componentType: .generic,
                                        strings: holder.generics,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.generics.count))
//                    .background(.blue)
                } // if 0 < holder.generics.count
                
                // conform
                if 0 < holder.conformingProtocolNames.count {
                    DetailComponentView(componentType: .conform,
                                        strings: holder.conformingProtocolNames,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.conformingProtocolNames.count))
//                    .background(.green)
                } // if 0 < holder.conformingProtocolNames.count
                
                // typealiases
                if 0 < holder.typealiases.count {
                    DetailComponentView(componentType: .typealias,
                                        strings: holder.typealiases,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.typealiases.count))
//                    .background(.pink)
                } // if 0 < holder.typealiases.count
                
                // initializer
                if 0 < holder.initializers.count {
                    DetailComponentView(componentType: .initializer,
                                        strings: holder.initializers,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.initializers.count))
//                    .background(.yellow)
                } // if 0 < holder.initializers.count
                
                // property
                if 0 < holder.variables.count {
                    DetailComponentView(componentType: .property,
                                        strings: holder.variables,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.variables.count))
//                    .background(.cyan)
                } // if 0 < holder.variables.count
                
                // method
                if 0 < holder.functions.count {
                    DetailComponentView(componentType: .method,
                                        strings: holder.functions,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.functions.count))
//                    .background(.indigo)
                } // if 0 < holder.functions.count
                
                // nested Struct
                ForEach(holder.nestingConvertedToStringStructHolders, id: \.self) { nestedStruct in
//                    NestStructView(holder: nestedStruct, maxTextWidth: maxTextWidth)
                    NestStructView(holder: nestedStruct, outsideFrameWidth: maxTextWidth)
                        .frame(width: frameWidth)
                }
                
                // nested Class
                ForEach(holder.nestingConvertedToStringClassHolders, id: \.self) { nestedStruct in
//                    NestStructView(holder: nestedStruct, maxTextWidth: maxTextWidth)
                    NestClassView(holder: nestedStruct, outsideFrameWidth: maxTextWidth)
                        .frame(width: frameWidth)
                }
            } // VStack
        } // ZStack
    } // var body
    
    private func calculateDetailComponentFrameHeight(numberOfItems: Int) -> CGFloat {
        var height = connectionHeight
        height += itemHeight*CGFloat(numberOfItems)
        height += bottomPaddingForLastText
        return height
    } // func calculateDetailComponentFrameHeight(numberOfItems: Int) -> CGFloat
} // struct StructView

//struct StructView_Previews: PreviewProvider {
//    static var previews: some View {
//        StructView()
//    }
//}
