//
//  HaveAccessLevelHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

protocol HaveAccessLevelHolder {
    var accessLevel: AccessLevel { get set }
}

extension HaveAccessLevelHolder {
    var accessLevel: AccessLevel {
        return .internal
    }
}
