//
//  NestStructView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/15.
//

import SwiftUI

struct NestStructView: View {
    let holder: ConvertedToStringStructHolder
    let outsideFrameWidth: CGFloat
//    let maxTextWidth: CGFloat
    @State private var maxTextWidth = ComponentSettingValues.minWidth
    
    let borderWidth = ComponentSettingValues.borderWidth
    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    let textTrailPadding = ComponentSettingValues.textTrailPadding
    
    let headerItemHeight = ComponentSettingValues.headerItemHeight
    
    let connectionHeight = ComponentSettingValues.connectionHeight
    let itemHeight = ComponentSettingValues.itemHeight
    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    
    let nestTopPaddingWithConnectionHeight = ComponentSettingValues.nestTopPaddingWithConnectionHeight
    let nestBottomPadding = ComponentSettingValues.nestBottomPadding
    
    let fontSize = ComponentSettingValues.fontSize
    
    var allStrings: [String] {
        var strings = [holder.name]
        strings += holder.generics
        strings += holder.conformingProtocolNames
        strings += holder.typealiases
        strings += holder.initializers
        strings += holder.variables
        strings += holder.functions
        return strings
    }
    
    var bodyWidth: Double {
        return maxTextWidth + textTrailPadding
    }
    
    var frameWidth: Double {
        return bodyWidth + arrowTerminalWidth*2 + CGFloat(4)
    }
    
    var outsideWidth: Double {
        return outsideFrameWidth + textTrailPadding
    }
    
    var body: some View {
        ZStack {
            GetTextsMaxWidthView(strings: allStrings, maxWidth: $maxTextWidth)
            
//            NestStructFrame(holder: holder, bodyWidth: bodyWidth)
            NestStructFrame(holder: holder, bodyWidth: outsideWidth)
                .stroke(lineWidth: ComponentSettingValues.borderWidth)
                .fill(.black)
                .frame(width: outsideWidth + arrowTerminalWidth*2 + CGFloat(4), height: calculateFrameHeight())
//                .background(.pink)
            
            Text("Nest")
                .lineLimit(1)
                .font(.system(size: fontSize))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .position(x: outsideWidth/2 + arrowTerminalWidth, y: connectionHeight/2)
            
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
            .scaleEffect(0.85)
        } // ZStack
    } // var body
    
    private func calculateFrameHeight() -> CGFloat {
        var height: CGFloat = headerItemHeight + nestTopPaddingWithConnectionHeight
        
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
        
        height += nestBottomPadding
        
        return height
    }
}

//struct NestStructView_Previews: PreviewProvider {
//    static var previews: some View {
//        NestStructView()
//    }
//}
