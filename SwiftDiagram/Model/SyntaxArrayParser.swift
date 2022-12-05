//
//  SyntaxArrayParser.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

// TokenVisitorクラスが出力したresultArrayを解析し、各Holder構造体のインスタンスを生成する
struct SyntaxArrayParser {
    // 解析結果を保持する各Holderの配列
    private var resultStructHolders = [StructHolder]()
    private var resultClassHolders = [ClassHolder]()
    private var resultEnumHolders = [EnumHolder]()
    private var resultProtocolHolders = [ProtocolHolder]()
    private var resultVariableHolders = [VariableHolder]()
    private var resultFunctionHolders = [FunctionHolder]()
    private var resultExtensionHolders = [ExtensionHolder]()
    
    
    
    mutating func parseResultArray(resultArray: [String]) {
        // 解析して生成したHolderの生成順を記憶しておくスタック配列
        // 解析した全てのHolderを記憶し続けるわけではない
        // あるHolderをネストしている親Holderを記憶するために使う
        var holderStackArray = [HolderStackArrayElement]()
        
        // 各Holderの名前とインスタンスを保持する辞書
        // Key: Holder.name
        // Value: Holderインスタンス
        var structHolders = [String: StructHolder]()
        var classHolders = [String: ClassHolder]()
        var enumHolders = [String: EnumHolder]()
        var protocolHolders = [String: ProtocolHolder]()
        var variableHolders = [String: VariableHolder]()
        var functionHolders = [String: FunctionHolder]()
        var extensionHolders = [String: ExtensionHolder]()
        
        // 要素が宣言されてから、Holders辞書にインスタンスを格納するまでの間、一時的に情報を保持する
        // 名前より前の情報はこのプロパティに格納する
        // 名前を抽出した後、Holders辞書に格納する
        var currentStructHolder = StructHolder()
        var currentClassHolder = ClassHolder()
        var currentEnumHolder = EnumHolder()
        var currentProtocolHolder = ProtocolHolder()
        var currentVariableHolder = VariableHolder()
        var currentFunctionHolder = FunctionHolder()
        var currentExtensionHolder = ExtensionHolder()
        
        // holderStackArrayの要素
        struct HolderStackArrayElement {
            var holderType: HolderType
            var name: String
        }
        
        print("-----SyntaxArrayParser.parseResultArray")
        // resultArrayに格納されているタグを1つずつ取り出して解析する
        for element in resultArray {
            print(element)
            
            // elementを" "で分割する
            // parsedElementArray[0]: SyntaxTag
            let parsedElementArray = element.components(separatedBy: " ")
            
            // parsedElementArray[0]をSyntaxTag型にキャストする
            guard let syntaxTag = SyntaxTag(rawValue: parsedElementArray[0]) else {
                fatalError("ERROR: Failed to convert \"\(parsedElementArray[0])\" to SyntaxTag")
            }
            
            // syntaxTagのcaseに応じた処理をする
            switch syntaxTag {
            case .StartStructDeclSyntax:
                currentStructHolder = StructHolder()
            case .StructAccessLevel:
                break
            case .StructName:
                break
            case .EndStructDeclSyntax:
                break
            case .StartClassDeclSyntax:
                currentClassHolder = ClassHolder()
            case .ClassAccessLevel:
                break
            case .ClassName:
                break
            case .EndClassDeclSyntax:
                break
            case .StartEnumDeclSyntax:
                currentEnumHolder = EnumHolder()
            case .EnumAccessLevel:
                break
            case .EnumName:
                break
            case .RawvalueType:
                break
            case .Rawvalue:
                break
            case .CaseAssociatedValue:
                break
            case .StartEnumCaseElementSyntax:
                break
            case .EnumCase:
                break
            case .EndEnumCaseElementSyntax:
                break
            case .EndEnumDeclSyntax:
                break
            case .StartProtocolDeclSyntax:
                currentProtocolHolder = ProtocolHolder()
            case .ProtocolAccessLevel:
                break
            case .ProtocolName:
                break
            case .StartAssociatedtypeDeclSyntax:
                break
            case .AssociatedType:
                break
            case .ConformedProtocolOrInheritedClassByAssociatedType:
                break
            case .EndAssociatedtypeDeclSyntax:
                break
            case .EndProtocolDeclSyntax:
                break
            case .StartInheritedTypeListSyntax:
                break
            case .ConformedProtocolByStruct:
                break
            case .ConformedProtocolOrInheritedClassByClass:
                break
            case .ConformedProtocolByEnum:
                break
            case .ConformedProtocolByProtocol:
                break
            case .EndInheritedTypeListSyntax:
                break
            case .StartVariableDeclSyntax:
                currentVariableHolder = VariableHolder()
            case .VariableCustomAttribute:
                break
            case .IsStaticVariable:
                break
            case .LazyVariable:
                break
            case .VariableAccessLevel:
                break
            case .HaveLetKeyword:
                break
            case .VariableName:
                break
            case .VariableType:
                break
            case .StartArrayTypeSyntaxOfVariable:
                break
            case .ArrayTypeOfVariable:
                break
            case .EndArrayTypeSyntaxOfVariable:
                break
            case .StartDictionaryTypeSyntaxOfVariable:
                break
            case .DictionaryKeyTypeOfVariable:
                break
            case .DictionaryValueTypeOfVariable:
                break
            case .EndDictionaryTypeSyntaxOfVariable:
                break
            case .StartTupleTypeSyntaxOfVariable:
                break
            case .TupleTypeOfVariable:
                break
            case .EndTupleTypeSyntaxOfVariable:
                break
            case .ConformedProtocolByOpaqueResultTypeOfVariable:
                break
            case .IsOptionalType:
                break
            case .InitialValueOfVariable:
                break
            case .HaveWillSet:
                break
            case .HaveDidSet:
                break
            case .HaveGetter:
                break
            case .HaveSetter:
                break
            case .EndVariableDeclSyntax:
                break
            case .StartFunctionDeclSyntax:
                currentFunctionHolder = FunctionHolder()
            case .IsStaticFunction:
                break
            case .FunctionAccessLevel:
                break
            case .IsOverrideFunction:
                break
            case .IsMutatingFunction:
                break
            case .FunctionName:
                break
            case .StartFunctionParameterSyntax:
                break
            case .ExternalParameterName:
                break
            case .InternalParameterName:
                break
            case .HaveInoutKeyword:
                break
            case .IsVariadicParameter:
                break
            case .FunctionParameterType:
                break
            case .StartArrayTypeSyntaxOfFunctionParameter:
                break
            case .ArrayTypeOfFunctionParameter:
                break
            case .EndArrayTypeSyntaxOfFunctionParameter:
                break
            case .StartDictionaryTypeSyntaxOfFunctionParameter:
                break
            case .DictionaryKeyTypeOfFunctionParameter:
                break
            case .DictionaryValueTypeOfFunctionParameter:
                break
            case .EndDictionaryTypeSyntaxOfFunctionParameter:
                break
            case .StartTupleTypeSyntaxOfFunctionParameter:
                break
            case .TupleTypeOfFunctionParameter:
                break
            case .EndTupleTypeSyntaxOfFunctionParameter:
                break
            case .InitialValueOfParameter:
                break
            case .EndFunctionParameterSyntax:
                break
            case .StartFunctionReturnValueType:
                break
            case .FunctionReturnValueType:
                break
            case .StartArrayTypeSyntaxOfFunctionReturnValue:
                break
            case .ArrayTypeOfFunctionReturnValue:
                break
            case .EndArrayTypeSyntaxOfFunctionReturnValue:
                break
            case .StartDictionaryTypeSyntaxOfFunctionReturnValue:
                break
            case .DictionaryKeyTypeOfFunctionReturnValue:
                break
            case .DictionaryValueTypeOfFunctionReturnValue:
                break
            case .EndDictionaryTypeSyntaxOfFunctionReturnValue:
                break
            case .StartTupleTypeSyntaxOfFunctionReturnValue:
                break
            case .TupleTypeOfFunctionReturnValue:
                break
            case .EndTupleTypeSyntaxOfFunctionReturnValue:
                break
            case .ConformedProtocolByOpaqueResultTypeOfFunctionReturnValue:
                break
            case .EndFunctionReturnValueType:
                break
            case .EndFunctionDeclSyntax:
                break
            case .StartInitializerDeclSyntax:
                break
            case .HaveConvenienceKeyword:
                break
            case .IsFailableInitializer:
                break
            case .StartInitializerParameter:
                break
            case .InitializerParameterName:
                break
            case .InitializerParameterType:
                break
            case .StartArrayTypeSyntaxOfInitializer:
                break
            case .ArrayTypeOfInitializer:
                break
            case .EndArrayTypeSyntaxOfInitializer:
                break
            case .StartDictionaryTypeSyntaxOfInitializer:
                break
            case .DictionaryKeyTypeOfInitializer:
                break
            case .DictionaryValueTypeOfInitializer:
                break
            case .EndDictionaryTypeSyntaxOfInitializer:
                break
            case .StartTupleTypeSyntaxOfInitializer:
                break
            case .TupleTypeOfInitializer:
                break
            case .EndTupleTypeSyntaxOfInitializer:
                break
            case .EndInitializerParameter:
                break
            case .EndInitializerDeclSyntax:
                break
            case .StartExtensionDeclSyntax:
                currentExtensionHolder = ExtensionHolder()
            case .EndExtensionDeclSyntax:
                break
            case .ConformedProtocolByExtension:
                break
            case .StartGenericParameterSyntax:
                break
            case .ParameterTypeOfGenerics:
                break
            case .ConformedProtocolOrInheritedClassByGenerics:
                break
            case .EndGenericParameterSyntax:
                break
            case .StartTypealiasDecl:
                break
            case .TypealiasAssociatedTypeName:
                break
            case .TypealiasType:
                break
            case .StartArrayTypeSyntaxOfTypealias:
                break
            case .ArrayTypeOfTypealias:
                break
            case .EndArrayTypeSyntaxOfTypealias:
                break
            case .StartDictionaryTypeSyntaxOfTypealias:
                break
            case .DictionaryKeyTypeOfTypealias:
                break
            case .DictionaryValueTypeOfTypealias:
                break
            case .EndDictionaryTypeSyntaxOfTypealias:
                break
            case .StartTupleTypeSyntaxOfTypealias:
                break
            case .TupleTypeOfTypealias:
                break
            case .EndTupleTypeSyntaxOfTypealias:
                break
            case .EndTypealiasDecl:
                break
            case .Space:
                break
            }
        }
        print("---------------------------------------")
    }
}
