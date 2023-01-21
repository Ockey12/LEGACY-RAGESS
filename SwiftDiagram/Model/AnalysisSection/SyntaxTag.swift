//
//  SyntaxTag.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/18.
//

import Foundation

// TokenVisitorクラスでresultArray配列に格納するタグ
enum SyntaxTag: String {
    // struct
    case StartStructDeclSyntax // structの宣言開始
    case StructAccessLevel // structのアクセスレベル
    case StructName // structの名前
    case EndStructDeclSyntax // structの宣言終了
    
    // class
    case StartClassDeclSyntax // classの宣言開始
    case ClassAccessLevel // classのアクセスレベル
    case ClassName // classの名前
    case EndClassDeclSyntax // classの宣言終了
    
    // enum
    case StartEnumDeclSyntax // enumの宣言開始
    case EnumAccessLevel // enumのアクセスレベル
    case EnumName // enumの名前
    case RawvalueType // ローバリューの型
    case Rawvalue // ローバリューの値
    case CaseAssociatedValue // caseの連想値
    case StartEnumCaseElementSyntax // enumのcaseを宣言開始
    case EnumCase // enumのcase
    case EndEnumCaseElementSyntax // enumのcaseを宣言終了
    case EndEnumDeclSyntax // enumの宣言終了
    
    // protocol
    case StartProtocolDeclSyntax // protocolの宣言開始
    case ProtocolAccessLevel // protocolのアクセスレベル
    case ProtocolName // protocolの名前
    case StartAssociatedtypeDeclSyntax // 連想型の宣言開始
    case AssociatedType // 連想型の名前
    case ConformedProtocolOrInheritedClassByAssociatedType // 連想型の型制約で指定するプロトコルかスーパークラス
    case EndAssociatedtypeDeclSyntax // 連想型の宣言終了
    case EndProtocolDeclSyntax // protocolの宣言終了
    
    // プロトコルへの準拠
    case StartInheritedTypeListSyntax // プロトコルへの準拠開始
    case ConformedProtocolByStruct // structが準拠しているプロトコル
    case ConformedProtocolOrInheritedClassByClass // classが準拠しているプロトコル、または継承しているクラス
    case ConformedProtocolByEnum // enumが準拠しているプロトコル
    case ConformedProtocolByProtocol // protocolが準拠しているprotocol
    case EndInheritedTypeListSyntax // プロトコルへの準拠終了
    
    // variable
    case StartVariableDeclSyntax // 変数の宣言開始
//    case startCustomAttributeSyntax // @Stateなどの宣言開始
//    case endCustomAttributeSyntax // @Stateなどの宣言終了
    case VariableCustomAttribute // 後ろに@Stateなどの名前を持つ
    case IsStaticVariable // staticキーワードを持つvariable
    case LazyVariable // lazyキーワードをもつvariable
    case VariableAccessLevel // 変数のアクセスレベル
    case HaveLetKeyword // 定数のとき
    case VariableName // 変数の名前を後ろに持つ
    case VariableType // variableの型
    case StartArrayTypeSyntaxOfVariable // variableの配列の型を宣言開始
    case ArrayTypeOfVariable // 配列の型
    case EndArrayTypeSyntaxOfVariable // variableの配列の型を宣言終了
    case StartDictionaryTypeSyntaxOfVariable // variableの辞書の型を宣言開始
    case DictionaryKeyTypeOfVariable // 辞書のKeyの型
    case DictionaryValueTypeOfVariable // 辞書のValueの型
    case EndDictionaryTypeSyntaxOfVariable // variableの辞書の型を宣言終了
    case StartTupleTypeSyntaxOfVariable // variableのタプルの型を宣言開始
    case TupleTypeOfVariable // タプルの型
    case EndTupleTypeSyntaxOfVariable // variableのタプルの型を宣言終了
    case ConformedProtocolByOpaqueResultTypeOfVariable // variableの型がopaque result typeのとき、それが準拠するprotocol
    case IsOptionalType // optional型である
    case InitialValueOfVariable // variableの初期値
    case HaveWillSet // willSetを持つvariable
    case HaveDidSet // didSetを持つvariable
    case HaveGetter // getを持つvariable
    case HaveSetter // setを持つvariable
    case EndVariableDeclSyntax // 変数の宣言終了
    
