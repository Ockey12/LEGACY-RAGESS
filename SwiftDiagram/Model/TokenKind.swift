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
    
    // variable
    case lazy // identifier("lazy")
    case letKeyword // variableのletキーワード
    case willSetKeyword // variableのwillSetキーワード
    case didSetKeyword // variableのdidSetキーワード
    case getKeyword // variableのgetキーワード
    case setKeyword // variableのsetキーワード
    
    // function
    case inoutKeyword // functionの引数のinoutキーワード
    
    case atSign // @
    case colon // :
    case comma // ,
    case staticKeyword // staticキーワード variableとfunctionが持つ
    case equal // 代入などの"="
    case ellipsis // "..."
    case leftParen // "("
    case rightParen // ")"
    
    var string: String {
        switch self {
        case .identifier:
            return "identifier"
        case .structKeyword:
            return "structKeyword"
        case .varKeyword:
            return "varKeyword"
        // アクセスレベル
        case .openKeyword:
            return "identifier(\"open\")"
        case .publicKeyword:
            return "publicKeyword"
        case .internalKeyword:
            return "internalKeyword"
        case .fileprivateKeyword:
            return "fileprivateKeyword"
        case .privateKeyword:
            return "privateKeyword"
        // variable
        case .lazy:
            return "identifier(\"lazy\")"
        case .letKeyword:
            return "letKeyword"
        case .willSetKeyword:
            return "contextualKeyword(\"willSet\")"
        case .didSetKeyword:
            return "contextualKeyword(\"didSet\")"
        case .getKeyword:
            return "contextualKeyword(\"get\")"
        case .setKeyword:
            return "contextualKeyword(\"set\")"
        // function
        case .inoutKeyword:
            return "inoutKeyword"
            
        case .atSign:
            return "atSign"
        case .colon:
            return "colon"
        case .comma:
            return "comma"
        case .staticKeyword:
            return "staticKeyword"
        case .equal:
            return "equal"
        case .ellipsis:
            return "ellipsis"
        case .leftParen:
            return "leftParen"
        case .rightParen:
            return "rightParen"
        }
    }
}
