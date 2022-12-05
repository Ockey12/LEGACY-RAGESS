//
//  HaveAccessLevelHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

protocol HaveAccessLevelHolder: Holder {
    var name: String { get set }
    var accessLevel: AccessLevel { get set }
}

extension HaveAccessLevelHolder {
    var accessLevel: AccessLevel {
        return .internal
    }
}
