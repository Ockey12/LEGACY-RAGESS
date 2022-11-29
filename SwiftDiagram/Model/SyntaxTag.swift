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
    
    // class
    case startClassDeclSyntax // classの宣言開始
    case classAccessLevel // classのアクセスレベル
    case className // classの名前
    case endClassDeclSyntax // classの宣言終了
    
    // enum
    case startEnumDeclSyntax // enumの宣言開始
    case enumAccessLevel // enumのアクセスレベル
    case enumName // enumの名前
    case rawvalueType // ローバリューの型
    case rawvalue // ローバリューの値
    case caseAssociatedValue // caseの連想値
    case startEnumCaseElementSyntax // enumのcaseを宣言開始
    case enumCase // enumのcase
    case endEnumCaseElementSyntax // enumのcaseを宣言終了
    case endEnumDeclSyntax // enumの宣言終了
    
    // プロトコルへの準拠
    case startInheritedTypeListSyntax // プロトコルへの準拠開始
    case conformedProtocolByStruct // structが準拠しているプロトコル
    case conformedProtocolOrInheritedClassByClass // classが準拠しているプロトコル、または継承しているクラス
    case conformedProtocolByEnum // enumが準拠しているプロトコル
    case endInheritedTypeListSyntax // プロトコルへの準拠終了
    
    // variable
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
    case haveGetter // getを持つvariable
    case haveSetter // setを持つvariable
    case endVariableDeclSyntax // 変数の宣言終了
    
    // function
    case startFunctionDeclSyntax // functionの宣言開始
    case functionAccessLevel // functionのアクセスレベル
    case functionName // functionの名前
    case startFunctionParameterSyntax // functionの個々の引数を宣言開始
    case externalParameterName // functionの外部引数名
    case internalParameterName // functionの内部引数名
    case haveInoutKeyword // inoutキーワードを持つ
    case isVariadicParameter // 可変長引数である
    case parameterType // 引数の型
    case initialValueOfParameter // デフォルト引数のデフォルト値
    case endFunctionParameterSyntax // functionの個々の引数を宣言終了
    case endFunctionDeclSyntax // functionの宣言終了
    
    // initializer
    case startInitializerDeclSyntax // initializerの宣言開始
    case endInitializerDeclSyntax // initializerの宣言終了

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
        // class
        case .startClassDeclSyntax:
            return "StartClassDeclSyntax"
        case .classAccessLevel:
            return "ClassAccessLevel"
        case .className:
            return "ClassName"
        case .endClassDeclSyntax:
            return "EndClassDeclSyntax"
        // enum
        case .startEnumDeclSyntax:
            return "StartEnumDeclSyntax"
        case .enumAccessLevel:
            return "EnumAccessLevel"
        case .enumName:
            return "EnumName"
        case .rawvalueType:
            return "RawvalueType"
        case .rawvalue:
            return "Rawvalue"
        case .caseAssociatedValue:
            return "CaseAssociatedValue"
        case .startEnumCaseElementSyntax:
            return "StartEnumCaseElementSyntax"
        case .enumCase:
            return "EnumCase"
        case .endEnumCaseElementSyntax:
            return "EndEnumCaseElementSyntax"
        case .endEnumDeclSyntax:
            return "EndEnumDeclSyntax"
        // プロトコルへの準拠
        case .startInheritedTypeListSyntax:
            return "StartInheritedTypeListSyntax"
        case .conformedProtocolByStruct:
            return "ConformedProtocolByStruct"
        case .conformedProtocolOrInheritedClassByClass:
            return "ConformedProtocolOrInheritedClassByClass"
        case .conformedProtocolByEnum:
            return "ConformedProtocolByEnum"
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
        case .haveGetter:
            return "HaveGetter"
        case .haveSetter:
            return "HaveSetter"
        case .endVariableDeclSyntax:
            return "EndVariableDeclSyntax"
        // initializer
        case .startInitializerDeclSyntax:
            return "StartInitializerDeclSyntax"
        case .endInitializerDeclSyntax:
            return "EndInitializerDeclSyntax"
        // function
        case .startFunctionDeclSyntax:
            return "StartFunctionDeclSyntax"
        case .functionAccessLevel:
            return "FunctionAccessLevel"
        case .functionName:
            return "FunctionName"
        case .startFunctionParameterSyntax:
            return "StartFunctionParameterSyntax"
        case .externalParameterName:
            return "ExternalParameterName"
        case .internalParameterName:
            return "InternalParameterName"
        case .haveInoutKeyword:
            return "HaveInoutKeyword"
        case .isVariadicParameter:
            return "IsVariadicParameter"
        case .parameterType:
            return "ParameterType"
        case .initialValueOfParameter:
            return "InitialValueOfParameter"
        case .endFunctionParameterSyntax:
            return "EndFunctionParameterSyntax"
        case .endFunctionDeclSyntax:
            return "EndFunctionDeclSyntax"
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
