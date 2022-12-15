//
//  NestComponentFrame.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/15.
//

import SwiftUI

struct NestComponentFrame: Shape {
    let bodyWidth: CGFloat
    var numberOfItems: Int
    
    var widthFromLeftEdgeToConnection: CGFloat {
        (bodyWidth - headerWidth) / 2 + arrowTerminalWidth
    }
    
    let headerWidth = ComponentSettingValues.connectionWidth
    let headerHeight = ComponentSettingValues.connectionHeight
    let itemHeight = ComponentSettingValues.itemHeight
    let oneVerticalLineWithoutArrow = ComponentSettingValues.oneVerticalLineWithoutArrow
    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    let arrowTerminalHeight = ComponentSettingValues.arrowTerminalHeight
    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    
    let topPadding = ComponentSettingValues.nestTopPadding
    let bottomPadding = ComponentSettingValues.nestBottomPadding
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            // header
            // from right to left
            path.move(to: CGPoint(x: arrowTerminalWidth + bodyWidth, y: headerHeight))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection + headerWidth, y: headerHeight))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection + headerWidth, y: 0))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection, y: 0))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection, y: headerHeight))
            path.addLine(to: CGPoint(x: arrowTerminalWidth, y: headerHeight))
            
            // items
            // left side
            // from top to bottom
            for numberOfItem in 0..<numberOfItems {
                path.addLine(to: CGPoint(x: arrowTerminalWidth, y: headerHeight + itemHeight*CGFloat(numberOfItem) + oneVerticalLineWithoutArrow))
                path.addLine(to: CGPoint(x: 0, y: headerHeight + itemHeight*CGFloat(numberOfItem) + oneVerticalLineWithoutArrow))
                path.addLine(to: CGPoint(x: 0, y: headerHeight + itemHeight*CGFloat(numberOfItem) + oneVerticalLineWithoutArrow + arrowTerminalHeight))
                path.addLine(to: CGPoint(x: arrowTerminalWidth, y: headerHeight + itemHeight*CGFloat(numberOfItem) + oneVerticalLineWithoutArrow + arrowTerminalHeight))
                path.addLine(to: CGPoint(x: arrowTerminalWidth, y: headerHeight + itemHeight*CGFloat(numberOfItem) + oneVerticalLineWithoutArrow*2 + arrowTerminalHeight))
            }
            
            // footer
            // from left to right
            path.addLine(to: CGPoint(x: arrowTerminalWidth, y: bottomPaddingForLastText + headerHeight*2 + itemHeight*CGFloat(numberOfItems)))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection, y: bottomPaddingForLastText + headerHeight*2 + itemHeight*CGFloat(numberOfItems)))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection, y: bottomPaddingForLastText + headerHeight + itemHeight*CGFloat(numberOfItems)))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection + headerWidth, y: bottomPaddingForLastText + headerHeight + itemHeight*CGFloat(numberOfItems)))
            path.addLine(to: CGPoint(x: widthFromLeftEdgeToConnection + headerWidth, y: bottomPaddingForLastText + headerHeight*2 + itemHeight*CGFloat(numberOfItems)))
            path.addLine(to: CGPoint(x: bodyWidth + arrowTerminalWidth, y: bottomPaddingForLastText + headerHeight*2 + itemHeight*CGFloat(numberOfItems)))
            path.addLine(to: CGPoint(x: bodyWidth + arrowTerminalWidth, y: headerHeight + itemHeight*CGFloat(numberOfItems)))

            // items
            // right side
            // from bottom to top
            for numberOfItem in 0..<numberOfItems {
                let numberOfItemFromBottom = numberOfItems - (numberOfItem + 1)
                path.addLine(to: CGPoint(x: arrowTerminalWidth + bodyWidth, y: headerHeight + itemHeight*CGFloat(numberOfItemFromBottom) + oneVerticalLineWithoutArrow + arrowTerminalHeight))
                path.addLine(to: CGPoint(x: arrowTerminalWidth*2 + bodyWidth, y: headerHeight + itemHeight*CGFloat(numberOfItemFromBottom) + oneVerticalLineWithoutArrow + arrowTerminalHeight))
                path.addLine(to: CGPoint(x: arrowTerminalWidth*2 + bodyWidth, y: headerHeight + itemHeight*CGFloat(numberOfItemFromBottom) + oneVerticalLineWithoutArrow))
                path.addLine(to: CGPoint(x: arrowTerminalWidth + bodyWidth, y: headerHeight + itemHeight*CGFloat(numberOfItemFromBottom) + oneVerticalLineWithoutArrow))
                path.addLine(to: CGPoint(x: arrowTerminalWidth + bodyWidth, y: headerHeight + itemHeight*CGFloat(numberOfItemFromBottom)))
            }
        } // Path
    } // func path(in rect: CGRect) -> Path
}

//struct NestComponentFrame_Previews: PreviewProvider {
//    static var previews: some View {
//        NestComponentFrame()
//    }
//}
