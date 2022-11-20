//
//  SyntaxTag.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/18.
//

import Foundation

// TokenVisitorクラスでresultArray配列に格納するタグ
enum SyntaxTag {
    case startStructDeclSyntax // structの宣言開始
    case structAccessLevel // structのアクセスレベル
    case structName // structの名前
    case endStructDeclSyntax // structの宣言終了
    case startVariableDeclSyntax // 変数の宣言開始
//    case variableAccessLevel // 変数のアクセスレベル
    case endVariableDeclSyntax // 変数の宣言終了
    case space // タグとタグの間のスペース
    
    // アクセスレベル
    case open
    case `public`
    case `internal`
    case `fileprivate`
    case `private`
    
    var string: String {
        switch self {
        case .startStructDeclSyntax:
            return "StartStructDeclSyntax"
        case .structAccessLevel:
            return "StructAccessLevel"
        case .structName:
            return "StructName"
        case .endStructDeclSyntax:
            return "EndStructDeclSyntax"
        case .startVariableDeclSyntax:
            return "StartVariableDeclSyntax"
        case .endVariableDeclSyntax:
            return "EndVariableDeclSyntax"
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
        case .space:
            return " "
        }
    }
}
