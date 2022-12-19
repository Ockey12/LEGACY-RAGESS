//
//  NestEnumView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/16.
//

import SwiftUI

struct NestEnumView: View {
    let holder: ConvertedToStringEnumHolder
    let outsideFrameWidth: CGFloat

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
    
    let nestScale = ComponentSettingValues.nestComponentScale
    
    let fontSize = ComponentSettingValues.fontSize
    
    var allStrings: [String] {
        var strings = [holder.name]
        strings += holder.generics
        if let rawvalueType = holder.rawvalueType {
            strings.append(rawvalueType)
        }
        strings += holder.conformingProtocolNames
        strings += holder.typealiases
        strings += holder.initializers
        strings += holder.cases
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
            
            NestEnumFrame(holder: holder, bodyWidth: outsideWidth)
                .frame(width: outsideWidth + arrowTerminalWidth*2 + CGFloat(4), height: calculateFrameHeight())
                .foregroundColor(.white)
            
            NestEnumFrame(holder: holder, bodyWidth: outsideWidth)
                .stroke(lineWidth: ComponentSettingValues.borderWidth)
                .fill(.black)
                .frame(width: outsideWidth + arrowTerminalWidth*2 + CGFloat(4), height: calculateFrameHeight())
            
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
                
                // generic
                if 0 < holder.generics.count {
                    DetailComponentView(componentType: .generic,
                                        strings: holder.generics,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.generics.count))
                }
                
                // rawvalue type
                if let rawvalueType = holder.rawvalueType {
                    DetailComponentView(componentType: .rawvalueType,
                                        strings: [rawvalueType],
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: 1))
                }
                
                // conform
                if 0 < holder.conformingProtocolNames.count {
                    DetailComponentView(componentType: .conform,
                                        strings: holder.conformingProtocolNames,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.conformingProtocolNames.count))
                }
                
                // typealiases
                if 0 < holder.typealiases.count {
                    DetailComponentView(componentType: .typealias,
                                        strings: holder.typealiases,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.typealiases.count))
                }
                
                // initializer
                if 0 < holder.initializers.count {
                    DetailComponentView(componentType: .initializer,
                                        strings: holder.initializers,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.initializers.count))
                }
                
                // case
                if 0 < holder.cases.count {
                    DetailComponentView(componentType: .case,
                                        strings: holder.cases,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.cases.count))
                }
                
                // property
                if 0 < holder.variables.count {
                    DetailComponentView(componentType: .property,
                                        strings: holder.variables,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.variables.count))
                }
                
                // method
                if 0 < holder.functions.count {
                    DetailComponentView(componentType: .method,
                                        strings: holder.functions,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.functions.count))
                }
            } // VStack
            .scaleEffect(nestScale)
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
        
        // rawvalue type
        if let _ = holder.rawvalueType {
            height += connectionHeight
            height += itemHeight
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
        
        // case
        if 0 < holder.cases.count {
            height += connectionHeight
            height += itemHeight*CGFloat(holder.cases.count)
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
    } // func calculateFrameHeight() -> CGFloat
    
    private func calculateDetailComponentFrameHeight(numberOfItems: Int) -> CGFloat {
        var height = connectionHeight
        height += itemHeight*CGFloat(numberOfItems)
        height += bottomPaddingForLastText
        return height
    } // func calculateDetailComponentFrameHeight(numberOfItems: Int) -> CGFloat
} // struct NestEnumView

//struct NestEnumView_Previews: PreviewProvider {
//    static var previews: some View {
//        NestEnumView()
//    }
//}
