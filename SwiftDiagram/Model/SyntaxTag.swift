//
//  SyntaxTag.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/18.
//

import Foundation

// TokenVisitorクラスでresultArray配列に格納するタグ
enum SyntaxTag {
    // struct
    case startStructDeclSyntax // structの宣言開始
    case structAccessLevel // structのアクセスレベル
    case structName // structの名前
    case endStructDeclSyntax // structの宣言終了
    
    // プロトコルへの準拠
    case startInheritedTypeListSyntax // プロトコルへの準拠開始
    case protocolConformedByStruct // structが準拠しているプロトコル
    case endInheritedTypeListSyntax // プロトコルへの準拠終了
    
    //variable
    case startVariableDeclSyntax // 変数の宣言開始
//    case startCustomAttributeSyntax // @Stateなどの宣言開始
//    case endCustomAttributeSyntax // @Stateなどの宣言終了
    case variableCustomAttribute // 後ろに@Stateなどの名前を持つ
    case lazyVariable // lazyキーワードをもつvariable
    case variableAccessLevel // 変数のアクセスレベル
    case letVariable // 定数
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
        case .startInheritedTypeListSyntax:
            return "StartInheritedTypeListSyntax"
        case .protocolConformedByStruct:
            return "ProtocolConformedByStruct"
        case .endInheritedTypeListSyntax:
            return "EndInheritedTypeListSyntax"
        case .startVariableDeclSyntax:
            return "StartVariableDeclSyntax"
        case .variableCustomAttribute:
            return "VariableCustomAttribute"
        case .lazyVariable:
            return "LazyVariable"
        case .variableAccessLevel:
            return "VariableAccessLevel"
        case .letVariable:
            return "LetVariable"
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
