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
    
    // variableの@Stateなどの文字列を一時的に保存する
    // @Stateの場合、@とStateが別のtokenなため
    // visitPre()で""に初期化する
    private var variableCustomAttribute = ""
    
    // variableのTypeAnnotationSyntax内で最初の":"を検査した後trueになる
    // variable名と型を区切る":"と、辞書やタプル中の":"を区別するために使う
    // visitPre()でfalseに初期化する
//    private var passedTypeAnnotationFirstColonFlag = false
    
    // TypeAnnotation内で抽出したvariableの型を文字列として一時的に保持する
    // visitPre()で""に初期化する
    // visitPost()でresultArrayに.append()する
//    private var variableTypeString = ""
    
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
    
    // FunctionParameterSyntax内で引数の型を文字列として一時的に保持する
    // visitPre()で""に初期化する
    // visitPost()でresultArrayに.append()する
//    private var functionParameterTypeString = ""
    
    // デフォルト引数のデフォルト値を文字列として一時的に保持する
    // visitPre()で""に初期化する
    // visit()でtoken.textを追加していく
    private var initialValueOfParameter = ""
    
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
    
    // enumのcaseの連想値を文字列として一時的に保持する
    // visitPre()で""に初期化する
    // visit()でtoken.textを追加していく
//    private var caseAssociatedValueString = ""
    
    // InitializerDeclSyntax内のFunctionParameterSyntax内で最初の":"を検査した後trueになる
    // visit()内でtokenKindがidentifier()のとき、これがfalseなら引数名、trueなら型
    // visitPre()でfalseに初期化する
    private var passedFunctionParameterOfInitializerDeclFirstColonFlag = false
    
    // 辞書のKeyとValueを区別するために使う
    // Keyを抽出後、":"を検査したときにtrueになる
    // visit()内でtokenKindがidentifier()のとき、これがfalseならKey、trueならValue
    // visitPre()でfalseに初期化する
    private var passedFunctionParameterOfDictionaryTypeSyntaxFirstColonFlag = false
    
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
            } else if currentSyntaxNodeType == SyntaxNodeType.enumDeclSyntax.string {
                // enumの宣言開始
                resultArray.append(SyntaxTag.startEnumDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.enumDeclSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.enumCaseElementSyntax.string {
                // enumのcaseを宣言開始
                resultArray.append(SyntaxTag.startEnumCaseElementSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.enumCaseElementSyntax)
                printSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.parameterClauseSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.enumCaseElementSyntax) {
                // enumのcaseの連想値の型を宣言開始
                pushSyntaxNodeTypeStack(SyntaxNodeType.parameterClauseSyntax)
                printSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.enumCaseElementSyntax) {
                // enumのローバリューを宣言開始
                rawvalueString = ""
                pushSyntaxNodeTypeStack(SyntaxNodeType.initializerClauseSyntax)
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
//                passedTypeAnnotationFirstColonFlag = false
//                variableTypeString = ""
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
            } else if (currentSyntaxNodeType == SyntaxNodeType.functionParameterSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionDeclSyntax){
                // functionの引数1つを宣言開始
                functionParameterNames.removeAll()
                passedFunctionParameterOfFunctionDeclFirstColonFlag = false
//                functionParameterTypeString = ""
                resultArray.append(SyntaxTag.startFunctionParameterSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.functionParameterSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.codeBlockSyntax.string {
                // functionまたはinitializerのCodeBlock宣言開始
                pushSyntaxNodeTypeStack(SyntaxNodeType.codeBlockSyntax)
                printSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) {
                // デフォルト引数のデフォルト値を宣言開始
                initialValueOfParameter = ""
                pushSyntaxNodeTypeStack(SyntaxNodeType.initializerClauseSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.inheritedTypeListSyntax.string {
                // プロトコルへの準拠、またはクラスの継承、またはローバリューの型を宣言開始
                pushSyntaxNodeTypeStack(SyntaxNodeType.inheritedTypeListSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.initializerDeclSyntax.string {
                // initializerの宣言開始
                resultArray.append(SyntaxTag.startInitializerDeclSyntax.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.initializerDeclSyntax)
                printSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.functionParameterSyntax.string) &&
                        (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.initializerDeclSyntax){
                // initializerの引数1つを宣言開始
//                functionParameterNames.removeAll()
//                passedFunctionParameterFirstColonFlag = false
//                functionParameterTypeString = ""
//                resultArray.append(SyntaxTag.startFunctionParameterSyntax.string)
                passedFunctionParameterOfInitializerDeclFirstColonFlag = false
                resultArray.append(SyntaxTag.startInitializerParameter.string)
                pushSyntaxNodeTypeStack(SyntaxNodeType.functionParameterSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.arrayTypeSyntax.string {
                // 配列の宣言開始
                if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.typeAnnotationSyntax) &&
                    (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.variableDeclSyntax) {
                    // variableの型として配列を宣言開始するとき
                    resultArray.append(SyntaxTag.startArrayTypeSyntaxOfVariable.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの引数の型として配列を宣言開始するとき
                    resultArray.append(SyntaxTag.startArrayTypeSyntaxOfFunction.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.initializerDeclSyntax) {
                    // initializerの引数の型として配列を宣言開始するとき
                    resultArray.append(SyntaxTag.startArrayTypeSyntaxOfInitializer.string)
                }
                pushSyntaxNodeTypeStack(SyntaxNodeType.arrayTypeSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.dictionaryTypeSyntax.string {
                // 辞書の宣言開始
                if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.typeAnnotationSyntax) &&
                    (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.variableDeclSyntax) {
                    // variableの型として辞書を宣言開始するとき
                    resultArray.append(SyntaxTag.startDictionaryTypeSyntaxOfVariable.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの引数の型として辞書を宣言開始するとき
                    resultArray.append(SyntaxTag.startDictionaryTypeSyntaxOfFunction.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.initializerDeclSyntax) {
                    // initializerの引数の型として辞書を宣言開始するとき
                    resultArray.append(SyntaxTag.startDictionaryTypeSyntaxOfInitializer.string)
                }
                passedFunctionParameterOfDictionaryTypeSyntaxFirstColonFlag = false
                pushSyntaxNodeTypeStack(SyntaxNodeType.dictionaryTypeSyntax)
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.tupleTypeSyntax.string {
                // タプルの宣言開始
                if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.typeAnnotationSyntax) &&
                    (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.variableDeclSyntax) {
                    // variableの型としてタプルを宣言開始するとき
                    resultArray.append(SyntaxTag.startTupleTypeSyntaxOfVariable.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの引数の型としてタプルを宣言開始するとき
                    resultArray.append(SyntaxTag.startTupleTypeSyntaxOfFunction.string)
                }
                pushSyntaxNodeTypeStack(SyntaxNodeType.tupleTypeSyntax)
                printSyntaxNodeTypeStack()
            }
        }
    }
    
    override func visit(_ token: TokenSyntax) -> Syntax {
        print("      text: \(token.text)")
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
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.classDeclSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // classの名前を宣言しているとき
                resultArray.append(SyntaxTag.className.string + SyntaxTag.space.string + token.text)
                classNameArray.append(token.text)
                printClassNameArray()
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.enumDeclSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // enumの名前を宣言しているとき
                resultArray.append(SyntaxTag.enumName.string + SyntaxTag.space.string + token.text)
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.enumCaseElementSyntax) &&
                        (tokenKind.hasPrefix(TokenKind.identifier.string)) {
                // enumのcaseを宣言しているとき
                resultArray.append(SyntaxTag.enumCase.string + SyntaxTag.space.string + token.text)
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
                if (tokenKind != TokenKind.leftParen.string) &&
                    (tokenKind != TokenKind.comma.string) &&
                    (tokenKind != TokenKind.rightParen.string) {
                    // "(", commma, ")"以外を抽出する
                    resultArray.append(SyntaxTag.caseAssociatedValue.string + SyntaxTag.space.string + token.text)
                }
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
                // ここでは、StringやDoubleのような、1つのtokenで表される型のみを抽出する
                // 配列や辞書は別のelse if節で抽出する
                if (tokenKind != TokenKind.colon.string) &&
                    (tokenKind != TokenKind.postfixQuestionMark.string) {
                    resultArray.append(SyntaxTag.variableType.string + SyntaxTag.space.string + token.text)
//                    if tokenKind == TokenKind.postfixQuestionMark.string {
//                        // "?"のとき
//                        // "?"は型名には含めず、オプショナル型であることをタグで表す
//                        resultArray.append(SyntaxTag.isOptionalType.string)
//                    } else {
//                        resultArray.append(SyntaxTag.variableType.string + SyntaxTag.space.string + token.text)
//                    }
                }
//                if tokenKind == TokenKind.colon.string {
//                    // ":"のとき
//                    if passedTypeAnnotationFirstColonFlag {
//                        // TypeAnnotation内で最初の":"でなければ、型名内の文字列として抽出する
//                        variableTypeString += ":"
//                    } else {
//                        // TypeAnnotation内で最初の":"なら、variable名と型を区切るものなので抽出しない
//                        passedTypeAnnotationFirstColonFlag = true
//                    }
//                } else if tokenKind == TokenKind.postfixQuestionMark.string {
//                    // "?"のとき
//                    // "?"は型名には含めず、オプショナル型であることをタグで表す
//                    resultArray.append(SyntaxTag.isOptionalType.string)
//                }else {
//                    // ":"でなければ抽出する
//                    variableTypeString += token.text
//                }
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
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax) &&
                        (passedFunctionParameterOfFunctionDeclFirstColonFlag) {
                // FunctionParameterSyntax内で既に最初の":"を検査した後
                if tokenKind == TokenKind.inoutKeyword.string {
                    // inoutキーワードのとき
                    resultArray.append(SyntaxTag.haveInoutKeyword.string)
                } else if tokenKind == TokenKind.ellipsis.string {
                    // "..."のとき、可変長引数
                    resultArray.append(SyntaxTag.isVariadicParameter.string)
                } else if (tokenKind != TokenKind.comma.string) &&
                            (tokenKind != TokenKind.postfixQuestionMark.string){
//                    functionParameterTypeString += token.text
                    // StringやIntのみ抽出する
                    resultArray.append(SyntaxTag.functionParameterType.string + SyntaxTag.space.string + token.text)
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.initializerClauseSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) {
                // functionのデフォルト引数のデフォルト値を宣言しているとき
                if tokenKind != TokenKind.equal.string {
                    // 初期値を代入する"="以外を抽出する
                    initialValueOfParameter += token.text
                }
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.initializerDeclSyntax {
                // initializerの宣言中
                if tokenKind == TokenKind.convenienceKeyword.string {
                    resultArray.append(SyntaxTag.haveConvenienceKeyword.string)
                } else if tokenKind == TokenKind.postfixQuestionMark.string {
                    resultArray.append(SyntaxTag.isFailableInitializer.string)
                }
            } else if (syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.functionParameterSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.initializerDeclSyntax) &&
                        (!passedFunctionParameterOfInitializerDeclFirstColonFlag) {
                // ":"を検査するより前
                // 引数名を抽出する
                if tokenKind == TokenKind.colon.string {
                    passedFunctionParameterOfInitializerDeclFirstColonFlag = true
                } else {
                    resultArray.append(SyntaxTag.initializerParameterName.string + SyntaxTag.space.string + token.text)
//                    if (tokenKind != TokenKind.comma.string){
//                        // 複数の引数を区切る","と、オプショナル型の"?"は抽出しない
//                        resultArray.append(SyntaxTag.initializerParameterName.string + SyntaxTag.space.string + token.text)
//                    }
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
                    resultArray.append(SyntaxTag.initializerParameterType.string + SyntaxTag.space.string + token.text)
                }
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.arrayTypeSyntax {
                // 配列の宣言中
                if (tokenKind != TokenKind.leftSquareBracket.string) &&
                    (tokenKind != TokenKind.rightSquareBracket.string) {
                    // "[" と "]"は抽出しない
                    if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                        // variableの型として配列を宣言中のとき
                        resultArray.append(SyntaxTag.arrayTypeOfVariable.string + SyntaxTag.space.string + token.text)
                    } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                        // functionの引数の型として配列を宣言中のとき
                        resultArray.append(SyntaxTag.arrayTypeOfFunction.string + SyntaxTag.space.string + token.text)
                    } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax) {
                        // initializerの引数の型として配列を宣言中のとき
                        resultArray.append(SyntaxTag.arrayTypeOfInitializer.string + SyntaxTag.space.string + token.text)
                    }
                }
            } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.dictionaryTypeSyntax {
                // 辞書の宣言中
                if (tokenKind != TokenKind.leftSquareBracket.string) &&
                    (tokenKind != TokenKind.rightSquareBracket.string) {
                    // "[" と "]"は抽出しない
                    if passedFunctionParameterOfDictionaryTypeSyntaxFirstColonFlag {
                        // ":"を検査した後なので、token.textはValueの型
                        if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                            // variableの型として辞書を宣言中のとき
                            resultArray.append(SyntaxTag.dictionaryValueTypeOfVariable.string + SyntaxTag.space.string + token.text)
                        } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                    (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                            // functionの引数の型として辞書を宣言中のとき
                            resultArray.append(SyntaxTag.dictionaryValueTypeOfFunction.string + SyntaxTag.space.string + token.text)
                        } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                    (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax) {
                            // initializerの引数の型として辞書を宣言中のとき
                            resultArray.append(SyntaxTag.dictionaryValueTypeOfInitializer.string + SyntaxTag.space.string + token.text)
                        }
                    } else {
                        // ":"を検査する前
                        if tokenKind == TokenKind.colon.string {
                            // ":"を見つけたとき、フラグをtrueにする
                            passedFunctionParameterOfDictionaryTypeSyntaxFirstColonFlag = true
                        } else {
                            // Keyの型
                            if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                                (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                                // variableの型として辞書を宣言中のとき
                                resultArray.append(SyntaxTag.dictionaryKeyTypeOfVariable.string + SyntaxTag.space.string + token.text)
                            } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                        (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                                // functionの引数の型として辞書を宣言中のとき
                                resultArray.append(SyntaxTag.dictionaryKeyTypeOfFunction.string + SyntaxTag.space.string + token.text)
                            } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                                        (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax) {
                                // initializerの引数の型として辞書を宣言中のとき
                                resultArray.append(SyntaxTag.dictionaryKeyTypeOfInitializer.string + SyntaxTag.space.string + token.text)
                            }
                        }
                    }
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
            } else if currentSyntaxNodeType == SyntaxNodeType.enumDeclSyntax.string {
                // enumの宣言終了
                resultArray.append(SyntaxTag.endEnumDeclSyntax.string)
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.enumCaseElementSyntax.string {
                // enumのcaseを宣言終了
                resultArray.append(SyntaxTag.endEnumCaseElementSyntax.string)
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.parameterClauseSyntax.string) &&
                        (1 < currentPositionInStack) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.enumCaseElementSyntax) {
                // enumのcaseの連想値の型を宣言終了
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (1 < currentPositionInStack) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.enumCaseElementSyntax) {
                // enumのローバリューを宣言終了
                resultArray.append(SyntaxTag.rawvalue.string + SyntaxTag.space.string + rawvalueString)
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
//                resultArray.append(SyntaxTag.variableType.string + SyntaxTag.space.string + variableTypeString)
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (1 < currentPositionInStack) &&
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
            } else if currentSyntaxNodeType == SyntaxNodeType.functionParameterSyntax.string &&
                        (1 < currentPositionInStack) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionDeclSyntax){
                // functionの引数1つを宣言終了
//                if functionParameterTypeString.last == "," {
//                    // functionが引数を複数持つとき、最後の引数以外は型の末尾に","がついてしまうので、取り除く
//                    functionParameterTypeString = String(functionParameterTypeString.dropLast())
//                }
//                resultArray.append(SyntaxTag.parameterType.string + SyntaxTag.space.string + functionParameterTypeString)
                resultArray.append(SyntaxTag.endFunctionParameterSyntax.string)
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if (currentSyntaxNodeType == SyntaxNodeType.initializerClauseSyntax.string) &&
                        (1 < currentPositionInStack) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) {
                // デフォルト引数のデフォルト値を宣言終了
                resultArray.append(SyntaxTag.initialValueOfParameter.string + SyntaxTag.space.string + initialValueOfParameter)
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.inheritedTypeListSyntax.string {
                // プロトコルへの準拠、またはクラスの継承終了
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.initializerDeclSyntax.string {
                // initializerの宣言終了
                resultArray.append(SyntaxTag.endInitializerDeclSyntax.string)
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.functionParameterSyntax.string &&
                        (1 < currentPositionInStack) &&
                        (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.initializerDeclSyntax){
                // initializerの引数1つを宣言終了
//                if functionParameterTypeString.last == "," {
//                    // initializerが引数を複数持つとき、最後の引数以外は型の末尾に","がついてしまうので、取り除く
//                    functionParameterTypeString = String(functionParameterTypeString.dropLast())
//                }
//                resultArray.append(SyntaxTag.parameterType.string + SyntaxTag.space.string + functionParameterTypeString)
//                resultArray.append(SyntaxTag.endFunctionParameterSyntax.string)
                resultArray.append(SyntaxTag.endInitializerParameter.string)
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.arrayTypeSyntax.string {
                // 配列の宣言終了
                if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                    (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                    // variableの型として配列を宣言終了するとき
                    resultArray.append(SyntaxTag.endArrayTypeSyntaxOfVariable.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの引数の型として配列を宣言終了するとき
                    resultArray.append(SyntaxTag.endArrayTypeSyntaxOfFunction.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax) {
                    // initializerの引数の型として配列を宣言開始するとき
                    resultArray.append(SyntaxTag.endArrayTypeSyntaxOfInitializer.string)
                }
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.dictionaryTypeSyntax.string {
                // 辞書の宣言終了
                if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                    (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                    // variableの型として辞書を宣言終了するとき
                    resultArray.append(SyntaxTag.endDictionaryTypeSyntaxOfVariable.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの引数の型として辞書を宣言終了するとき
                    resultArray.append(SyntaxTag.endDictionaryTypeSyntaxOfFunction.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.initializerDeclSyntax) {
                    // initializerの引数の型として辞書を宣言終了するとき
                    resultArray.append(SyntaxTag.endDictionaryTypeSyntaxOfInitializer.string)
                }
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.tupleTypeSyntax.string {
                // タプルの宣言終了
                if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.typeAnnotationSyntax) &&
                    (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.variableDeclSyntax) {
                    // variableの型としてタプルを宣言終了するとき
                    resultArray.append(SyntaxTag.endTupleTypeSyntaxOfVariable.string)
                } else if (syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.functionParameterSyntax) &&
                            (syntaxNodeTypeStack[currentPositionInStack - 2] == SyntaxNodeType.functionDeclSyntax) {
                    // functionの引数の型としてタプルを宣言終了するとき
                    resultArray.append(SyntaxTag.endTupleTypeSyntaxOfFunction.string)
                }
                popSyntaxNodeTypeStack()
                printSyntaxNodeTypeStack()
            } else if currentSyntaxNodeType == SyntaxNodeType.optionalTypeSyntax.string {
                // オプショナル型の配列などを宣言終了したとき
                resultArray.append(SyntaxTag.isOptionalType.string)
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
        } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.classDeclSyntax {
            // classのアクセスレベル
            resultArray.append(SyntaxTag.classAccessLevel.string + SyntaxTag.space.string + accessLevel)
        } else if syntaxNodeTypeStack[currentPositionInStack] == SyntaxNodeType.enumDeclSyntax {
            // enumのアクセスレベル
            resultArray.append(SyntaxTag.enumAccessLevel.string + SyntaxTag.space.string + accessLevel)
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
            // 継承と、プロトコルへの準拠のどちらか判別できない
            resultArray.append(SyntaxTag.conformedProtocolOrInheritedClassByClass.string + SyntaxTag.space.string + protocolName)
        } else if syntaxNodeTypeStack[currentPositionInStack - 1] == SyntaxNodeType.enumDeclSyntax {
            // enumの宣言中のとき
            // ローバリューの型の宣言と、プロトコルへの準拠のどちらか判別できない
            if compareRawvalueType(with: protocolName) {
                // ローバリューの型を宣言しているとき
                resultArray.append(SyntaxTag.rawvalueType.string + SyntaxTag.space.string + protocolName)
            } else {
                // 準拠しているプロトコルを宣言しているとき
                resultArray.append(SyntaxTag.conformedProtocolByEnum.string + SyntaxTag.space.string + protocolName)
            }
        }
    }
    
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