    // function
    case StartFunctionDeclSyntax // functionの宣言開始
    case IsStaticFunction // staticキーワードを持つfunction
    case FunctionAccessLevel // functionのアクセスレベル
    case IsOverrideFunction // overrideキーワードを持つ
    case IsMutatingFunction // mutatingキーワードを持つ
    case FunctionName // functionの名前
    case StartFunctionParameterSyntax // functionの個々の引数を宣言開始
    case ExternalParameterName // functionの外部引数名
    case InternalParameterName // functionの内部引数名
    case HaveInoutKeyword // inoutキーワードを持つ
    case IsVariadicParameter // 可変長引数である
    case FunctionParameterType // 引数の型
    case StartArrayTypeSyntaxOfFunctionParameter // 引数の配列の型を宣言開始
    case ArrayTypeOfFunctionParameter // 引数の配列の型
    case EndArrayTypeSyntaxOfFunctionParameter // 引数の配列の型を宣言終了
    case StartDictionaryTypeSyntaxOfFunctionParameter // 引数の辞書の型を宣言開始
    case DictionaryKeyTypeOfFunctionParameter // 引数の辞書のKeyの型
    case DictionaryValueTypeOfFunctionParameter // 引数の辞書のValueの型
    case EndDictionaryTypeSyntaxOfFunctionParameter // 引数の辞書の型を宣言終了
    case StartTupleTypeSyntaxOfFunctionParameter // 引数のタプルの型を宣言開始
    case TupleTypeOfFunctionParameter // 引数のタプルの型
    case EndTupleTypeSyntaxOfFunctionParameter // 引数のタプルの型を宣言終了
    case InitialValueOfFunctionParameter // デフォルト引数のデフォルト値
    case EndFunctionParameterSyntax // functionの個々の引数を宣言終了
    case StartFunctionReturnValueType // functionの返り値の型の宣言開始
    case FunctionReturnValueType // functionの返り値の型
    case StartArrayTypeSyntaxOfFunctionReturnValue // 返り値の配列の型を宣言開始
    case ArrayTypeOfFunctionReturnValue // 返り値の配列の型
    case EndArrayTypeSyntaxOfFunctionReturnValue // 返り値の配列の型を宣言終了
    case StartDictionaryTypeSyntaxOfFunctionReturnValue // 返り値の辞書の型を宣言開始
    case DictionaryKeyTypeOfFunctionReturnValue // 返り値の辞書のKeyの型
    case DictionaryValueTypeOfFunctionReturnValue // 返り値の辞書のValueの型
    case EndDictionaryTypeSyntaxOfFunctionReturnValue // 返り値の辞書の型を宣言終了
    case StartTupleTypeSyntaxOfFunctionReturnValue // 返り値のタプルの型を宣言開始
    case TupleTypeOfFunctionReturnValue // 返り値のタプルの型
    case EndTupleTypeSyntaxOfFunctionReturnValue // 返り値のタプルの型を宣言終了
    case ConformedProtocolByOpaqueResultTypeOfFunctionReturnValue // 返り値の型がopaque result typeのとき、それが準拠するprotocol
    case EndFunctionReturnValueType // functionの返り値の型の宣言終了
    case EndFunctionDeclSyntax // functionの宣言終了
    
