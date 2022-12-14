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
    
    let connectionWidth = HeaderComponentSettingValues.connectionWidth
    let connectionHeight = HeaderComponentSettingValues.connectionHeight
    let itemHeight = HeaderComponentSettingValues.itemHeight
    let oneVerticalLineWithoutArrow = HeaderComponentSettingValues.oneVerticalLineWithoutArrow
    let arrowTerminalWidth = HeaderComponentSettingValues.arrowTerminalWidth
    let arrowTerminalHeight = HeaderComponentSettingValues.arrowTerminalHeight
    let bottomPaddingForLastText = HeaderComponentSettingValues.bottomPaddingForLastText
    let borderWidth = HeaderComponentSettingValues.borderWidth
    
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
