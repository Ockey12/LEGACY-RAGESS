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
    // syntaxNodeTypeStackに最後に追加された要素のインデックス
    // pushSyntaxNodeTypeStack()で1増える
    // popSyntaxNodeTypeStack()で1減る
    private var currentPositionInStack = -1
    
    // 抽象構文木をvisitして抽出した結果の配列
    private var resultArray = [String]()
    
    // variableの@Stateなどの文字列を一時的に保存する
    // @Stateの場合、@とStateが別のtokenなため
    // visitPre()で""に初期化する
    private var variableCustomAttribute = ""
    
    // variableのTypeAnnotationSyntax内で最初の":"を検査した後trueになる
    // variable名と型を区切る":"と、辞書やタプル中の":"を区別するために使う
    // visitPre()でfalseに初期化する
    private var passedTypeAnnotationFirstColonFlag = false
    
    // TypeAnnotation内で抽出したvariableの型を文字列として一時的に保持する
    // visitPre()で""に初期化する
    // visitPost()でresultArrayに.append()する
    private var variableTypeString = ""
    
    // variableの初期値を文字列として一時的に保持する
    // visitPre()で""に初期化する
    // visitPost()でresultArrayに.append()する
    private var initialValueOfVariable = ""
    
    // functionの引数1つの外部引数名と内部引数名を文字列として一時的に保持する
    // visitPre()で[]に初期化する
    // visit()でFunctionParameterSyntax内の最初の":"を検査したとき、この配列の要素をresultArrayにタグとともに.append()する
    private var functionParameterNames = [String]()
    
    // FunctionParameterSyntax内で最初の":"を検査した後trueになる
    // 引数名と型を区切る":"と、辞書やタプル中の":"を区別するために使う
    // visitPre()でfalseに初期化する
    private var passedFunctionParameterFirstColonFlag = false
    
    // FunctionParameterSyntax内で引数の型を文字列として一時的に保持する
    // visitPre()で""に初期化する
    // visitPost()でresultArrayに.append()する
    private var functionParameterTypeString = ""
    
    // デフォルト引数のデフォルト値を文字列として一時的に保持する
    // visitPre()で""に初期化する
    private var initialValueOfParameter = ""
    
    
    override func visitPre(_ node: Syntax) {
        let currentSyntaxNodeType = "\(node.syntaxNodeType)"
        print("PRE-> \(currentSyntaxNodeType)")
        
        if (1 < currentPositionInStack) &&
            (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.codeBlockSyntax) {
            // CodeBlockSyntax内の情報は無視する
        } else {
            if currentSyntaxNodeType == SyntaxNodeType.structDeclSyntax.string {
                // structの宣言開始
                resultArray.append(SyntaxTag.startStructDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.structDeclSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.classDeclSyntax.string {
                // classの宣言開始
                resultArray.append(SyntaxTag.startClassDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.classDeclSyntax)
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
            } else if currentSyntaxNodeType == SyntaxNodeType.identifierPatternSyntax.string {
                // variableの名前を宣言開始
                pushSyntaxNodeTypeStack(SyntaxNodeType.identifierPatternSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.typeAnnotationSyntax.string {
                // variableの型を宣言開始
                passedTypeAnnotationFirstColonFlag = false
                variableTypeString = ""
                pushSyntaxNodeTypeStack(SyntaxNodeType.typeAnnotationSyntax)
                printSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.variableDeclSyntax) {
                // variableの初期値を宣言開始
                initialValueOfVariable = ""
                pushSyntaxNodeTypeStack(SyntaxNodeType.initializerClauseSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.accessorBlockSyntax.string {
                // variableのwillSet, didSet, get, setを宣言するブロック開始
                pushSyntaxNodeTypeStack(SyntaxNodeType.accessorBlockSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.functionDeclSyntax.string {
                // functionの宣言開始
                resultArray.append(SyntaxTag.startFunctionDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.functionDeclSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.functionParameterSyntax.string {
                // functionの引数1つを宣言開始
                functionParameterNames.removeAll()
                passedFunctionParameterFirstColonFlag = false
                functionParameterTypeString = ""
                resultArray.append(SyntaxTag.startFunctionParameterSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.functionParameterSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.codeBlockSyntax.string {
                // functionのCodeBlock宣言開始
                pushSyntaxNodeTypeStack(SyntaxNodeType.codeBlockSyntax)
                printSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) {
                // デフォルト引数のデフォルト値を宣言開始
                initialValueOfParameter = ""
                pushSyntaxNodeTypeStack(SyntaxNodeType.initializerClauseSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.inheritedTypeListSyntax.string {
                // プロトコルへの準拠、またはクラスの継承開始
                pushSyntaxNodeTypeStack(SyntaxNodeType.inheritedTypeListSyntax)
                printSyntaxNodeTypeStack()
            }
        }
    }
    
    override func visit(_ token: TokenSyntax) -> Syntax {
        let tokenKind = "\(token.tokenKind)"
        
        if (1 < currentPositionInStack) &&
            (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.codeBlockSyntax) {
            // CodeBlockSyntax内の情報は無視する
            return token._syntaxNode
        }
        
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
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.structDeclSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // structの名前を宣言しているとき
                resultArray.append(SyntaxTag.structName.string + SyntaxTag.space.string + token.text)
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.inheritedTypeListSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // 準拠しているプロトコルの名前を宣言しているとき
                addConformedProtocolName(protocolName: token.text)
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.customAttributeSyntax {
                // variableで@Stateなどを宣言しているとき
                variableCustomAttribute += token.text
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.variableDeclSyntax) &&
                        tokenKind == TokenKind.lazy.string {
                // variableのlazyキーワードを見つけたとき
                resultArray.append(SyntaxTag.lazyVariable.string)
            } else if tokenKind == TokenKind.letKeyword.string {
                // variableのletキーワードを見つけたとき
                resultArray.append(SyntaxTag.haveLetKeyword.string)
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.identifierPatternSyntax {
                // variableの名前を見つけたとき
                resultArray.append(SyntaxTag.variableName.string + SyntaxTag.space.string + token.text)
            } else if tokenKind == TokenKind.staticKeyword.string {
                // staticキーワードを見つけたとき
                // variableとfunctionを区別する
                if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.variableDeclSyntax {
                    // variableの宣言中のとき
                    resultArray.append(SyntaxTag.staticVariable.string)
                }
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.typeAnnotationSyntax {
                // variableの型を宣言しているとき
                if tokenKind == TokenKind.colon.string {
                    // ":"のとき
                    if passedTypeAnnotationFirstColonFlag {
                        // TypeAnnotation内で最初の":"でなければ、型名内の文字列として抽出する
                        variableTypeString += ":"
                    } else {
                        // TypeAnnotation内で最初の":"なら、variable名と型を区切るものなので抽出しない
                        passedTypeAnnotationFirstColonFlag = true
                    }
                } else {
                    // ":"でなければ抽出する
                    variableTypeString += token.text
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.initializerClauseSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.variableDeclSyntax) {
                // variableの初期値を宣言しているとき
                if tokenKind != TokenKind.equal.string {
                    // 初期値を代入する"="以外を抽出する
                    initialValueOfVariable += token.text
                }
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.accessorBlockSyntax {
                // variableのwillSet, didSet, get, setを宣言しているとき
                if tokenKind == TokenKind.willSetKeyword.string {
                    // willSetのとき
                    resultArray.append(SyntaxTag.haveWillSet.string)
                } else if tokenKind == TokenKind.didSetKeyword.string {
                    // didSetのとき
                    resultArray.append(SyntaxTag.haveDidSet.string)
                } else if tokenKind == TokenKind.getKeyword.string {
                    // getのとき
                    resultArray.append(SyntaxTag.haveGetter.string)
                } else if tokenKind == TokenKind.setKeyword.string {
                    // setのとき
                    resultArray.append(SyntaxTag.haveSetter.string)
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionDeclSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // functionの名前を宣言しているとき
                resultArray.append(SyntaxTag.functionName.string + SyntaxTag.space.string + token.text)
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                        (!passedFunctionParameterFirstColonFlag) {
                // FunctionParameterSyntax内でまだ最初の":"を検査していないとき
                // 外部引数名、内部引数名、最初の":"が検査される
                if tokenKind == TokenKind.colon.string {
                    // 最初の":"なのでpassedFunctionParameterFirstColonFlagをtrueにする
                    passedFunctionParameterFirstColonFlag = true
                    // 引数名を抽出し終えているので、functionParameterNamesの要素をresultArrayに.append()する
                    if functionParameterNames.count == 1 {
                        // functionParameterNamesの要素が1つのとき、この引数は内部引数名を持ち、外部引数名を持たない
                        resultArray.append(SyntaxTag.internalParameterName.string + SyntaxTag.space.string + functionParameterNames[0])
                    } else if functionParameterNames.count == 2 {
                        // functionParameterNamesの要素が2つのとき、この引数は外部引数名と内部引数名を持つ
                        // 外部引数名
                        resultArray.append(SyntaxTag.externalParameterName.string + SyntaxTag.space.string + functionParameterNames[0])
                        // 内部引数名
                        resultArray.append(SyntaxTag.internalParameterName.string + SyntaxTag.space.string + functionParameterNames[1])
                    }
                } else {
                    // 外部引数名または内部引数名を一時的に保持する
                    functionParameterNames.append(token.text)
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                        (passedFunctionParameterFirstColonFlag) {
                // FunctionParameterSyntax内で既に最初の":"を検査した後
                if tokenKind == TokenKind.inoutKeyword.string {
                    // inoutキーワードのとき
                    resultArray.append(SyntaxTag.haveInoutKeyword.string)
                } else if tokenKind == TokenKind.ellipsis.string {
                    // "..."のとき、可変長引数
                    resultArray.append(SyntaxTag.isVariadicParameter.string)
                } else {
                    functionParameterTypeString += token.text
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.initializerClauseSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) {
                // functionのデフォルト引数のデフォルト値を宣言しているとき
                if tokenKind != TokenKind.equal.string {
                    // 初期値を代入する"="以外を抽出する
                    initialValueOfParameter += token.text
                }
            }
        }
        
        return token._syntaxNode
    }
    
    override func visitPost(_ node: Syntax) {
        let currentSyntaxNodeType = "\(node.syntaxNodeType)"
        print("POST<- \(currentSyntaxNodeType)")
        
        if (1 < currentPositionInStack) &&
            (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.codeBlockSyntax) {
            // CodeBlockSyntax内の情報は、CodeBlockSyntaxを抜けること以外は無視する
            if currentSyntaxNodeType == SyntaxNodeType.codeBlockSyntax.string {
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            }
        } else {
            if currentSyntaxNodeType == SyntaxNodeType.structDeclSyntax.string {
                // structの宣言終了
                resultArray.append(SyntaxTag.endStructDeclSyntax.string)
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.classDeclSyntax.string {
                // classの宣言終了
                resultArray.append(SyntaxTag.endClassDeclSyntax.string)
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
            } else if currentSyntaxNodeType == SyntaxNodeType.identifierPatternSyntax.string {
                // variableの名前を宣言終了
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.typeAnnotationSyntax.string {
                // variableの型を宣言終了
                resultArray.append(SyntaxTag.variableType.string + SyntaxTag.space.string + variableTypeString)
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.variableDeclSyntax) {
                // variableの初期値を宣言終了
                resultArray.append(SyntaxTag.initialValueOfVariable.string + SyntaxTag.space.string + initialValueOfVariable)
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.accessorBlockSyntax.string {
                // variableのwillSet, didSet, get, setを宣言するブロック終了
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.functionDeclSyntax.string {
                // functionの宣言終了
                resultArray.append(SyntaxTag.endFunctionDeclSyntax.string)
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.functionParameterSyntax.string {
                // functionの引数1つを宣言終了
                if functionParameterTypeString.last == "," {
                    // functionが引数を複数持つとき、最後の引数以外は型の末尾に","がついてしまうので、取り除く
                    functionParameterTypeString = String(functionParameterTypeString.dropLast())
                }
                resultArray.append(SyntaxTag.parameterType.string + SyntaxTag.space.string + functionParameterTypeString)
                resultArray.append(SyntaxTag.endFunctionParameterSyntax.string)
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) {
                // デフォルト引数のデフォルト値を宣言終了
                resultArray.append(SyntaxTag.initialValueOfParameter.string + SyntaxTag.space.string + initialValueOfParameter)
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.inheritedTypeListSyntax.string {
                // プロトコルへの準拠、またはクラスの継承終了
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            }
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
        currentPositionInStack += 1
    }
    
    // syntaxStack配列の最後の要素を削除し、ポップする
    private func popSyntaxNodeTypeStack() {
        self.syntaxNodeTypeStack.removeLast()
        currentPositionInStack -= 1
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
        if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.structDeclSyntax {
            // structのアクセスレベル
            resultArray.append(SyntaxTag.structAccessLevel.string + SyntaxTag.space.string + accessLevel)
        } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.variableDeclSyntax {
            // variableのアクセスレベル
            resultArray.append(SyntaxTag.variableAccessLevel.string + SyntaxTag.space.string + accessLevel)
        } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionDeclSyntax {
            // functionのアクセスレベル
            resultArray.append(SyntaxTag.functionAccessLevel.string + SyntaxTag.space.string + accessLevel)
        }
    }
    
    // syntaxNodeTypeStackに応じて、準拠しているもの(struct, class, ...)とプロトコルの名前のタグをresultArrayに追加する
    private func addConformedProtocolName(protocolName: String) {
//        let lastIndex = syntaxNodeTypeStack.endIndex - 1 // .endIndexは要素数を返すため、-1すると最後のインデックスになる
        
        if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.structDeclSyntax {
            // structの宣言中のとき
            resultArray.append(SyntaxTag.conformedProtocolByStruct.string + SyntaxTag.space.string + protocolName)
        } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.classDeclSyntax {
            // classの宣言中のとき
            // 継承とプロトコルへの準拠のどちらか判別できない
            resultArray.append(SyntaxTag.conformedProtocolOrInheritedClassByClass.string + SyntaxTag.space.string + protocolName)
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
