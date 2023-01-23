//
//  AccessControllable.swift
//  RUISS
//
//  Created by オナガ・ハルキ on 2023/01/24.
//

import Foundation

protocol AccessControllable {
    var accessLevel: AccessLevel { get set }
}

extension AccessControllable {
    var accessLevel: AccessLevel {
        return .internal
    }
}
