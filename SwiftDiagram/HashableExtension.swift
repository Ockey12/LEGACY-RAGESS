//
//  HashableExtension.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/29.
//

import Foundation

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
