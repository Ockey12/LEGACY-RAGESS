//
//  HeaderComponentFrameWithText.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/14.
//

import SwiftUI

struct HeaderComponentFrameWithText: View {
    let nameOfType: String
    let bodyWidth: CGFloat
    
    let itemHeight = HeaderComponentSettingValues.itemHeight
    let arrowTerminalWidth = HeaderComponentSettingValues.arrowTerminalWidth
    let textLeadingPadding = HeaderComponentSettingValues.textLeadingPadding
    let textTrailPadding = HeaderComponentSettingValues.textTrailPadding
    let borderWidth = HeaderComponentSettingValues.borderWidth
    let fontSize = HeaderComponentSettingValues.fontSize
    
    var body: some View {
        ZStack {
            HeaderComponentFrame(bodyWidth: bodyWidth)
                .foregroundColor(.white)
            
            HeaderComponentFrame(bodyWidth: bodyWidth)
                .stroke(lineWidth: borderWidth)
                .fill(.black)
            
            Text(nameOfType)
                .lineLimit(1)
                .font(.system(size: 50))
                .foregroundColor(.black)
                .background(.white)
                .frame(width: bodyWidth, alignment: .leading)
                .position(x: (bodyWidth + textLeadingPadding)/2 + arrowTerminalWidth, y: itemHeight/2)
        } // ZSTack
    } // var body
} // struct HeaderComponentFrameWithText

//struct HeaderComponentFrameWithText_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderComponentFrameWithText()
//    }
//}
