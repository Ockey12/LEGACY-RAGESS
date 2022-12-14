//
//  HeaderComponentFrame.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/14.
//

import SwiftUI

struct HeaderComponentFrame: Shape {
    var bodyWidth: CGFloat
    var widthFromLeftEdgeToConnection: CGFloat {
        (bodyWidth - connectionWidth) / 2 + arrowTerminalWidth
    }
    
    let connectionWidth = ComponentSettingValues.connectionWidth
    let connectionHeight = ComponentSettingValues.connectionHeight
    let oneVerticalLineWithoutArrow = ComponentSettingValues.oneVerticalLineWithoutArrow
    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    let arrowTerminalHeight = ComponentSettingValues.arrowTerminalHeight
    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            // left side
            // from top to bottom
            path.move(to: CGPoint(x: arrowTerminalWidth, y: 0))
            path.addLine(to: CGPoint(x: arrowTerminalWidth, y: oneVerticalLineWithoutArrow))
            path.addLine(to: CGPoint(x: 0, y: oneVerticalLineWithoutArrow))
            path.addLine(to: CGPoint(x: 0, y: oneVerticalLineWithoutArrow + arrowTerminalHeight))
            path.addLine(to: CGPoint(x: arrowTerminalWidth, y: oneVerticalLineWithoutArrow + arrowTerminalHeight))
            path.addLine(to: CGPoint(x: arrowTerminalWidth, y: oneVerticalLineWithoutArrow*2 + arrowTerminalHeight + bottomPaddingForLastText + connectionHeight))
            
            // bottom
            // from left to right
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection, y: oneVerticalLineWithoutArrow*2 + arrowTerminalHeight + bottomPaddingForLastText + connectionHeight))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection, y: oneVerticalLineWithoutArrow*2 + arrowTerminalHeight + bottomPaddingForLastText))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection + connectionWidth, y: oneVerticalLineWithoutArrow*2 + arrowTerminalHeight + bottomPaddingForLastText))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection + connectionWidth, y: oneVerticalLineWithoutArrow*2 + arrowTerminalHeight + bottomPaddingForLastText + connectionHeight))
            path.addLine(to: CGPoint(x: bodyWidth + arrowTerminalWidth, y: oneVerticalLineWithoutArrow*2 + arrowTerminalHeight + bottomPaddingForLastText + connectionHeight))
            
            // right side
            // from bottom to top
            path.addLine(to: CGPoint(x: bodyWidth + arrowTerminalWidth, y: oneVerticalLineWithoutArrow + arrowTerminalHeight))
            path.addLine(to: CGPoint(x: bodyWidth + arrowTerminalWidth*2, y: oneVerticalLineWithoutArrow + arrowTerminalHeight))
            path.addLine(to: CGPoint(x: bodyWidth + arrowTerminalWidth*2, y: oneVerticalLineWithoutArrow))
            path.addLine(to: CGPoint(x: bodyWidth + arrowTerminalWidth, y: oneVerticalLineWithoutArrow))
            path.addLine(to: CGPoint(x: bodyWidth + arrowTerminalWidth, y: 0))
            path.closeSubpath()
        } // Path
    } // func path(in rect: CGRect) -> Path
} // struct HeaderComponentFrame

//struct HeaderComponentFrame_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderComponentFrame()
//    }
//}
