//
//  AccessLevel.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/19.
//

import Foundation

enum AccessLevel: String {
    case `open`
    case `public`
    case `internal`
    case `fileprivate`
    case `private`
    
    var string: String {
        switch self {
        case .open:
            return "open"
        case .public:
            return "public"
        case .internal:
            return "internal"
        case .fileprivate:
            return "fileprivate"
        case .private:
            return "private"
        }
    }
    
    var icon: String {
        switch self {
        case .open:
            return "○"
        case .public:
            return "●"
        case .internal:
            return ""
        case .fileprivate:
            return "△"
        case .private:
            return "▲"
        }
    }
}
