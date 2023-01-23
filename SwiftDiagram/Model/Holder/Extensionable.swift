//
//  Extensionable.swift
//  RUISS
//
//  Created by オナガ・ハルキ on 2023/01/24.
//

import Foundation

protocol Extensionable {
    // 拡張
    var extensions: [ExtensionHolder] { get set }
}
