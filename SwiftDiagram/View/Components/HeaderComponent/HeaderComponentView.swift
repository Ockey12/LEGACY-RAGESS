//
//  HeaderComponentView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/15.
//

import SwiftUI

struct HeaderComponentView: View {
    let accessLevelIcon: String
    let indexType: IndexComponentFrameWithText.IndexType
    let nameOfType: String
    let bodyWidth: CGFloat
    
//    let indexWidth = HeaderComponentSettingValues.indexWidth
    let itemHeight = HeaderComponentSettingValues.itemHeight
//    let connectionHeight = HeaderComponentSettingValues.connectionHeight
    let arrowTerminalWidth = HeaderComponentSettingValues.arrowTerminalWidth
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            IndexComponentFrameWithText(accessLevelIcon: accessLevelIcon,
                                        headerComponentIndexType: indexType)
                .offset(x: arrowTerminalWidth, y: 0)
            
            HeaderComponentFrameWithText(nameOfType: nameOfType, bodyWidth: bodyWidth)
                .offset(x: 0, y: itemHeight)
                
        } // ZStack
    } // var body
} // struct HeaderComponentView

//struct HeaderComponentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderComponentView()
//    }
//}
