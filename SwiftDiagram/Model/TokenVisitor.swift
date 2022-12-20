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
    // getResultArray()で出力する
    private var resultArray = [String]()
    
    // enumの連想値の型を宣言しているとき、":"より後が連想値の型
    // ":"より前の文字列を抽出しないために使う
    // このフラグがtrueのときだけ型を抽出する
    // visitPre()でfalseに初期化する
    // visit()内で複数の連想値を区別する "," を検査したときもfalseに初期化する
    private var passedColonOfEnumAssociatedValueFlag = false
    
    // variableの@Stateなどの文字列を一時的に保存する
    // @Stateの場合、@とStateが別のtokenなため
    // visitPre()で""に初期化する
    private var variableCustomAttribute = ""
    
    // コンピューテッドプロパティで、getキーワードを省略したときのreturnを抽出するかを判断するために使う
    // getキーワードを検査したときにtrueにする
    // このフラグがfalseのときにreturnを検査したら、getキーワードが省略されているので、returnを抽出する
    // visitPre()でfalseに初期化する
    private var passedGetKeywordOfVariableFlag = false
    
    // variableの初期値を文字列として一時的に保持する
    // visitPre()で""に初期化する
    // visitPost()でresultArrayに.append()する
    private var initialValueOfVariable = ""
    
    // functionの引数1つの外部引数名と内部引数名を文字列として一時的に保持する
    // visitPre()で[]に初期化する
    // visit()でFunctionParameterSyntax内の最初の":"を検査したとき、この配列の要素をresultArrayにタグとともに.append()する
    private var functionParameterNames = [String]()
    
    // FunctionDeclSyntax内のFunctionParameterSyntax内で最初の":"を検査した後trueになる
    // 引数名と型を区切る":"と、辞書やタプル中の":"を区別するために使う
    // visitPre()でfalseに初期化する
    private var passedFunctionParameterOfFunctionDeclFirstColonFlag = false
    
    // functionのデフォルト引数のデフォルト値を文字列として一時的に保持する
    // visitPre()で""に初期化する
    // visit()でtoken.textを追加していく
    private var initialValueOfFunctionParameter = ""
    
    // initializerのデフォルト引数のデフォルト値を文字列として一時的に保持する
    // visitPre()で""に初期化する
    // visit()でtoken.textを追加していく
    private var initialValueOfInitializerParameter = ""
    
    // 抽出したclassの名前を格納する
    // visit()でclassの名前を.append()する
    // resultArrayを解析するとき、抽出したconformedProtocolOrInheritedClassByClassとこれの要素を比較して、一致したら継承しているクラスの名前
    // 一致しなかったら準拠しているプロトコルの名前
    // getClassNameArray()で出力する
    private var classNameArray = [String]()
    
    // enumのローバリューの基本的な型
    // addConformedProtocolName()でenumのInheritedTypeListSyntaxを抽出するとき、token.textと比較する
    // 配列の要素のどれかと一致したら、準拠しているプロトコルではなく、ローバリューの型
    private let rawvalueType = ["String", "Character", "Int", "Double", "Float"]
    
    // enumのローバリューを文字列として一時的に保持する
    // visitPre()で""に初期化する
    // visit()でtoken.textを追加していく
    private var rawvalueString = ""
    
    // InitializerDeclSyntax内のFunctionParameterSyntax内で最初の":"を検査した後trueになる
    // visit()内でtokenKindがidentifier()のとき、これがfalseなら引数名、trueなら型
    // visitPre()でfalseに初期化する
    private var passedFunctionParameterOfInitializerDeclFirstColonFlag = false
    
    // 辞書のKeyとValueを区別するために使う
    // Keyを抽出後、":"を検査したときにtrueになる
    // visit()内でtokenKindがidentifier()のとき、これがfalseならKey、trueならValue
    // visitPre()でfalseに初期化する
    private var passedColonOfDictionaryTypeSyntaxFlag = false
    
    // typealiasの連想型名と型を区別するために使う
    // 連想型を抽出後、"="を検査したときにtrueになる
    // visitPre()でfalseに初期化する
    private var passedEqualOfTypealiasDeclFlag = false
    
    // genericsの型引数と、それが準拠しているprotocolまたはスーパークラスを区別するために使う
    // ":"を検査したときにtrueになる
    // falseなら型引数、trueならprotocolまたはスーパークラス
    // visitPre()でfalseに初期化する
    private var passedColonOfGenericParameterFlag = false
    
    override func visitPre(_ node: Syntax) {
        let currentSyntaxNodeType = "\(node.syntaxNodeType)"
//        print("PRE-> \(currentSyntaxNodeType)")
        
        if (1 < currentPositionInStack) &&
            (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.codeBlockSyntax) {
            // CodeBlockSyntax内の情報は無視する
        } else {
            if currentSyntaxNodeType == SyntaxNodeType.structDeclSyntax.string {
                // structの宣言開始
                resultArray.append(SyntaxTag.StartStructDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.structDeclSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.classDeclSyntax.string {
                // classの宣言開始
                resultArray.append(SyntaxTag.StartClassDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.classDeclSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.enumDeclSyntax.string {
                // enumの宣言開始
                resultArray.append(SyntaxTag.StartEnumDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.enumDeclSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.enumCaseElementSyntax.string {
                // enumのcaseを宣言開始
                resultArray.append(SyntaxTag.StartEnumCaseElementSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.enumCaseElementSyntax)
            } else if (currentSyntaxNodeType == SyntaxNodeType.parameterClauseSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.enumCaseElementSyntax) {
                // enumのcaseの連想値の型を宣言開始
                passedColonOfEnumAssociatedValueFlag = false
                pushSyntaxNodeTypeStack(SyntaxNodeType.parameterClauseSyntax)
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.enumCaseElementSyntax) {
                // enumのローバリューを宣言開始
                rawvalueString = ""
                pushSyntaxNodeTypeStack(SyntaxNodeType.initializerClauseSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.protocolDeclSyntax.string {
                // protocolの宣言開始
                resultArray.append(SyntaxTag.StartProtocolDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.protocolDeclSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.associatedtypeDeclSyntax.string {
                // protocolの連想型の宣言開始
                resultArray.append(SyntaxTag.StartAssociatedtypeDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.associatedtypeDeclSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.variableDeclSyntax.string {
                // variableの宣言開始
                passedGetKeywordOfVariableFlag = false
                resultArray.append(SyntaxTag.StartVariableDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.variableDeclSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.customAttributeSyntax.string {
                // variableの@Stateなどの宣言開始
                variableCustomAttribute = ""
                pushSyntaxNodeTypeStack(SyntaxNodeType.customAttributeSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.identifierPatternSyntax.string {
                // variableの名前を宣言開始
                pushSyntaxNodeTypeStack(SyntaxNodeType.identifierPatternSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.typeAnnotationSyntax.string {
                // variableの型を宣言開始
                pushSyntaxNodeTypeStack(SyntaxNodeType.typeAnnotationSyntax)
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.variableDeclSyntax) {
                // variableの初期値を宣言開始
                initialValueOfVariable = ""
                pushSyntaxNodeTypeStack(SyntaxNodeType.initializerClauseSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.accessorBlockSyntax.string {
                // variableのwillSet, didSet, get, setを宣言するブロック開始
                pushSyntaxNodeTypeStack(SyntaxNodeType.accessorBlockSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.functionDeclSyntax.string {
                // functionの宣言開始
                resultArray.append(SyntaxTag.StartFunctionDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.functionDeclSyntax)
            } else if (currentSyntaxNodeType == SyntaxNodeType.functionParameterSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionDeclSyntax){
                // functionの引数1つを宣言開始
                functionParameterNames.removeAll()
                passedFunctionParameterOfFunctionDeclFirstColonFlag = false
                resultArray.append(SyntaxTag.StartFunctionParameterSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.functionParameterSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.genericParameterSyntax.string {
                // genericsの型引数の宣言開始
                passedColonOfGenericParameterFlag = false
                resultArray.append(SyntaxTag.StartGenericParameterSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.genericParameterSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.codeBlockSyntax.string {
                // function、initializer、コンピューテッドプロパティのCodeBlock宣言開始
                pushSyntaxNodeTypeStack(SyntaxNodeType.codeBlockSyntax)
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) {
                // デフォルト引数のデフォルト値を宣言開始
                initialValueOfFunctionParameter = ""
                pushSyntaxNodeTypeStack(SyntaxNodeType.initializerClauseSyntax)
            } else if (currentSyntaxNodeType == SyntaxNodeType.returnClauseSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionDeclSyntax) {
                // functionの返り値の宣言開始
                resultArray.append(SyntaxTag.StartFunctionReturnValueType.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.returnClauseSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.inheritedTypeListSyntax.string {
                // プロトコルへの準拠、またはクラスの継承、またはローバリューの型を宣言開始
                pushSyntaxNodeTypeStack(SyntaxNodeType.inheritedTypeListSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.initializerDeclSyntax.string {
                // initializerの宣言開始
                resultArray.append(SyntaxTag.StartInitializerDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.initializerDeclSyntax)
            } else if (currentSyntaxNodeType == SyntaxNodeType.functionParameterSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.initializerDeclSyntax){
                // initializerの引数1つを宣言開始
                passedFunctionParameterOfInitializerDeclFirstColonFlag = false
                initialValueOfInitializerParameter = ""
                resultArray.append(SyntaxTag.StartInitializerParameter.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.functionParameterSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.extensionDeclSyntax.string {
                // extensionの宣言開始
                resultArray.append(SyntaxTag.StartExtensionDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.extensionDeclSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.arrayTypeSyntax.string {
                // 配列の宣言開始
                if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.typeAnnotationSyntax) &&
                    (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.variableDeclSyntax) {
                    // variableの型として配列を宣言開始するとき
                    resultArray.append(SyntaxTag.StartArrayTypeSyntaxOfVariable.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの引数の型として配列を宣言開始するとき
                    resultArray.append(SyntaxTag.StartArrayTypeSyntaxOfFunctionParameter.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.returnClauseSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの返り値の型として配列を宣言開始するとき
                    resultArray.append(SyntaxTag.StartArrayTypeSyntaxOfFunctionReturnValue.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.initializerDeclSyntax) {
                    // initializerの引数の型として配列を宣言開始するとき
                    resultArray.append(SyntaxTag.StartArrayTypeSyntaxOfInitializer.string)
                } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.typealiasDeclSyntax {
                    // typealiasの型として配列を宣言開始するとき
                    resultArray.append(SyntaxTag.StartArrayTypeSyntaxOfTypealias.string)
                }
                pushSyntaxNodeTypeStack(SyntaxNodeType.arrayTypeSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.dictionaryTypeSyntax.string {
                // 辞書の宣言開始
                if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.typeAnnotationSyntax) &&
                    (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.variableDeclSyntax) {
                    // variableの型として辞書を宣言開始するとき
                    resultArray.append(SyntaxTag.StartDictionaryTypeSyntaxOfVariable.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの引数の型として辞書を宣言開始するとき
                    resultArray.append(SyntaxTag.StartDictionaryTypeSyntaxOfFunctionParameter.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.returnClauseSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの返り値の型として辞書を宣言開始するとき
                    resultArray.append(SyntaxTag.StartDictionaryTypeSyntaxOfFunctionReturnValue.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.initializerDeclSyntax) {
                    // initializerの引数の型として辞書を宣言開始するとき
                    resultArray.append(SyntaxTag.StartDictionaryTypeSyntaxOfInitializer.string)
                } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.typealiasDeclSyntax {
                    // typealiasの型として辞書を宣言開始するとき
                    resultArray.append(SyntaxTag.StartDictionaryTypeSyntaxOfTypealias.string)
                }
                passedColonOfDictionaryTypeSyntaxFlag = false
                pushSyntaxNodeTypeStack(SyntaxNodeType.dictionaryTypeSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.tupleTypeSyntax.string {
                // タプルの宣言開始
                if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.typeAnnotationSyntax) &&
                    (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.variableDeclSyntax) {
                    // variableの型としてタプルを宣言開始するとき
                    resultArray.append(SyntaxTag.StartTupleTypeSyntaxOfVariable.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの引数の型としてタプルを宣言開始するとき
                    resultArray.append(SyntaxTag.StartTupleTypeSyntaxOfFunctionParameter.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.returnClauseSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの返り値の型としてタプルを宣言開始するとき
                    resultArray.append(SyntaxTag.StartTupleTypeSyntaxOfFunctionReturnValue.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.initializerDeclSyntax) {
                    // initializerの引数の型としてタプルを宣言開始するとき
                    resultArray.append(SyntaxTag.StartTupleTypeSyntaxOfInitializer.string)
                } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.typealiasDeclSyntax {
                    // typealiasの型としてタプルを宣言開始するとき
                    resultArray.append(SyntaxTag.StartTupleTypeSyntaxOfTypealias.string)
                }
                pushSyntaxNodeTypeStack(SyntaxNodeType.tupleTypeSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.typealiasDeclSyntax.string {
                // typealiasの宣言開始
                passedEqualOfTypealiasDeclFlag = false
                resultArray.append(SyntaxTag.StartTypealiasDecl.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.typealiasDeclSyntax)
            } else if currentSyntaxNodeType == SyntaxNodeType.constrainedSugarTypeSyntax.string {
                // opaque result typeを宣言開始するとき
                pushSyntaxNodeTypeStack(SyntaxNodeType.constrainedSugarTypeSyntax)
            }
        } // if (1 < currentPositionInStack) &&
    } // func visitPre(_ node: Syntax)
    
    override func visit(_ token: TokenSyntax) -> Syntax {
//        print("      text: \(token.text)")
        let tokenKind = "\(token.tokenKind)"
        
        if (1 < currentPositionInStack) &&
            (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.codeBlockSyntax) {
            if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.variableDeclSyntax) &&
                (tokenKind == TokenKind.returnKeyword.string) &&
                (!passedGetKeywordOfVariableFlag) {
                // variableの宣言中、passedGetKeywordOfVariableFlagがfalseのときにreturnを検査したとき、それはgetキーワードを省略したコンピューテッドプロパティ
                // getキーワードを抽出したことにする
                resultArray.append(SyntaxTag.HaveGetter.string)
            }
            // CodeBlockSyntax内の情報は無視する
            return token._syntaxNode
        } // if (1 < currentPositionInStack) &&
        
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
                resultArray.append(SyntaxTag.StructName.string + SyntaxTag.Space.string + token.text)
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.classDeclSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // classの名前を宣言しているとき
                resultArray.append(SyntaxTag.ClassName.string + SyntaxTag.Space.string + token.text)
                classNameArray.append(token.text)
//                printClassNameArray()
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.enumDeclSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // enumの名前を宣言しているとき
                resultArray.append(SyntaxTag.EnumName.string + SyntaxTag.Space.string + token.text)
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.enumCaseElementSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // enumのcaseを宣言しているとき
                resultArray.append(SyntaxTag.EnumCase.string + SyntaxTag.Space.string + token.text)
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.initializerClauseSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.enumCaseElementSyntax) {
                // enumのローバリューを宣言しているとき
                if tokenKind != TokenKind.equal.string {
                    // 初期値を代入する"="以外を抽出する
                    rawvalueString += token.text
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.parameterClauseSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.enumCaseElementSyntax) {
                // enumのcaseの連想値の型を宣言しているとき
                if passedColonOfEnumAssociatedValueFlag {
                    // 既に":"を検査した後
                    if (tokenKind != TokenKind.comma.string) &&
                        (tokenKind != TokenKind.rightParen.string) {
                        resultArray.append(SyntaxTag.CaseAssociatedValue.string + SyntaxTag.Space.string + token.text)
                    } else if tokenKind == TokenKind.comma.string {
                        passedColonOfEnumAssociatedValueFlag = false
                    }
                } else {
                    // まだ":"を検査していないとき
                    if tokenKind == TokenKind.colon.string {
                        passedColonOfEnumAssociatedValueFlag = true
                    }
                }
//                if (tokenKind != TokenKind.leftParen.string) &&
//                    (tokenKind != TokenKind.comma.string) &&
//                    (tokenKind != TokenKind.rightParen.string) {
//                    // "(", commma, ")"以外を抽出する
//                    resultArray.append(SyntaxTag.CaseAssociatedValue.string + SyntaxTag.Space.string + token.text)
//                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.protocolDeclSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // protocolの名前を宣言しているとき
                resultArray.append(SyntaxTag.ProtocolName.string + SyntaxTag.Space.string + token.text)
//                printClassNameArray()
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.associatedtypeDeclSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // protocol内の連想型を宣言しているとき
                resultArray.append(SyntaxTag.AssociatedType.string + SyntaxTag.Space.string + token.text)
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
                resultArray.append(SyntaxTag.LazyVariable.string)
            } else if tokenKind == TokenKind.letKeyword.string {
                // variableのletキーワードを見つけたとき
                resultArray.append(SyntaxTag.HaveLetKeyword.string)
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.identifierPatternSyntax {
                // variableの名前を見つけたとき
                resultArray.append(SyntaxTag.VariableName.string + SyntaxTag.Space.string + token.text)
            } else if tokenKind == TokenKind.staticKeyword.string {
                // staticキーワードを見つけたとき
                // variableとfunctionを区別する
                if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.variableDeclSyntax {
                    // variableの宣言中のとき
                    resultArray.append(SyntaxTag.IsStaticVariable.string)
                } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionDeclSyntax {
                    // functionの宣言中のとき
                    resultArray.append(SyntaxTag.IsStaticFunction.string)
                }
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.typeAnnotationSyntax {
                // variableの型を宣言しているとき
                // ここでは、StringやDoubleのような、1つのtokenで表される型のみを抽出する
                // 配列や辞書は別のelse if節で抽出する
                if (tokenKind != TokenKind.colon.string) &&
                    (tokenKind != TokenKind.postfixQuestionMark.string) {
                    resultArray.append(SyntaxTag.VariableType.string + SyntaxTag.Space.string + token.text)
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
                    resultArray.append(SyntaxTag.HaveWillSet.string)
                } else if tokenKind == TokenKind.didSetKeyword.string {
                    // didSetのとき
                    resultArray.append(SyntaxTag.HaveDidSet.string)
                } else if tokenKind == TokenKind.getKeyword.string {
                    // getのとき
                    passedGetKeywordOfVariableFlag = true
                    resultArray.append(SyntaxTag.HaveGetter.string)
                } else if tokenKind == TokenKind.setKeyword.string {
                    // setのとき
                    resultArray.append(SyntaxTag.HaveSetter.string)
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionDeclSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // functionの名前を宣言しているとき
                if tokenKind == TokenKind.mutatingKeyword.string {
                    // mutatingキーワードを見つけたとき
                    resultArray.append(SyntaxTag.IsMutatingFunction.string)
                } else if tokenKind == TokenKind.overrideKeyword.string {
                    // overrideキーワードを見つけたとき
                    resultArray.append(SyntaxTag.IsOverrideFunction.string)
                }else {
                    resultArray.append(SyntaxTag.FunctionName.string + SyntaxTag.Space.string + token.text)
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) &&
                        (!passedFunctionParameterOfFunctionDeclFirstColonFlag) {
                // FunctionParameterSyntax内でまだ最初の":"を検査していないとき
                // 外部引数名、内部引数名、最初の":"が検査される
                if tokenKind == TokenKind.colon.string {
                    // 最初の":"なのでpassedFunctionParameterFirstColonFlagをtrueにする
                    passedFunctionParameterOfFunctionDeclFirstColonFlag = true
                    // 引数名を抽出し終えているので、functionParameterNamesの要素をresultArrayに.append()する
                    if functionParameterNames.count == 1 {
                        // functionParameterNamesの要素が1つのとき、この引数は内部引数名を持ち、外部引数名を持たない
                        resultArray.append(SyntaxTag.InternalParameterName.string + SyntaxTag.Space.string + functionParameterNames[0])
                    } else if functionParameterNames.count == 2 {
                        // functionParameterNamesの要素が2つのとき、この引数は外部引数名と内部引数名を持つ
                        // 外部引数名
                        resultArray.append(SyntaxTag.ExternalParameterName.string + SyntaxTag.Space.string + functionParameterNames[0])
                        // 内部引数名
                        resultArray.append(SyntaxTag.InternalParameterName.string + SyntaxTag.Space.string + functionParameterNames[1])
                    }
                } else {
                    // 外部引数名または内部引数名を一時的に保持する
                    functionParameterNames.append(token.text)
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) &&
                        (passedFunctionParameterOfFunctionDeclFirstColonFlag) {
                // FunctionParameterSyntax内で既に最初の":"を検査した後
                if tokenKind == TokenKind.inoutKeyword.string {
                    // inoutキーワードのとき
                    resultArray.append(SyntaxTag.HaveInoutKeyword.string)
                } else if tokenKind == TokenKind.ellipsis.string {
                    // "..."のとき、可変長引数
                    resultArray.append(SyntaxTag.IsVariadicParameter.string)
                } else if (tokenKind != TokenKind.comma.string) &&
                            (tokenKind != TokenKind.postfixQuestionMark.string){
                    // StringやIntのみ抽出する
                    resultArray.append(SyntaxTag.FunctionParameterType.string + SyntaxTag.Space.string + token.text)
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.initializerClauseSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax){
                // functionのデフォルト引数のデフォルト値を宣言しているとき
                if tokenKind != TokenKind.equal.string {
                    // 初期値を代入する"="以外を抽出する
                    initialValueOfFunctionParameter += token.text
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.returnClauseSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) {
                // functionの返り値の型を宣言しているとき
                if (tokenKind != TokenKind.arrow.string) &&
                    (tokenKind != TokenKind.postfixQuestionMark.string) {
                    // "->" と "?" 以外を抽出する
                    // StringやIntのみ抽出する
                    resultArray.append(SyntaxTag.FunctionReturnValueType.string + SyntaxTag.Space.string + token.text)
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.genericParameterSyntax) &&
                        (!passedColonOfGenericParameterFlag) {
                // genericsを宣言しているとき
                // まだ":"を検査していないとき
                // 型引数を抽出する
                if tokenKind == TokenKind.colon.string {
                    passedColonOfGenericParameterFlag = true
                } else {
                    resultArray.append(SyntaxTag.ParameterTypeOfGenerics.string + SyntaxTag.Space.string + token.text)
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.genericParameterSyntax) &&
                        (passedColonOfGenericParameterFlag) {
                // genericsを宣言しているとき
                // 既に":"を検査した後
                // 準拠しているprotocolまたはスーパークラスを抽出する
                if tokenKind != TokenKind.comma.string {
                    resultArray.append(SyntaxTag.ConformedProtocolOrInheritedClassByGenerics.string + SyntaxTag.Space.string + token.text)
                }
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.initializerDeclSyntax {
                // initializerの宣言中
                if tokenKind == TokenKind.convenienceKeyword.string {
                    resultArray.append(SyntaxTag.HaveConvenienceKeyword.string)
                } else if tokenKind == TokenKind.postfixQuestionMark.string {
                    resultArray.append(SyntaxTag.IsFailableInitializer.string)
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.initializerDeclSyntax) &&
                        (!passedFunctionParameterOfInitializerDeclFirstColonFlag) {
                // ":"を検査するより前
                // 引数名を抽出する
                if tokenKind == TokenKind.colon.string {
                    passedFunctionParameterOfInitializerDeclFirstColonFlag = true
                } else {
                    resultArray.append(SyntaxTag.InitializerParameterName.string + SyntaxTag.Space.string + token.text)
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.initializerClauseSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax){
                // iniitalizerのデフォルト引数のデフォルト値を宣言しているとき
                if tokenKind != TokenKind.equal.string {
                    // 初期値を代入する"="以外を抽出する
                    initialValueOfInitializerParameter += token.text
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.initializerDeclSyntax) &&
                        (passedFunctionParameterOfInitializerDeclFirstColonFlag) {
                // ":"を検査した後
                // 型を抽出する
                // StringやIntのみ抽出する
                if tokenKind != TokenKind.comma.string &&
                    (tokenKind != TokenKind.postfixQuestionMark.string)  {
                    // 複数の引数を区切る","と、オプショナル型の"?"は抽出しない
                    resultArray.append(SyntaxTag.InitializerParameterType.string + SyntaxTag.Space.string + token.text)
                }
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.arrayTypeSyntax {
                // 配列の宣言中
                if (tokenKind != TokenKind.leftSquareBracket.string) &&
                    (tokenKind != TokenKind.rightSquareBracket.string) {
                    // "[" と "]"は抽出しない
                    if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                        // variableの型として配列を宣言中のとき
                        resultArray.append(SyntaxTag.ArrayTypeOfVariable.string + SyntaxTag.Space.string + token.text)
                    } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                        // functionの引数の型として配列を宣言中のとき
                        resultArray.append(SyntaxTag.ArrayTypeOfFunctionParameter.string + SyntaxTag.Space.string + token.text)
                    } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.returnClauseSyntax) &&
                                (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                        // functionの返り値の型として配列を宣言中のとき
                        resultArray.append(SyntaxTag.ArrayTypeOfFunctionReturnValue.string + SyntaxTag.Space.string + token.text)
                    } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax) {
                        // initializerの引数の型として配列を宣言中のとき
                        resultArray.append(SyntaxTag.ArrayTypeOfInitializer.string + SyntaxTag.Space.string + token.text)
                    } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typealiasDeclSyntax {
                        // typealiasの型として配列を宣言中のとき
                        resultArray.append(SyntaxTag.ArrayTypeOfTypealias.string + SyntaxTag.Space.string + token.text)
                    }
                }
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.dictionaryTypeSyntax {
                // 辞書の宣言中
                if (tokenKind != TokenKind.leftSquareBracket.string) &&
                    (tokenKind != TokenKind.rightSquareBracket.string) {
                    // "[" と "]"は抽出しない
                    if passedColonOfDictionaryTypeSyntaxFlag {
                        // ":"を検査した後なので、token.textはValueの型
                        if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                            // variableの型として辞書を宣言中のとき
                            resultArray.append(SyntaxTag.DictionaryValueTypeOfVariable.string + SyntaxTag.Space.string + token.text)
                        } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                    (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                            // functionの引数の型として辞書を宣言中のとき
                            resultArray.append(SyntaxTag.DictionaryValueTypeOfFunctionParameter.string + SyntaxTag.Space.string + token.text)
                        } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.returnClauseSyntax) &&
                                    (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                            // functionの返り値の型として辞書を宣言中のとき
                            resultArray.append(SyntaxTag.DictionaryValueTypeOfFunctionReturnValue.string + SyntaxTag.Space.string + token.text)
                        } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                    (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax) {
                            // initializerの引数の型として辞書を宣言中のとき
                            resultArray.append(SyntaxTag.DictionaryValueTypeOfInitializer.string + SyntaxTag.Space.string + token.text)
                        } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typealiasDeclSyntax {
                            // typealiasの型として辞書を宣言中のとき
                            resultArray.append(SyntaxTag.DictionaryValueTypeOfTypealias.string + SyntaxTag.Space.string + token.text)
                        }
                    } else {
                        // ":"を検査する前
                        if tokenKind == TokenKind.colon.string {
                            // ":"を見つけたとき、フラグをtrueにする
                            passedColonOfDictionaryTypeSyntaxFlag = true
                        } else {
                            // Keyの型
                            if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                                (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                                // variableの型として辞書を宣言中のとき
                                resultArray.append(SyntaxTag.DictionaryKeyTypeOfVariable.string + SyntaxTag.Space.string + token.text)
                            } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                        (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                                // functionの引数の型として辞書を宣言中のとき
                                resultArray.append(SyntaxTag.DictionaryKeyTypeOfFunctionParameter.string + SyntaxTag.Space.string + token.text)
                            } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.returnClauseSyntax) &&
                                        (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                                // functionの返り値の型として辞書を宣言中のとき
                                resultArray.append(SyntaxTag.DictionaryKeyTypeOfFunctionReturnValue.string + SyntaxTag.Space.string + token.text)
                            } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                        (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax) {
                                // initializerの引数の型として辞書を宣言中のとき
                                resultArray.append(SyntaxTag.DictionaryKeyTypeOfInitializer.string + SyntaxTag.Space.string + token.text)
                            } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typealiasDeclSyntax {
                                // typealiasの型として辞書を宣言中のとき
                                resultArray.append(SyntaxTag.DictionaryKeyTypeOfTypealias.string + SyntaxTag.Space.string + token.text)
                            }
                        }
                    }
                }
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.tupleTypeSyntax {
                // タプルの宣言中
                if (tokenKind != TokenKind.leftParen.string) &&
                    (tokenKind != TokenKind.rightParen.string) &&
                    (tokenKind != TokenKind.comma.string){
                    // "(" と ")" と ","は抽出しない
                    if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                        // variableの型としてタプルを宣言中のとき
                        resultArray.append(SyntaxTag.TupleTypeOfVariable.string + SyntaxTag.Space.string + token.text)
                    } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                        // functionの引数の型としてタプルを宣言中のとき
                        resultArray.append(SyntaxTag.TupleTypeOfFunctionParameter.string + SyntaxTag.Space.string + token.text)
                    } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.returnClauseSyntax) &&
                                (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                        // functionの返り値の型としてタプルを宣言中のとき
                        resultArray.append(SyntaxTag.TupleTypeOfFunctionReturnValue.string + SyntaxTag.Space.string + token.text)
                    } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax) {
                        // initializerの引数の型としてタプルを宣言中のとき
                        resultArray.append(SyntaxTag.TupleTypeOfInitializer.string + SyntaxTag.Space.string + token.text)
                    }else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typealiasDeclSyntax {
                        // typealiasの型としてタプルを宣言中のとき
                        resultArray.append(SyntaxTag.TupleTypeOfTypealias.string + SyntaxTag.Space.string + token.text)
                    }
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.typealiasDeclSyntax) &&
                        (!passedEqualOfTypealiasDeclFlag) {
                // typealiasの宣言中
                // まだ"="を検査していない
                if tokenKind.hasPrefix(TokenKind.identifier.string) {
                    // 連想型名を抽出する
                    resultArray.append(SyntaxTag.TypealiasAssociatedTypeName.string + SyntaxTag.Space.string + token.text)
                } else if tokenKind == TokenKind.equal.string {
                    // "="を検査したのでフラグをtrueにする
                    passedEqualOfTypealiasDeclFlag = true
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.typealiasDeclSyntax) &&
                        (passedEqualOfTypealiasDeclFlag) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // typealiasの宣言中
                // 既に"="を検査した後
                // optional型の"?"がつく可能性があるため、tokenKindがidentifierのときのみ抽出する
                resultArray.append(SyntaxTag.TypealiasType.string + SyntaxTag.Space.string + token.text)
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.constrainedSugarTypeSyntax {
                // opaque result typeの宣言中
                // "some"は抽出しない
                // 準拠するprotocolのみ抽出する
                if tokenKind != TokenKind.someKeyword.string {
                    if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                        // variableの型としてopaque result typeを宣言しているとき
                        resultArray.append(SyntaxTag.ConformedProtocolByOpaqueResultTypeOfVariable.string + SyntaxTag.Space.string + token.text)
                    } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.returnClauseSyntax) &&
                                (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                        // functionの返り値の型としてopaque result typeを宣言しているとき
                        resultArray.append(SyntaxTag.ConformedProtocolByOpaqueResultTypeOfFunctionReturnValue.string + SyntaxTag.Space.string + token.text)
                    }
                }
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.extensionDeclSyntax {
                // extensionの宣言中
                if tokenKind.hasPrefix(TokenKind.identifier.string) {
                    // extensionで拡張される型の名前を抽出する
                    resultArray.append(SyntaxTag.ExtensiondTypeName.string + SyntaxTag.Space.string + token.text)
                }
            }
        } // if 0 < syntaxNodeTypeStack.count
        
        return token._syntaxNode
    } // func visit(_ token: TokenSyntax) -> Syntax
    
    override func visitPost(_ node: Syntax) {
        let currentSyntaxNodeType = "\(node.syntaxNodeType)"
//        print("POST<- \(currentSyntaxNodeType)")
        
        if (1 < currentPositionInStack) &&
            (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.codeBlockSyntax) {
            // CodeBlockSyntax内の情報は、CodeBlockSyntaxを抜けること以外は無視する
            if currentSyntaxNodeType == SyntaxNodeType.codeBlockSyntax.string {
                popSyntaxNodeTypeStack()
            }
        } else {
            if currentSyntaxNodeType == SyntaxNodeType.structDeclSyntax.string {
                // structの宣言終了
                resultArray.append(SyntaxTag.EndStructDeclSyntax.string)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.classDeclSyntax.string {
                // classの宣言終了
                resultArray.append(SyntaxTag.EndClassDeclSyntax.string)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.enumDeclSyntax.string {
                // enumの宣言終了
                resultArray.append(SyntaxTag.EndEnumDeclSyntax.string)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.enumCaseElementSyntax.string {
                // enumのcaseを宣言終了
                resultArray.append(SyntaxTag.EndEnumCaseElementSyntax.string)
                popSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.parameterClauseSyntax.string) &&
                        (1 < currentPositionInStack) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.enumCaseElementSyntax) {
                // enumのcaseの連想値の型を宣言終了
                popSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (1 < currentPositionInStack) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.enumCaseElementSyntax) {
                // enumのローバリューを宣言終了
                resultArray.append(SyntaxTag.Rawvalue.string + SyntaxTag.Space.string + rawvalueString)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.protocolDeclSyntax.string {
                // protocolの宣言終了
                resultArray.append(SyntaxTag.EndProtocolDeclSyntax.string)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.associatedtypeDeclSyntax.string {
                // protocolの連想型の宣言終了
                resultArray.append(SyntaxTag.EndAssociatedtypeDeclSyntax.string)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.variableDeclSyntax.string {
                // variableの宣言終了
                resultArray.append(SyntaxTag.EndVariableDeclSyntax.string)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.customAttributeSyntax.string {
                // variableの@Stateなどの宣言終了
                resultArray.append(SyntaxTag.VariableCustomAttribute.string + SyntaxTag.Space.string + variableCustomAttribute)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.identifierPatternSyntax.string {
                // variableの名前を宣言終了
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.typeAnnotationSyntax.string {
                // variableの型を宣言終了
                popSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (1 < currentPositionInStack) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.variableDeclSyntax) {
                // variableの初期値を宣言終了
                resultArray.append(SyntaxTag.InitialValueOfVariable.string + SyntaxTag.Space.string + initialValueOfVariable)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.accessorBlockSyntax.string {
                // variableのwillSet, didSet, get, setを宣言するブロック終了
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.functionDeclSyntax.string {
                // functionの宣言終了
                resultArray.append(SyntaxTag.EndFunctionDeclSyntax.string)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.functionParameterSyntax.string &&
                        (1 < currentPositionInStack) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax){
                // functionの引数1つを宣言終了
                resultArray.append(SyntaxTag.EndFunctionParameterSyntax.string)
                popSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (1 < currentPositionInStack) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax){
                // functionのデフォルト引数のデフォルト値を宣言終了
                resultArray.append(SyntaxTag.InitialValueOfFunctionParameter.string + SyntaxTag.Space.string + initialValueOfFunctionParameter)
                popSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.returnClauseSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) {
                // functionの返り値の宣言終了
                resultArray.append(SyntaxTag.EndFunctionReturnValueType.string)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.genericParameterSyntax.string {
                // genericsの型引数の宣言終了
                var holder = ""
                if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.structDeclSyntax {
                    holder = "\(HolderType.struct)"
                } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.classDeclSyntax {
                    holder = "\(HolderType.class)"
                } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.enumDeclSyntax {
                    holder = "\(HolderType.enum)"
                } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax {
                    holder = "\(HolderType.function)"
                }
                resultArray.append(SyntaxTag.EndGenericParameterSyntaxOf.string + SyntaxTag.Space.string + holder)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.inheritedTypeListSyntax.string {
                // プロトコルへの準拠、またはクラスの継承終了
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.initializerDeclSyntax.string {
                // initializerの宣言終了
                resultArray.append(SyntaxTag.EndInitializerDeclSyntax.string)
                popSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (1 < currentPositionInStack) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax){
                // initializerのデフォルト引数のデフォルト値を宣言終了
                resultArray.append(SyntaxTag.InitialValueOfInitializerParameter.string + SyntaxTag.Space.string + initialValueOfInitializerParameter)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.functionParameterSyntax.string &&
                        (1 < currentPositionInStack) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.initializerDeclSyntax){
                // initializerの引数1つを宣言終了
                resultArray.append(SyntaxTag.EndInitializerParameter.string)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.extensionDeclSyntax.string {
                // extensionの宣言終了
                resultArray.append(SyntaxTag.EndExtensionDeclSyntax.string)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.arrayTypeSyntax.string {
                // 配列の宣言終了
                if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                    (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                    // variableの型として配列を宣言終了するとき
                    resultArray.append(SyntaxTag.EndArrayTypeSyntaxOfVariable.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの引数の型として配列を宣言終了するとき
                    resultArray.append(SyntaxTag.EndArrayTypeSyntaxOfFunctionParameter.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.returnClauseSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの返り値の型として配列を宣言終了するとき
                    resultArray.append(SyntaxTag.EndArrayTypeSyntaxOfFunctionReturnValue.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax) {
                    // initializerの引数の型として配列を宣言開始するとき
                    resultArray.append(SyntaxTag.EndArrayTypeSyntaxOfInitializer.string)
                } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typealiasDeclSyntax {
                    // typealiasの型として配列を宣言終了するとき
                    resultArray.append(SyntaxTag.EndArrayTypeSyntaxOfTypealias.string)
                }
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.dictionaryTypeSyntax.string {
                // 辞書の宣言終了
                if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                    (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                    // variableの型として辞書を宣言終了するとき
                    resultArray.append(SyntaxTag.EndDictionaryTypeSyntaxOfVariable.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの引数の型として辞書を宣言終了するとき
                    resultArray.append(SyntaxTag.EndDictionaryTypeSyntaxOfFunctionParameter.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.returnClauseSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの返り値の型として辞書を宣言終了するとき
                    resultArray.append(SyntaxTag.EndDictionaryTypeSyntaxOfFunctionReturnValue.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax) {
                    // initializerの引数の型として辞書を宣言終了するとき
                    resultArray.append(SyntaxTag.EndDictionaryTypeSyntaxOfInitializer.string)
                } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typealiasDeclSyntax {
                    // typealiasの型として辞書を宣言終了するとき
                    resultArray.append(SyntaxTag.EndDictionaryTypeSyntaxOfTypealias.string)
                }
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.tupleTypeSyntax.string {
                // タプルの宣言終了
                if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                    (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                    // variableの型としてタプルを宣言終了するとき
                    resultArray.append(SyntaxTag.EndTupleTypeSyntaxOfVariable.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの引数の型としてタプルを宣言終了するとき
                    resultArray.append(SyntaxTag.EndTupleTypeSyntaxOfFunctionParameter.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.returnClauseSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの返り値の型としてタプルを宣言終了するとき
                    resultArray.append(SyntaxTag.EndTupleTypeSyntaxOfFunctionReturnValue.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax) {
                    // initializerの引数の型としてタプルを宣言終了するとき
                    resultArray.append(SyntaxTag.EndTupleTypeSyntaxOfInitializer.string)
                } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typealiasDeclSyntax {
                    // typealiasの型としてタプルを宣言終了するとき
                    resultArray.append(SyntaxTag.EndTupleTypeSyntaxOfTypealias.string)
                }
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.optionalTypeSyntax.string {
                var type = ""
                // オプショナル型の要素を宣言終了したとき
                if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.variableDeclSyntax {
                    type = "\(OptionalTypeKind.variable)"
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) {
                    type = "\(OptionalTypeKind.functionParameter)"
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.returnClauseSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) {
                    type = "\(OptionalTypeKind.functionReturnValue)"
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.initializerDeclSyntax) {
                    type = "\(OptionalTypeKind.initializerParameter)"
                } else {
                    fatalError()
                }
                resultArray.append(SyntaxTag.IsOptionalType.string + SyntaxTag.Space.string + type)
//                resultArray.append("syntaxNodeTypeStack[currentPositionInStack]: \(syntaxNodeTypeStack[currentPositionInStack])")
//                resultArray.append("syntaxNodeTypeStack[currentPositionInStack - 1]: \(syntaxNodeTypeStack[currentPositionInStack - 1])")
            } else if currentSyntaxNodeType == SyntaxNodeType.typealiasDeclSyntax.string {
                // typealiasの宣言終了
                resultArray.append(SyntaxTag.EndTypealiasDecl.string)
                popSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.constrainedSugarTypeSyntax.string {
                // opaque result typeを宣言終了するとき
                popSyntaxNodeTypeStack()
            }
        } // if (1 < currentPositionInStack)
    } // func visitPost(_ node: Syntax)
    
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
//        printSyntaxNodeTypeStack()
    }
    
    // syntaxStack配列の最後の要素を削除し、ポップする
    private func popSyntaxNodeTypeStack() {
        self.syntaxNodeTypeStack.removeLast()
        currentPositionInStack -= 1
//        printSyntaxNodeTypeStack()
    }
    
    // addAccessLevelToResultArrayDependOnType()を呼び出して、resultArrayにアクセスレベルのタグを追加する
    private func addAccessLevelToResultArray(accessLevel: AccessLevel) {
        switch accessLevel {
        case .open:
            addAccessLevelToResultArrayDependOnType(accessLevel: AccessLevel.open.string)
        case .public:
            addAccessLevelToResultArrayDependOnType(accessLevel: AccessLevel.public.string)
        case .internal:
            addAccessLevelToResultArrayDependOnType(accessLevel: AccessLevel.internal.string)
        case .fileprivate:
            addAccessLevelToResultArrayDependOnType(accessLevel: AccessLevel.fileprivate.string)
        case .private:
            addAccessLevelToResultArrayDependOnType(accessLevel: AccessLevel.private.string)
        }
    } // func addAccessLevelToResultArray(accessLevel: AccessLevel)
    
    // syntaxNodeTypeStackに応じて、アクセスレベルの持ち主とアクセスレベルのタグをresultArrayに追加する
    // addAccessLevelToResultArray()で呼び出される
    private func addAccessLevelToResultArrayDependOnType(accessLevel: String) {
        if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.structDeclSyntax {
            // structのアクセスレベル
            resultArray.append(SyntaxTag.StructAccessLevel.string + SyntaxTag.Space.string + accessLevel)
        } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.classDeclSyntax {
            // classのアクセスレベル
            resultArray.append(SyntaxTag.ClassAccessLevel.string + SyntaxTag.Space.string + accessLevel)
        } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.enumDeclSyntax {
            // enumのアクセスレベル
            resultArray.append(SyntaxTag.EnumAccessLevel.string + SyntaxTag.Space.string + accessLevel)
        } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.protocolDeclSyntax {
            // protocolのアクセスレベル
            resultArray.append(SyntaxTag.ProtocolAccessLevel.string + SyntaxTag.Space.string + accessLevel)
        } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.variableDeclSyntax {
            // variableのアクセスレベル
            resultArray.append(SyntaxTag.VariableAccessLevel.string + SyntaxTag.Space.string + accessLevel)
        } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionDeclSyntax {
            // functionのアクセスレベル
            resultArray.append(SyntaxTag.FunctionAccessLevel.string + SyntaxTag.Space.string + accessLevel)
        }
    } // func addAccessLevelToResultArrayDependOnType(accessLevel: String)
    
    // syntaxNodeTypeStackに応じて、準拠しているもの(struct, class, ...)とプロトコルの名前のタグをresultArrayに追加する
    private func addConformedProtocolName(protocolName: String) {
        if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.structDeclSyntax {
            // structの宣言中のとき
            resultArray.append(SyntaxTag.ConformedProtocolByStruct.string + SyntaxTag.Space.string + protocolName)
        } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.classDeclSyntax {
            // classの宣言中のとき
            // 継承と、プロトコルへの準拠のどちらか判別できない
            resultArray.append(SyntaxTag.ConformedProtocolOrInheritedClassByClass.string + SyntaxTag.Space.string + protocolName)
        } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.enumDeclSyntax {
            // enumの宣言中のとき
            // ローバリューの型の宣言と、プロトコルへの準拠のどちらか判別できない
            if compareRawvalueType(with: protocolName) {
                // ローバリューの型を宣言しているとき
                resultArray.append(SyntaxTag.RawvalueType.string + SyntaxTag.Space.string + protocolName)
            } else {
                // 準拠しているプロトコルを宣言しているとき
                resultArray.append(SyntaxTag.ConformedProtocolByEnum.string + SyntaxTag.Space.string + protocolName)
            }
        } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.protocolDeclSyntax {
            // protocolの宣言中のとき
            resultArray.append(SyntaxTag.ConformedProtocolByProtocol.string + SyntaxTag.Space.string + protocolName)
        } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.associatedtypeDeclSyntax {
            // protocolで連想型の型制約を宣言中のとき
            resultArray.append(SyntaxTag.ConformedProtocolOrInheritedClassByAssociatedType.string + SyntaxTag.Space.string + protocolName)
        } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.extensionDeclSyntax {
            // extensionの宣言中のとき
            resultArray.append(SyntaxTag.ConformedProtocolByExtension.string + SyntaxTag.Space.string + protocolName)
        }
    } // func addConformedProtocolName(protocolName: String)
    
    // enumのInheritedTypeListSyntaxで抽出したtoken.textが、ローバリューの型を宣言しているかを調べる
    // addConformedProtocolName()内で呼び出す
    private func compareRawvalueType(with string: String) -> Bool {
        for type in rawvalueType {
            if string == type {
                return true
            }
        }
        return false
    }
    
    // classNameArrayを返す
    func getClassNameArray() -> [String] {
        return classNameArray
    }
    
    // デバッグ
    // classNameArrayの全要素をprint()する
    private func printClassNameArray() {
        print("-----ClassNameArray-----")
        for element in self.classNameArray {
            print(element)
        }
        print("------------------------")
    }
    
    // デバッグ
    // syntaxNodeTypeStackの全要素をprint()する
    private func printSyntaxNodeTypeStack() {
        print("-----SyntaxNodeTypeStack-----")
        for element in self.syntaxNodeTypeStack {
            print(element)
        }
        print("-----------------------------\n")
    }
}
