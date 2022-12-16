//
//  NestStructFrame.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/15.
//

import SwiftUI

struct NestStructFrame: Shape {
    let holder: ConvertedToStringStructHolder
    let bodyWidth: CGFloat
    
    var widthFromLeftEdgeToConnection: CGFloat {
        (bodyWidth - connectionWidth) / 2 + arrowTerminalWidth
    }
    
    let connectionWidth = ComponentSettingValues.connectionWidth
    let connectionHeight = ComponentSettingValues.connectionHeight
    let headerItemHeight = ComponentSettingValues.headerItemHeight
    let itemHeight = ComponentSettingValues.itemHeight
    let oneVerticalLineWithoutArrow = ComponentSettingValues.oneVerticalLineWithoutArrow
    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    let arrowTerminalHeight = ComponentSettingValues.arrowTerminalHeight
    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    let nestTopPaddingWithConnectionHeight = ComponentSettingValues.nestTopPaddingWithConnectionHeight
    let nestBottomPadding = ComponentSettingValues.nestBottomPadding

    func path(in rect: CGRect) -> Path {
        Path { path in
            // header
            // from right to left
            path.move(to: CGPoint(x: arrowTerminalWidth + bodyWidth, y: connectionHeight))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection + connectionWidth, y: connectionHeight))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection + connectionWidth, y: 0))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection, y: 0))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection, y: connectionHeight))
            path.addLine(to: CGPoint(x: arrowTerminalWidth, y: connectionHeight))
            
            // left side
            // from top to bottom
            path.addLine(to: CGPoint(x: arrowTerminalWidth, y: calculateBodyHeight()))
            
            // footer
            // from left to right
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection, y: calculateBodyHeight()))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection, y: calculateBodyHeight() - connectionHeight))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection + connectionWidth, y: calculateBodyHeight() - connectionHeight))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection + connectionWidth, y: calculateBodyHeight()))
            path.addLine(to: CGPoint(x: bodyWidth + arrowTerminalWidth, y: calculateBodyHeight()))
            
            // right side
            // from bottom to top
            path.addLine(to: CGPoint(x: bodyWidth + arrowTerminalWidth, y: connectionHeight))
        } // Path
    } // func path(in rect: CGRect) -> Path
    
    private func calculateBodyHeight() -> CGFloat {
        var height: CGFloat = connectionHeight + headerItemHeight + nestTopPaddingWithConnectionHeight
        
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
    } // func calculateFrameHeight() -> CGFloat
} // struct NestStructFrame

//struct NestStructFrame_Previews: PreviewProvider {
//    static var previews: some View {
//        NestStructFrame()
//    }
//}
