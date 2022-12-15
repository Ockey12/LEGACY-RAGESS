//
//  NestStructView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/15.
//

import SwiftUI

struct NestStructView: View {
    let holder: ConvertedToStringStructHolder
    let maxTextWidth: CGFloat
    
    let borderWidth = ComponentSettingValues.borderWidth
    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    let textTrailPadding = ComponentSettingValues.textTrailPadding
    
    let headerItemHeight = ComponentSettingValues.headerItemHeight
    
    let connectionHeight = ComponentSettingValues.connectionHeight
    let itemHeight = ComponentSettingValues.itemHeight
    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    
    var bodyWidth: Double {
        return maxTextWidth + textTrailPadding
    }
    
    var frameWidth: Double {
        return bodyWidth + arrowTerminalWidth*2 + CGFloat(4)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                HeaderComponentView(accessLevelIcon: holder.accessLevelIcon,
                                    indexType: .struct,
                                    nameOfType: holder.name,
                                    bodyWidth: bodyWidth)
                .offset(x: 0, y: 2)
                .frame(width: frameWidth ,
                       height: headerItemHeight)
//                .background(.gray)
                
                // generic
                if 0 < holder.generics.count {
                    DetailComponentView(componentType: .generic,
                                        strings: holder.generics,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: connectionHeight + itemHeight*CGFloat(holder.generics.count) + bottomPaddingForLastText)
//                    .background(.blue)
                } // if 0 < holder.generics.count
                
                // conform
                if 0 < holder.conformingProtocolNames.count {
                    DetailComponentView(componentType: .conform,
                                        strings: holder.conformingProtocolNames,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: connectionHeight + itemHeight*CGFloat(holder.conformingProtocolNames.count) + bottomPaddingForLastText)
//                    .background(.green)
                } // if 0 < holder.conformingProtocolNames.count
                
                // typealiases
                if 0 < holder.typealiases.count {
                    DetailComponentView(componentType: .typealias,
                                        strings: holder.typealiases,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: connectionHeight + itemHeight*CGFloat(holder.typealiases.count) + bottomPaddingForLastText)
//                    .background(.pink)
                } // if 0 < holder.typealiases.count
                
                // initializer
                if 0 < holder.initializers.count {
                    DetailComponentView(componentType: .initializer,
                                        strings: holder.initializers,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: connectionHeight + itemHeight*CGFloat(holder.initializers.count) + bottomPaddingForLastText)
//                    .background(.yellow)
                } // if 0 < holder.initializers.count
                
                // property
                if 0 < holder.variables.count {
                    DetailComponentView(componentType: .property,
                                        strings: holder.variables,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: connectionHeight + itemHeight*CGFloat(holder.variables.count) + bottomPaddingForLastText)
//                    .background(.cyan)
                } // if 0 < holder.variables.count
                
                // method
                if 0 < holder.functions.count {
                    DetailComponentView(componentType: .method,
                                        strings: holder.functions,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: connectionHeight + itemHeight*CGFloat(holder.functions.count) + bottomPaddingForLastText)
//                    .background(.indigo)
                } // if 0 < holder.functions.count
            } // VStack
            .scaleEffect(0.8)
        } // ZStack
    } // var body
    
    private func calculateFrameHeight() -> CGFloat {
        var height: CGFloat = headerItemHeight
        
        // generic
        if 0 < holder.generics.count {
            height += connectionHeight
            height += itemHeight*CGFloat(holder.generics.count)
            height += bottomPaddingForLastText
        }
        
        // conform
        if 0 < holder.conformingProtocolNames.count {
            height += connectionHeight
            height += itemHeight*CGFloat(holder.conformingProtocolNames.count)
            height += bottomPaddingForLastText
        }
        
        // typealiases
        if 0 < holder.typealiases.count {
            height += connectionHeight
            height += itemHeight*CGFloat(holder.typealiases.count)
            height += bottomPaddingForLastText
        }
        
        // initializers
        if 0 < holder.initializers.count {
            height += connectionHeight
            height += itemHeight*CGFloat(holder.initializers.count)
            height += bottomPaddingForLastText
        }
        
        // property
        if 0 < holder.variables.count {
            height += connectionHeight
            height += itemHeight*CGFloat(holder.variables.count)
            height += bottomPaddingForLastText
        }
        
        // method
        if 0 < holder.functions.count {
            height += connectionHeight
            height += itemHeight*CGFloat(holder.functions.count)
            height += bottomPaddingForLastText
        }
        
        return height
    }
}

//struct NestStructView_Previews: PreviewProvider {
//    static var previews: some View {
//        NestStructView()
//    }
//}