    // initializer
    case StartInitializerDeclSyntax // initializerの宣言開始
    case HaveConvenienceKeyword // convenience initializerである
    case IsFailableInitializer // 失敗可能イニシャライザである
    case StartInitializerParameter // 引数1つの宣言開始
    case InitializerParameterName // 引数名
    case InitializerParameterType // 引数の型
    case StartArrayTypeSyntaxOfInitializer // 引数の配列の型を宣言開始
    case ArrayTypeOfInitializer // 配列の型
    case EndArrayTypeSyntaxOfInitializer // 引数の配列の型を宣言終了
    case StartDictionaryTypeSyntaxOfInitializer // 引数の辞書の型を宣言開始
    case DictionaryKeyTypeOfInitializer // 辞書のKeyの型
    case DictionaryValueTypeOfInitializer // 辞書のValueの型
    case EndDictionaryTypeSyntaxOfInitializer // 引数の辞書の型を宣言終了
    case StartTupleTypeSyntaxOfInitializer // 引数のタプルの型を宣言開始
    case TupleTypeOfInitializer // タプルの型
    case EndTupleTypeSyntaxOfInitializer // 引数のタプルの型を宣言終了
    case InitialValueOfInitializerParameter // デフォルト引数のデフォルト値
    case EndInitializerParameter // 引数1つの宣言終了
    case EndInitializerDeclSyntax // initializerの宣言終了
    
    // extension
    case StartExtensionDeclSyntax // extensionの宣言開始
    case ExtensiondTypeName // 拡張される型の名前
    case ConformedProtocolByExtension // extensionで準拠しているprotocol名
    case EndExtensionDeclSyntax // extensionの宣言終了
    
    // generics
    case StartGenericParameterSyntax // genericsの型引数の宣言開始
    case ParameterTypeOfGenerics // 型引数名
    case ConformedProtocolOrInheritedClassByGenerics // 型引数が準拠しているprotocol、または継承しているclass
    case EndGenericParameterSyntaxOf // genericsの型引数の宣言終了
    
    // typealias
    case StartTypealiasDecl // typealiasの宣言開始
    case TypealiasAssociatedTypeName // 連想型の名前
    case TypealiasType // 連想型に指定する型
    case StartArrayTypeSyntaxOfTypealias // typealiasの配列の型を宣言開始
    case ArrayTypeOfTypealias // 配列の型
    case EndArrayTypeSyntaxOfTypealias // typealiasの配列の型を宣言終了
    case StartDictionaryTypeSyntaxOfTypealias // typealiasの辞書の型を宣言開始
    case DictionaryKeyTypeOfTypealias // 辞書のKeyの型
    case DictionaryValueTypeOfTypealias // 辞書のValueの型
    case EndDictionaryTypeSyntaxOfTypealias // typealiasの辞書の型を宣言終了
    case StartTupleTypeSyntaxOfTypealias // typealiasのタプルの型を宣言開始
    case TupleTypeOfTypealias // タプルの型
    case EndTupleTypeSyntaxOfTypealias // typealiasのタプルの型を宣言終了
    case EndTypealiasDecl // typealiasの宣言終了
    
    case Space // タグとタグの間のスペース
    
