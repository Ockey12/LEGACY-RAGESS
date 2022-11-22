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
    case staticVariable // staticキーワードを持つvariable
    case lazyVariable // lazyキーワードをもつvariable
    case variableAccessLevel // 変数のアクセスレベル
    case haveLetKeyword // 定数のとき
    case variableName // 変数の名前を後ろに持つ
    case variableType // variableの型
    case initialValueOfVariable // variableの初期値
    case haveWillSet // willSetを持つvariable
    case haveDidSet // didSetを持つvariable
    case endVariableDeclSyntax // 変数の宣言終了

    // アクセスレベル
    case open
    case `public`
    case `internal`
    case `fileprivate`
    case `private`
    
    case space // タグとタグの間のスペース
    
    var string: String {
        switch self {
        // struct
        case .startStructDeclSyntax:
            return "StartStructDeclSyntax"
        case .structAccessLevel:
            return "StructAccessLevel"
        case .structName:
            return "StructName"
        case .endStructDeclSyntax:
            return "EndStructDeclSyntax"
        // プロトコルへの準拠
        case .startInheritedTypeListSyntax:
            return "StartInheritedTypeListSyntax"
        case .protocolConformedByStruct:
            return "ProtocolConformedByStruct"
        case .endInheritedTypeListSyntax:
            return "EndInheritedTypeListSyntax"
        // variable
        case .startVariableDeclSyntax:
            return "StartVariableDeclSyntax"
        case .variableCustomAttribute:
            return "VariableCustomAttribute"
        case .staticVariable:
            return "StaticVariable"
        case .lazyVariable:
            return "LazyVariable"
        case .variableAccessLevel:
            return "VariableAccessLevel"
        case .haveLetKeyword:
            return "HaveLetKeyword"
        case .variableName:
            return "VariableName"
        case .variableType:
            return "VariableType"
        case .initialValueOfVariable:
            return "InitialValueOfVariable"
        case .haveWillSet:
            return "HaveWillSet"
        case .haveDidSet:
            return "HaveDidSet"
        case .endVariableDeclSyntax:
            return "EndVariableDeclSyntax"
        // アクセスレベル
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
