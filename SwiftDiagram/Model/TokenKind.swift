//
//  TokenKind.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/18.
//

import Foundation

// visit()で検査するtoken.tokenKind
enum TokenKind {
    case identifier // identifier
    case structKeyword // struct
    case varKeyword // var
    
    // アクセスレベル
    case openKeyword // open
    case publicKeyword // public
    case internalKeyword // internal
    case fileprivateKeyword // fileprivate
    case privateKeyword // private
    
    case atSign // @
    case colon // :
    case lazy // identifier("lazy")
    case letKeyword // variableのletキーワード
    
    var string: String {
        switch self {
        case .identifier:
            return "identifier"
        case .structKeyword:
            return "structKeyword"
        case .varKeyword:
            return "varKeyword"
        case .openKeyword:
            return "openKeyword"
        case .publicKeyword:
            return "publicKeyword"
        case .internalKeyword:
            return "internalKeyword"
        case .fileprivateKeyword:
            return "fileprivateKeyword"
        case .privateKeyword:
            return "privateKeyword"
        case .atSign:
            return "atSign"
        case .colon:
            return "colon"
        case .lazy:
            return "identifier(\"lazy\")"
        case .letKeyword:
            return "letKeyword"
        }
    }
}
