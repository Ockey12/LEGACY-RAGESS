//
//  SyntaxNodeType.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/18.
//

import Foundation

// visitPre()、visitPost()で検査するnode.syntaxNodeType
enum SyntaxNodeType {
    case declSyntax // 宣言のsyntaxNodeTypeの末尾に共通しているキーワード
    case structDeclSyntax // structの宣言
    case variableDeclSyntax // variableの宣言
    case customAttributeSyntax // variableの@ Stateなど
    case identifierPatternSyntax // variableの名前
    case typeAnnotationSyntax // variableの型
    case initializerClauseSyntax // variableの初期値
    case protocolDeclSyntax // プロトコルの宣言
    case inheritedTypeListSyntax // プロトコルへの準拠
    case codeBlockSyntax // メソッドの中身など
//    case declModifierSyntax // アクセスレベル そのまま抽出できるから考慮しなくて良い？
    
    var string: String {
        switch self {
        case .declSyntax:
            return "DeclSyntax"
        case .structDeclSyntax:
            return "StructDeclSyntax"
        case .variableDeclSyntax:
            return "VariableDeclSyntax"
        case .customAttributeSyntax:
            return "CustomAttributeSyntax"
        case .identifierPatternSyntax:
            return "IdentifierPatternSyntax"
        case .typeAnnotationSyntax:
            return "TypeAnnotationSyntax"
        case .initializerClauseSyntax:
            return "InitializerClauseSyntax"
        case .protocolDeclSyntax:
            return "ProtocolDeclSyntax"
        case .inheritedTypeListSyntax:
            return "InheritedTypeListSyntax"
        case .codeBlockSyntax:
            return "CodeBlockSyntax"
        }
    }
}
