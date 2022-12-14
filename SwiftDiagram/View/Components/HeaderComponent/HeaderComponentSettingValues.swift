//
//  HeaderComponentSettingValues.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/14.
//

import Foundation

struct HeaderComponentSettingValues {
    static let fontSize = ComponentSettingValues.fontSize
    static let indexWidth: CGFloat = 300
    static let itemHeight = ComponentSettingValues.itemHeight
    static let borderWidth = ComponentSettingValues.borderWidth
    
    static let connectionWidth = ComponentSettingValues.connectionWidth
    static let connectionHeight = ComponentSettingValues.connectionHeight
    
    static var oneVerticalLineWithoutArrow: CGFloat {
        (self.itemHeight - self.arrowTerminalHeight)/2
    }
    
    static let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    static let arrowTerminalHeight = ComponentSettingValues.arrowTerminalHeight
    
    static let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    static let textLeadingPadding = ComponentSettingValues.textLeadingPadding
    static let textTrailPadding = ComponentSettingValues.textTrailPadding
}
