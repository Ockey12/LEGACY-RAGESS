//
//  TokenVisitor.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/20.
//

import Foundation
import SwiftSyntax

final class TokenVisitor: SyntaxRewriter {
    
    // visitPre()、visitPost()で検査したnodeの種類を記憶するためのスタック配列
    private var syntaxNodeTypeStack = [String]()
    // 抽象構文木をvisitして抽出した結果の配列
    private var resultArray = [String]()
    
    override func visitPre(_ node: Syntax) {
        let currentSyntaxNodeType = "\(node.syntaxNodeType)"
        
        if currentSyntaxNodeType == SyntaxNodeType.structDeclSyntax.string {
            // structの宣言開始
            resultArray.append(SyntaxTag.startStructDeclSyntax.string)
            pushSyntaxNodeTypeStack(SyntaxNodeType.structDeclSyntax.string)
            printSyntaxNodeTypeStack()
        }
    }
    
    override func visit(_ token: TokenSyntax) -> Syntax {
        let tokenKind = "\(token.tokenKind)"
        
        if tokenKind == TokenKind.openKeyword.string {
            addAccessLevelToResultArray(accessLevel: .open)
        } else if tokenKind == TokenKind.publicKeyword.string {
            addAccessLevelToResultArray(accessLevel: .public)
        } else if tokenKind == TokenKind.internalKeyword.string {
            addAccessLevelToResultArray(accessLevel: .internal)
        } else if tokenKind == TokenKind.fileprivateKeyword.string {
            addAccessLevelToResultArray(accessLevel: .fileprivate)
        } else if tokenKind == TokenKind.privateKeyword.string {
            addAccessLevelToResultArray(accessLevel: .private)
        }
        
        return token._syntaxNode
    }
    
    override func visitPost(_ node: Syntax) {
        let currentSyntaxNodeType = "\(node.syntaxNodeType)"
        
        if currentSyntaxNodeType == SyntaxNodeType.structDeclSyntax.string {
            // structの宣言終了
            resultArray.append(SyntaxTag.endStructDeclSyntax.string)
            popSyntaxNodeTypeStack()
            printSyntaxNodeTypeStack()
        }
    }
    
    // 抽象構文木をvisitして抽出した結果の配列syntaxArrayを返す
    func getResultArray() -> [String] {
        return resultArray
    }
    
    // デバッグ用
    // syntaxNodeTypeStackを返す
    func getSyntaxNodeTypeStack() -> [String] {
        return syntaxNodeTypeStack
    }
    
    // syntaxStack配列に引数の文字列をプッシュする
    private func pushSyntaxNodeTypeStack(_ element: String) {
        self.syntaxNodeTypeStack.append(element)
    }
    
    // syntaxStack配列の最後の要素を削除し、ポップする
    private func popSyntaxNodeTypeStack() {
        self.syntaxNodeTypeStack.removeLast()
    }
    
//    private enum AccessLevelHolder {
//        case `struct`
//        case `class`
//        case `enum`
//        case `var`
//        case `func`
//    }
    
    // addAccessLevelToResultArrayDependOnType()を呼び出して、resultArrayにアクセスレベルのタグを追加する
    private func addAccessLevelToResultArray(accessLevel: AccessLevel) {
        switch accessLevel {
        case .open:
            addAccessLevelToResultArrayDependOnType(accessLevel: SyntaxTag.open.string)
        case .public:
            addAccessLevelToResultArrayDependOnType(accessLevel: SyntaxTag.public.string)
        case .internal:
            addAccessLevelToResultArrayDependOnType(accessLevel: SyntaxTag.internal.string)
        case .fileprivate:
            addAccessLevelToResultArrayDependOnType(accessLevel: SyntaxTag.fileprivate.string)
        case .private:
            addAccessLevelToResultArrayDependOnType(accessLevel: SyntaxTag.private.string)
        }
    }
    
    // syntaxNodeTypeStackに応じて、アクセスレベルの持ち主とアクセスレベルのタグをresultArrayに追加する
    // addAccessLevelToResultArray()で呼び出される
    private func addAccessLevelToResultArrayDependOnType(accessLevel: String) {
        if syntaxNodeTypeStack.last! == SyntaxNodeType.structDeclSyntax.string {
            resultArray.append(SyntaxTag.structAccessLevel.string + " " + accessLevel)
        }
    }
    
    // syntaxNodeTypeStackの全要素をprint()する
    private func printSyntaxNodeTypeStack() {
        print("-----SyntaxNodeTypeStack-----")
        for element in self.syntaxNodeTypeStack {
            print(element)
        }
        print("-----------------------------\n")
    }
}
