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
    private var syntaxNodeTypeStack = [SyntaxNodeType]()
    // 抽象構文木をvisitして抽出した結果の配列
    private var resultArray = [String]()
    
    // variableの@Stateなどの文字列を一時的に保存する
    // @Stateの場合、@とStateが別のtokenなため
    private var variableCustomAttribute = ""
    
    override func visitPre(_ node: Syntax) {
        let currentSyntaxNodeType = "\(node.syntaxNodeType)"
        
        if currentSyntaxNodeType == SyntaxNodeType.structDeclSyntax.string {
            // structの宣言開始
            resultArray.append(SyntaxTag.startStructDeclSyntax.string)
            pushSyntaxNodeTypeStack(SyntaxNodeType.structDeclSyntax)
            printSyntaxNodeTypeStack()
        } else if currentSyntaxNodeType == SyntaxNodeType.variableDeclSyntax.string {
            // variableの宣言開始
            resultArray.append(SyntaxTag.startVariableDeclSyntax.string)
            pushSyntaxNodeTypeStack(SyntaxNodeType.variableDeclSyntax)
            printSyntaxNodeTypeStack()
        } else if currentSyntaxNodeType == SyntaxNodeType.customAttributeSyntax.string {
            // variableの@Stateなどの宣言開始
            variableCustomAttribute = ""
            pushSyntaxNodeTypeStack(SyntaxNodeType.customAttributeSyntax)
            printSyntaxNodeTypeStack()
        } else if currentSyntaxNodeType == SyntaxNodeType.inheritedTypeListSyntax.string {
            // プロトコルへの準拠開始
            pushSyntaxNodeTypeStack(SyntaxNodeType.inheritedTypeListSyntax)
            printSyntaxNodeTypeStack()
        }
    }
    
    override func visit(_ token: TokenSyntax) -> Syntax {
        let tokenKind = "\(token.tokenKind)"
        
        if 0 < syntaxNodeTypeStack.count {
            if tokenKind == TokenKind.openKeyword.string {
                // アクセスレベルopenを見つけたとき
                addAccessLevelToResultArray(accessLevel: .open)
            } else if tokenKind == TokenKind.publicKeyword.string {
                // アクセスレベルpublicを見つけたとき
                addAccessLevelToResultArray(accessLevel: .public)
            } else if tokenKind == TokenKind.internalKeyword.string {
                // アクセスレベルinternalを見つけたとき
                addAccessLevelToResultArray(accessLevel: .internal)
            } else if tokenKind == TokenKind.fileprivateKeyword.string {
                // アクセスレベルfileprivateを見つけたとき
                addAccessLevelToResultArray(accessLevel: .fileprivate)
            } else if tokenKind == TokenKind.privateKeyword.string {
                // アクセスレベルprivateを見つけたとき
                addAccessLevelToResultArray(accessLevel: .private)
            } else if (syntaxNodeTypeStack.last! == SyntaxNodeType.structDeclSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // structの名前を宣言しているとき
                resultArray.append(SyntaxTag.structName.string + SyntaxTag.space.string + token.text)
            } else if (syntaxNodeTypeStack.last! == SyntaxNodeType.inheritedTypeListSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // 準拠しているプロトコルの名前を宣言しているとき
                addConformedProtocolName(protocolName: token.text)
            } else if syntaxNodeTypeStack.last! == SyntaxNodeType.customAttributeSyntax {
                // variableで@Stateなどを宣言しているとき
                variableCustomAttribute += token.text
            } else if (syntaxNodeTypeStack.last! == SyntaxNodeType.variableDeclSyntax) &&
                        tokenKind == TokenKind.lazy.string {
                // variableのlazyキーワードを見つけたとき
                resultArray.append(SyntaxTag.lazyVariable.string)
            } else if tokenKind == TokenKind.letKeyword.string {
                // variableのletキーワードを見つけたとき
                resultArray.append(SyntaxTag.haveLetKeyword.string)
            }
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
        } else if currentSyntaxNodeType == SyntaxNodeType.variableDeclSyntax.string {
            // variableの宣言終了
            resultArray.append(SyntaxTag.endVariableDeclSyntax.string)
            popSyntaxNodeTypeStack()
            printSyntaxNodeTypeStack()
        } else if currentSyntaxNodeType == SyntaxNodeType.customAttributeSyntax.string {
            // variableの@Stateなどの宣言終了
            resultArray.append(SyntaxTag.variableCustomAttribute.string + SyntaxTag.space.string + variableCustomAttribute)
            popSyntaxNodeTypeStack()
            printSyntaxNodeTypeStack()
        } else if currentSyntaxNodeType == SyntaxNodeType.inheritedTypeListSyntax.string {
            // プロトコルへの準拠終了
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
    func getSyntaxNodeTypeStack() -> [SyntaxNodeType] {
        return syntaxNodeTypeStack
    }
    
    // syntaxStack配列に引数の文字列をプッシュする
    private func pushSyntaxNodeTypeStack(_ element: SyntaxNodeType) {
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
        if syntaxNodeTypeStack.last! == SyntaxNodeType.structDeclSyntax {
            resultArray.append(SyntaxTag.structAccessLevel.string + SyntaxTag.space.string + accessLevel)
        } else if syntaxNodeTypeStack.last! == SyntaxNodeType.variableDeclSyntax {
            resultArray.append(SyntaxTag.variableAccessLevel.string + SyntaxTag.space.string + accessLevel)
        }
    }
    
    // syntaxNodeTypeStackに応じて、準拠しているもの(struct, class, ...)とプロトコルの名前のタグをresultArrayに追加する
    private func addConformedProtocolName(protocolName: String) {
        let lastIndex = syntaxNodeTypeStack.endIndex - 1 // .endIndexは要素数を返すため、-1すると最後のインデックスになる
        
        if syntaxNodeTypeStack[lastIndex - 1] == SyntaxNodeType.structDeclSyntax {
            resultArray.append(SyntaxTag.protocolConformedByStruct.string + SyntaxTag.space.string + protocolName)
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