    var string: String {
        switch self {
        // struct
        case .StartStructDeclSyntax:
            return "StartStructDeclSyntax"
        case .StructAccessLevel:
            return "StructAccessLevel"
        case .StructName:
            return "StructName"
        case .EndStructDeclSyntax:
            return "EndStructDeclSyntax"
        // class
        case .StartClassDeclSyntax:
            return "StartClassDeclSyntax"
        case .ClassAccessLevel:
            return "ClassAccessLevel"
        case .ClassName:
            return "ClassName"
        case .EndClassDeclSyntax:
            return "EndClassDeclSyntax"
        // enum
        case .StartEnumDeclSyntax:
            return "StartEnumDeclSyntax"
        case .EnumAccessLevel:
            return "EnumAccessLevel"
        case .EnumName:
            return "EnumName"
        case .RawvalueType:
            return "RawvalueType"
        case .Rawvalue:
            return "Rawvalue"
        case .CaseAssociatedValue:
            return "CaseAssociatedValue"
        case .StartEnumCaseElementSyntax:
            return "StartEnumCaseElementSyntax"
        case .EnumCase:
            return "EnumCase"
        case .EndEnumCaseElementSyntax:
            return "EndEnumCaseElementSyntax"
        case .EndEnumDeclSyntax:
            return "EndEnumDeclSyntax"
        // protocol
        case .StartProtocolDeclSyntax:
            return "StartProtocolDeclSyntax"
        case .ProtocolAccessLevel:
            return "ProtocolAccessLevel"
        case .ProtocolName:
            return "ProtocolName"
        case .StartAssociatedtypeDeclSyntax:
            return "StartAssociatedtypeDeclSyntax"
        case .AssociatedType:
            return "AssociatedType"
        case .ConformedProtocolOrInheritedClassByAssociatedType:
            return "ConformedProtocolOrInheritedClassByAssociatedType"
        case .EndAssociatedtypeDeclSyntax:
            return "EndAssociatedtypeDeclSyntax"
        case .EndProtocolDeclSyntax:
            return "EndProtocolDeclSyntax"
        // プロトコルへの準拠
        case .StartInheritedTypeListSyntax:
            return "StartInheritedTypeListSyntax"
        case .ConformedProtocolByStruct:
            return "ConformedProtocolByStruct"
        case .ConformedProtocolOrInheritedClassByClass:
            return "ConformedProtocolOrInheritedClassByClass"
        case .ConformedProtocolByEnum:
            return "ConformedProtocolByEnum"
        case .ConformedProtocolByProtocol:
            return "ConformedProtocolByProtocol"
        case .EndInheritedTypeListSyntax:
            return "EndInheritedTypeListSyntax"
        // variable
        case .StartVariableDeclSyntax:
            return "StartVariableDeclSyntax"
        case .VariableCustomAttribute:
            return "VariableCustomAttribute"
        case .IsStaticVariable:
            return "IsStaticVariable"
        case .LazyVariable:
            return "LazyVariable"
        case .VariableAccessLevel:
            return "VariableAccessLevel"
        case .HaveLetKeyword:
            return "HaveLetKeyword"
        case .VariableName:
            return "VariableName"
        case .VariableType:
            return "VariableType"
        case .StartArrayTypeSyntaxOfVariable:
            return "StartArrayTypeSyntaxOfVariable"
        case .ArrayTypeOfVariable:
            return "ArrayTypeOfVariable"
        case .EndArrayTypeSyntaxOfVariable:
            return "EndArrayTypeSyntaxOfVariable"
        case .StartDictionaryTypeSyntaxOfVariable:
            return "StartDictionaryTypeSyntaxOfVariable"
        case .DictionaryKeyTypeOfVariable:
            return "DictionaryKeyTypeOfVariable"
        case .DictionaryValueTypeOfVariable:
            return "DictionaryValueTypeOfVariable"
        case .EndDictionaryTypeSyntaxOfVariable:
            return "EndDictionaryTypeSyntaxOfVariable"
        case .StartTupleTypeSyntaxOfVariable:
            return "StartTupleTypeSyntaxOfVariable"
        case .TupleTypeOfVariable:
            return "TupleTypeOfVariable"
        case .EndTupleTypeSyntaxOfVariable:
            return "EndTupleTypeSyntaxOfVariable"
        case .ConformedProtocolByOpaqueResultTypeOfVariable:
            return "ConformedProtocolByOpaqueResultTypeOfVariable"
        case .IsOptionalType:
            return "IsOptionalType"
        case .InitialValueOfVariable:
            return "InitialValueOfVariable"
        case .HaveWillSet:
            return "HaveWillSet"
        case .HaveDidSet:
            return "HaveDidSet"
        case .HaveGetter:
            return "HaveGetter"
        case .HaveSetter:
            return "HaveSetter"
        case .EndVariableDeclSyntax:
            return "EndVariableDeclSyntax"
        // function
        case .StartFunctionDeclSyntax:
            return "StartFunctionDeclSyntax"
        case .IsStaticFunction:
            return "IsStaticFunction"
        case .FunctionAccessLevel:
            return "FunctionAccessLevel"
        case .IsOverrideFunction:
            return "IsOverrideFunction"
        case .IsMutatingFunction:
            return "IsMutatingFunction"
        case .FunctionName:
            return "FunctionName"
        case .StartFunctionParameterSyntax:
            return "StartFunctionParameterSyntax"
        case .ExternalParameterName:
            return "ExternalParameterName"
        case .InternalParameterName:
            return "InternalParameterName"
        case .HaveInoutKeyword:
            return "HaveInoutKeyword"
        case .IsVariadicParameter:
            return "IsVariadicParameter"
        case .FunctionParameterType:
            return "FunctionParameterType"
        case .StartArrayTypeSyntaxOfFunctionParameter:
            return "StartArrayTypeSyntaxOfFunctionParameter"
        case .ArrayTypeOfFunctionParameter:
            return "ArrayTypeOfFunctionParameter"
        case .EndArrayTypeSyntaxOfFunctionParameter:
            return "EndArrayTypeSyntaxOfFunctionParameter"
        case .StartDictionaryTypeSyntaxOfFunctionParameter:
            return "StartDictionaryTypeSyntaxOfFunctionParameter"
        case .DictionaryKeyTypeOfFunctionParameter:
            return "DictionaryKeyTypeOfFunctionParameter"
        case .DictionaryValueTypeOfFunctionParameter:
            return "DictionaryValueTypeOfFunctionParameter"
        case .EndDictionaryTypeSyntaxOfFunctionParameter:
            return "EndDictionaryTypeSyntaxOfFunctionParameter"
        case .StartTupleTypeSyntaxOfFunctionParameter:
            return "StartTupleTypeSyntaxOfFunctionParameter"
        case .TupleTypeOfFunctionParameter:
            return "TupleTypeOfFunctionParameter"
        case .EndTupleTypeSyntaxOfFunctionParameter:
            return "EndTupleTypeSyntaxOfFunctionParameter"
        case .InitialValueOfFunctionParameter:
            return "InitialValueOfFunctionParameter"
        case .EndFunctionParameterSyntax:
            return "EndFunctionParameterSyntax"
        case .StartFunctionReturnValueType:
            return "StartFunctionReturnValueType"
        case .FunctionReturnValueType:
            return "FunctionReturnValueType"
        case .StartArrayTypeSyntaxOfFunctionReturnValue:
            return "StartArrayTypeSyntaxOfFunctionReturnValue"
        case .ArrayTypeOfFunctionReturnValue:
            return "ArrayTypeOfFunctionReturnValue"
        case .EndArrayTypeSyntaxOfFunctionReturnValue:
            return "EndArrayTypeSyntaxOfFunctionReturnValue"
        case .StartDictionaryTypeSyntaxOfFunctionReturnValue:
            return "StartDictionaryTypeSyntaxOfFunctionReturnValue"
        case .DictionaryKeyTypeOfFunctionReturnValue:
            return "DictionaryKeyTypeOfFunctionReturnValue"
        case .DictionaryValueTypeOfFunctionReturnValue:
            return "DictionaryValueTypeOfFunctionReturnValue"
        case .EndDictionaryTypeSyntaxOfFunctionReturnValue:
            return "EndDictionaryTypeSyntaxOfFunctionReturnValue"
        case .StartTupleTypeSyntaxOfFunctionReturnValue:
            return "StartTupleTypeSyntaxOfFunctionReturnValue"
        case .TupleTypeOfFunctionReturnValue:
            return "TupleTypeOfFunctionReturnValue"
        case .EndTupleTypeSyntaxOfFunctionReturnValue:
            return "EndTupleTypeSyntaxOfFunctionReturnValue"
        case .ConformedProtocolByOpaqueResultTypeOfFunctionReturnValue:
            return "ConformedProtocolByOpaqueResultTypeOfFunctionReturnValue"
        case .EndFunctionReturnValueType:
            return "EndFunctionReturnValueType"
        case .EndFunctionDeclSyntax:
            return "EndFunctionDeclSyntax"
        // initializer
        case .StartInitializerDeclSyntax:
            return "StartInitializerDeclSyntax"
        case .HaveConvenienceKeyword:
            return "HaveConvenienceKeyword"
        case .IsFailableInitializer:
            return "IsFailableInitializer"
        case .StartInitializerParameter:
            return "StartInitializerParameter"
        case .InitializerParameterName:
            return "InitializerParameterName"
        case .InitializerParameterType:
            return "InitializerParameterType"
        case .StartArrayTypeSyntaxOfInitializer:
            return "StartArrayTypeSyntaxOfInitializer"
        case .ArrayTypeOfInitializer:
            return "ArrayTypeOfInitializer"
        case .EndArrayTypeSyntaxOfInitializer:
            return "EndArrayTypeSyntaxOfInitializer"
        case .StartDictionaryTypeSyntaxOfInitializer:
            return "StartDictionaryTypeSyntaxOfInitializer"
        case .DictionaryKeyTypeOfInitializer:
            return "DictionaryKeyTypeOfInitializer"
        case .DictionaryValueTypeOfInitializer:
            return "DictionaryValueTypeOfInitializer"
        case .EndDictionaryTypeSyntaxOfInitializer:
            return "EndDictionaryTypeSyntaxOfInitializer"
        case .StartTupleTypeSyntaxOfInitializer:
            return "StartTupleTypeSyntaxOfInitializer"
        case .TupleTypeOfInitializer:
            return "TupleTypeOfInitializer"
        case .EndTupleTypeSyntaxOfInitializer:
            return "EndTupleTypeSyntaxOfInitializer"
        case .InitialValueOfInitializerParameter:
            return "InitialValueOfInitializerParameter"
        case .EndInitializerParameter:
            return "EndInitializerParameter"
        case .EndInitializerDeclSyntax:
            return "EndInitializerDeclSyntax"
        // extension
        case .StartExtensionDeclSyntax:
            return "StartExtensionDeclSyntax"
        case .ConformedProtocolByExtension:
            return "ConformedProtocolByExtension"
        case .ExtensiondTypeName:
            return "ExtensiondTypeName"
        case .EndExtensionDeclSyntax:
            return "EndExtensionDeclSyntax"
        // generics
        case .StartGenericParameterSyntax:
            return "StartGenericParameterSyntax"
        case .ParameterTypeOfGenerics:
            return "ParameterTypeOfGenerics"
        case .ConformedProtocolOrInheritedClassByGenerics:
            return "ConformedProtocolOrInheritedClassByGenerics"
        case .EndGenericParameterSyntaxOf:
            return "EndGenericParameterSyntaxOf"
        // typealias
        case .StartTypealiasDecl:
            return "StartTypealiasDecl"
        case .TypealiasAssociatedTypeName:
            return "TypealiasAssociatedTypeName"
        case .TypealiasType:
            return "TypealiasType"
        case .StartArrayTypeSyntaxOfTypealias:
            return "StartArrayTypeSyntaxOfTypealias"
        case .ArrayTypeOfTypealias:
            return "ArrayTypeOfTypealias"
        case .EndArrayTypeSyntaxOfTypealias:
            return "EndArrayTypeSyntaxOfTypealias"
        case .StartDictionaryTypeSyntaxOfTypealias:
            return "StartDictionaryTypeSyntaxOfTypealias"
        case .DictionaryKeyTypeOfTypealias:
            return "DictionaryKeyTypeOfTypealias"
        case .DictionaryValueTypeOfTypealias:
            return "DictionaryValueTypeOfTypealias"
        case .EndDictionaryTypeSyntaxOfTypealias:
            return "EndDictionaryTypeSyntaxOfTypealias"
        case .StartTupleTypeSyntaxOfTypealias:
            return "StartTupleTypeSyntaxOfTypealias"
        case .TupleTypeOfTypealias:
            return "TupleTypeOfTypealias"
        case .EndTupleTypeSyntaxOfTypealias:
            return "EndTupleTypeSyntaxOfTypealias"
        case .EndTypealiasDecl:
            return "EndTypealiasDecl"
            
        case .Space:
            return " "
        }
    }
}
