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
    case variableDeclSyntax // 変数の宣言
    case protocolDeclSyntax // プロトコルの宣言
    case codeBlockSyntax // メソッドの中身など
    case declModifierSyntax // アクセスレベル
}
