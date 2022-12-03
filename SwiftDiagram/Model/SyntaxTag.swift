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
    
    // protocol
    case startProtocolDeclSyntax // protocolの宣言開始
    case protocolAccessLevel // protocolのアクセスレベル
    case protocolName // protocolの名前
    case startAssociatedtypeDeclSyntax // 連想型の宣言開始
    case associatedType // 連想型の名前
    case endAssociatedtypeDeclSyntax // 連想型の宣言終了
    case endProtocolDeclSyntax // protocolの宣言終了
    
    // プロトコルへの準拠
    case startInheritedTypeListSyntax // プロトコルへの準拠開始
    case conformedProtocolByStruct // structが準拠しているプロトコル
    case conformedProtocolOrInheritedClassByClass // classが準拠しているプロトコル、または継承しているクラス
    case conformedProtocolByEnum // enumが準拠しているプロトコル
    case conformedProtocolByProtocol // protocolが準拠しているprotocol
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
    case startArrayTypeSyntaxOfVariable // variableの配列の型を宣言開始
    case arrayTypeOfVariable // 配列の型
    case endArrayTypeSyntaxOfVariable // variableの配列の型を宣言終了
    case startDictionaryTypeSyntaxOfVariable // variableの辞書の型を宣言開始
    case dictionaryKeyTypeOfVariable // 辞書のKeyの型
    case dictionaryValueTypeOfVariable // 辞書のValueの型
    case endDictionaryTypeSyntaxOfVariable // variableの辞書の型を宣言終了
    case startTupleTypeSyntaxOfVariable // variableのタプルの型を宣言開始
    case tupleTypeOfVariable // タプルの型
    case endTupleTypeSyntaxOfVariable // variableのタプルの型を宣言終了
    case isOptionalType // optional型である
    case initialValueOfVariable // variableの初期値
    case haveWillSet // willSetを持つvariable
    case haveDidSet // didSetを持つvariable
    case haveGetter // getを持つvariable
    case haveSetter // setを持つvariable
    case endVariableDeclSyntax // 変数の宣言終了
    
    // function
    case startFunctionDeclSyntax // functionの宣言開始
    case functionAccessLevel // functionのアクセスレベル
    case isMutatingFunction // mutatingキーワードを持つ
    case functionName // functionの名前
    case startFunctionParameterSyntax // functionの個々の引数を宣言開始
    case externalParameterName // functionの外部引数名
    case internalParameterName // functionの内部引数名
    case haveInoutKeyword // inoutキーワードを持つ
    case isVariadicParameter // 可変長引数である
    case functionParameterType // 引数の型
    case startArrayTypeSyntaxOfFunctionParameter // 引数の配列の型を宣言開始
    case arrayTypeOfFunctionParameter // 引数の配列の型
    case endArrayTypeSyntaxOfFunctionParameter // 引数の配列の型を宣言終了
    case startDictionaryTypeSyntaxOfFunctionParameter // 引数の辞書の型を宣言開始
    case dictionaryKeyTypeOfFunctionParameter // 引数の辞書のKeyの型
    case dictionaryValueTypeOfFunctionParameter // 引数の辞書のValueの型
    case endDictionaryTypeSyntaxOfFunctionParameter // 引数の辞書の型を宣言終了
    case startTupleTypeSyntaxOfFunctionParameter // 引数のタプルの型を宣言開始
    case tupleTypeOfFunctionParameter // 引数のタプルの型
    case endTupleTypeSyntaxOfFunctionParameter // 引数のタプルの型を宣言終了
    case initialValueOfParameter // デフォルト引数のデフォルト値
    case endFunctionParameterSyntax // functionの個々の引数を宣言終了
    case startFunctionReturnValueType // functionの返り値の型の宣言開始
    case functionReturnValueType // functionの返り値の型
    case startArrayTypeSyntaxOfFunctionReturnValue // 返り値の配列の型を宣言開始
    case arrayTypeOfFunctionReturnValue // 返り値の配列の型
    case endArrayTypeSyntaxOfFunctionReturnValue // 返り値の配列の型を宣言終了
    case startDictionaryTypeSyntaxOfFunctionReturnValue // 返り値の辞書の型を宣言開始
    case dictionaryKeyTypeOfFunctionReturnValue // 返り値の辞書のKeyの型
    case dictionaryValueTypeOfFunctionReturnValue // 返り値の辞書のValueの型
    case endDictionaryTypeSyntaxOfFunctionReturnValue // 返り値の辞書の型を宣言終了
    case startTupleTypeSyntaxOfFunctionReturnValue // 返り値のタプルの型を宣言開始
    case tupleTypeOfFunctionReturnValue // 返り値のタプルの型
    case endTupleTypeSyntaxOfFunctionReturnValue // 返り値のタプルの型を宣言終了
    case endFunctionReturnValueType // functionの返り値の型の宣言終了
    case endFunctionDeclSyntax // functionの宣言終了
    
    // initializer
    case startInitializerDeclSyntax // initializerの宣言開始
    case haveConvenienceKeyword // convenience initializerである
    case isFailableInitializer // 失敗可能イニシャライザである
    case startInitializerParameter // 引数1つの宣言開始
    case initializerParameterName // 引数名
    case initializerParameterType // 引数の型
    case startArrayTypeSyntaxOfInitializer // 引数の配列の型を宣言開始
    case arrayTypeOfInitializer // 配列の型
    case endArrayTypeSyntaxOfInitializer // 引数の配列の型を宣言終了
    case startDictionaryTypeSyntaxOfInitializer // 引数の辞書の型を宣言開始
    case dictionaryKeyTypeOfInitializer // 辞書のKeyの型
    case dictionaryValueTypeOfInitializer // 辞書のValueの型
    case endDictionaryTypeSyntaxOfInitializer // 引数の辞書の型を宣言終了
    case startTupleTypeSyntaxOfInitializer // 引数のタプルの型を宣言開始
    case tupleTypeOfInitializer // タプルの型
    case endTupleTypeSyntaxOfInitializer // 引数のタプルの型を宣言終了
    case endInitializerParameter // 引数1つの宣言終了
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
        // protocol
        case .startProtocolDeclSyntax:
            return "StartProtocolDeclSyntax"
        case .protocolAccessLevel:
            return "ProtocolAccessLevel"
        case .protocolName:
            return "ProtocolName"
        case .startAssociatedtypeDeclSyntax:
            return "StartAssociatedtypeDeclSyntax"
        case .associatedType:
            return "AssociatedType"
        case .endAssociatedtypeDeclSyntax:
            return "EndAssociatedtypeDeclSyntax"
        case .endProtocolDeclSyntax:
            return "EndProtocolDeclSyntax"
        // プロトコルへの準拠
        case .startInheritedTypeListSyntax:
            return "StartInheritedTypeListSyntax"
        case .conformedProtocolByStruct:
            return "ConformedProtocolByStruct"
        case .conformedProtocolOrInheritedClassByClass:
            return "ConformedProtocolOrInheritedClassByClass"
        case .conformedProtocolByEnum:
            return "ConformedProtocolByEnum"
        case .conformedProtocolByProtocol:
            return "ConformedProtocolByProtocol"
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
        case .startArrayTypeSyntaxOfVariable:
            return "StartArrayTypeSyntaxOfVariable"
        case .arrayTypeOfVariable:
            return "ArrayTypeOfVariable"
        case .endArrayTypeSyntaxOfVariable:
            return "EndArrayTypeSyntaxOfVariable"
        case .startDictionaryTypeSyntaxOfVariable:
            return "StartDictionaryTypeSyntaxOfVariable"
        case .dictionaryKeyTypeOfVariable:
            return "DictionaryKeyTypeOfVariable"
        case .dictionaryValueTypeOfVariable:
            return "DictionaryValueTypeOfVariable"
        case .endDictionaryTypeSyntaxOfVariable:
            return "EndDictionaryTypeSyntaxOfVariable"
        case .startTupleTypeSyntaxOfVariable:
            return "StartTupleTypeSyntaxOfVariable"
        case .tupleTypeOfVariable:
            return "TupleTypeOfVariable"
        case .endTupleTypeSyntaxOfVariable:
            return "EndTupleTypeSyntaxOfVariable"
        case .isOptionalType:
            return "IsOptionalType"
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
        // function
        case .startFunctionDeclSyntax:
            return "StartFunctionDeclSyntax"
        case .functionAccessLevel:
            return "FunctionAccessLevel"
        case .isMutatingFunction:
            return "IsMutatingFunction"
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
        case .functionParameterType:
            return "FunctionParameterType"
        case .startArrayTypeSyntaxOfFunctionParameter:
            return "StartArrayTypeSyntaxOfFunctionParameter"
        case .arrayTypeOfFunctionParameter:
            return "ArrayTypeOfFunctionParameter"
        case .endArrayTypeSyntaxOfFunctionParameter:
            return "EndArrayTypeSyntaxOfFunctionParameter"
        case .startDictionaryTypeSyntaxOfFunctionParameter:
            return "StartDictionaryTypeSyntaxOfFunctionParameter"
        case .dictionaryKeyTypeOfFunctionParameter:
            return "DictionaryKeyTypeOfFunctionParameter"
        case .dictionaryValueTypeOfFunctionParameter:
            return "DictionaryValueTypeOfFunctionParameter"
        case .endDictionaryTypeSyntaxOfFunctionParameter:
            return "EndDictionaryTypeSyntaxOfFunctionParameter"
        case .startTupleTypeSyntaxOfFunctionParameter:
            return "StartTupleTypeSyntaxOfFunctionParameter"
        case .tupleTypeOfFunctionParameter:
            return "TupleTypeOfFunctionParameter"
        case .endTupleTypeSyntaxOfFunctionParameter:
            return "EndTupleTypeSyntaxOfFunctionParameter"
        case .initialValueOfParameter:
            return "InitialValueOfParameter"
        case .endFunctionParameterSyntax:
            return "EndFunctionParameterSyntax"
        case .startFunctionReturnValueType:
            return "StartFunctionReturnValueType"
        case .functionReturnValueType:
            return "FunctionReturnValueType"
        case .startArrayTypeSyntaxOfFunctionReturnValue:
            return "StartArrayTypeSyntaxOfFunctionReturnValue"
        case .arrayTypeOfFunctionReturnValue:
            return "ArrayTypeOfFunctionReturnValue"
        case .endArrayTypeSyntaxOfFunctionReturnValue:
            return "EndArrayTypeSyntaxOfFunctionReturnValue"
        case .startDictionaryTypeSyntaxOfFunctionReturnValue:
            return "StartDictionaryTypeSyntaxOfFunctionReturnValue"
        case .dictionaryKeyTypeOfFunctionReturnValue:
            return "DictionaryKeyTypeOfFunctionReturnValue"
        case .dictionaryValueTypeOfFunctionReturnValue:
            return "DictionaryValueTypeOfFunctionReturnValue"
        case .endDictionaryTypeSyntaxOfFunctionReturnValue:
            return "EndDictionaryTypeSyntaxOfFunctionReturnValue"
        case .startTupleTypeSyntaxOfFunctionReturnValue:
            return "StartTupleTypeSyntaxOfFunctionReturnValue"
        case .tupleTypeOfFunctionReturnValue:
            return "TupleTypeOfFunctionReturnValue"
        case .endTupleTypeSyntaxOfFunctionReturnValue:
            return "EndTupleTypeSyntaxOfFunctionReturnValue"
        case .endFunctionReturnValueType:
            return "EndFunctionReturnValueType"
        case .endFunctionDeclSyntax:
            return "EndFunctionDeclSyntax"
        // initializer
        case .startInitializerDeclSyntax:
            return "StartInitializerDeclSyntax"
        case .haveConvenienceKeyword:
            return "HaveConvenienceKeyword"
        case .isFailableInitializer:
            return "IsFailableInitializer"
        case .startInitializerParameter:
            return "StartInitializerParameter"
        case .initializerParameterName:
            return "InitializerParameterName"
        case .initializerParameterType:
            return "InitializerParameterType"
        case .startArrayTypeSyntaxOfInitializer:
            return "StartArrayTypeSyntaxOfInitializer"
        case .arrayTypeOfInitializer:
            return "arrayTypeOfInitializer"
        case .endArrayTypeSyntaxOfInitializer:
            return "EndArrayTypeSyntaxOfInitializer"
        case .startDictionaryTypeSyntaxOfInitializer:
            return "StartDictionaryTypeSyntaxOfInitializer"
        case .dictionaryKeyTypeOfInitializer:
            return "DictionaryKeyTypeOfInitializer"
        case .dictionaryValueTypeOfInitializer:
            return "DictionaryValueTypeOfInitializer"
        case .endDictionaryTypeSyntaxOfInitializer:
            return "EndDictionaryTypeSyntaxOfInitializer"
        case .startTupleTypeSyntaxOfInitializer:
            return "StartTupleTypeSyntaxOfInitializer"
        case .tupleTypeOfInitializer:
            return "TupleTypeOfInitializer"
        case .endTupleTypeSyntaxOfInitializer:
            return "EndTupleTypeSyntaxOfInitializer"
        case .endInitializerParameter:
            return "EndInitializerParameter"
        case .endInitializerDeclSyntax:
            return "EndInitializerDeclSyntax"
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
