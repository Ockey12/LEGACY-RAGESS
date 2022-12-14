//
//  ComponentSettingValues.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/14.
//

import Foundation

struct ComponentSettingValues {
    static let fontSize: CGFloat = 50
    static let itemHeight: CGFloat = 90
    static let borderWidth: CGFloat = 5
    
    static let connectionWidth: CGFloat = 350
    static let connectionHeight: CGFloat = 90
    
    static let arrowTerminalWidth: CGFloat = 15
    static let arrowTerminalHeight: CGFloat = 30
    static var oneVerticalLineWithoutArrow: CGFloat {
        (self.itemHeight - self.arrowTerminalHeight)/2
    }
    
    static let bottomPaddingForLastText: CGFloat = 30
    static let textLeadingPadding: CGFloat = 30
    static let textTrailPadding: CGFloat = 100
    
    // HeaderComponent
    static let indexWidth: CGFloat = 300
}
