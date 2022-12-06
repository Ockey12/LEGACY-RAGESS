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
        var holderTypeStackArray = [HolderType]()
        var positionInHolderTypeStackArray = -1
        
        var structHolderStackArray = [StructHolder]()
        var positionInStructHolderStackArray = -1
        
        // 解析して生成したHolderの生成順を記憶しておくスタック配列
        // 解析した全てのHolderを記憶し続けるわけではない
        // あるHolderをネストしている親Holderを記憶するために使う
//        var holderStackArray = [HolderStackArrayElement]()
        
        // holderStackArrayの現在の位置
//        var positionInHolderStackArray = -1
        
        // resultArrayの要素1つをスペースで分割した結果を保持する
        var parsedElementArray = [String]()
        
        // Holders辞書のKeyとなる、一意なID
        // あるHolderのKeyになったあと、インクリメントすることで一意を保つ
//        var IDCounter = -1
        
        // 各Holderの名前とインスタンスを保持する辞書
        // Key: 要素を格納するときのIDcounterの値
        // Value: Holderインスタンス
//        var structHolders = [Int: StructHolder]()
//        var classHolders = [Int: ClassHolder]()
//        var enumHolders = [Int: EnumHolder]()
//        var protocolHolders = [Int: ProtocolHolder]()
//        var variableHolders = [Int: VariableHolder]()
//        var functionHolders = [Int: FunctionHolder]()
//        var functionParameterHolders = [Int: FunctionParameterHolder]()
//        var initializerHolders = [Int: InitializerHolder]()
//        var initializerParameterHolders = [Int: InitializerParameterHolder]()
//        var extensionHolders = [Int: ExtensionHolder]()
        
        // 要素が宣言されてから、Holders辞書にインスタンスを格納するまでの間、一時的に情報を保持する
        // 名前より前の情報はこのプロパティに格納する
        // 名前を抽出した後、Holders辞書に格納する
//        var currentStructHolder = StructHolder()
//        var currentClassHolder = ClassHolder()
//        var currentEnumHolder = EnumHolder()
//        var currentProtocolHolder = ProtocolHolder()
//        var currentVariableHolder = VariableHolder()
//        var currentFunctionHolder = FunctionHolder()
//        var currentFunctionParameterHolder = FunctionParameterHolder()
//        var currentInitializerHolder = InitializerHolder()
//        var currentInitializerParameterHolder = InitializerParameterHolder()
//        var currentExtensionHolder = ExtensionHolder()
        
        // holderStackArrayの要素
//        struct HolderStackArrayElement {
//            var holderType: HolderType
//            var ID: Int
//        }
        
        print("-----SyntaxArrayParser.parseResultArray")
        // resultArrayに格納されているタグを1つずつ取り出して解析する
        for element in resultArray {
            print(element)
            
            // elementを" "で分割する
            // parsedElementArray[0]: SyntaxTag
            parsedElementArray = element.components(separatedBy: " ")
            
            // parsedElementArray[0]をSyntaxTag型にキャストする
            guard let syntaxTag = SyntaxTag(rawValue: parsedElementArray[0]) else {
                fatalError("ERROR: Failed to convert \"\(parsedElementArray[0])\" to SyntaxTag.")
            }
            
            // syntaxTagのcaseに応じた処理をする
            switch syntaxTag {
            case .StartStructDeclSyntax:
//                let id = publishNewID()
//                structHolders[id] = StructHolder(ID: id)
//                pushHolderStackArray(holderType: .struct)
                pushHolderTypeStackArray(.struct)
                structHolderStackArray.append(StructHolder())
                positionInStructHolderStackArray += 1
            case .StructAccessLevel:
//                currentStructHolder.accessLevel = convertParsedElementToAccessLevel()
                structHolderStackArray[positionInStructHolderStackArray].accessLevel = convertParsedElementToAccessLevel()
            case .StructName:
//                let id = getCurrentIDInHolderStackArray()
//                structHolders[id]?.name = parsedElementArray[1]
                structHolderStackArray[positionInStructHolderStackArray].name = parsedElementArray[1]
            case .EndStructDeclSyntax:
//                let id = getCurrentIDInHolderStackArray()
//                guard let structHolder = structHolders[id] else {
//                    fatalError("Failed to convert structHolders[id] to StructHolder")
//                }
//                resultStructHolders.append(structHolder)
//                popHolderStackArray()
                resultStructHolders.append(structHolderStackArray.last!)
                popHolderTypeStackArray()
                structHolderStackArray.removeLast()
                positionInStructHolderStackArray -= 1
            case .StartClassDeclSyntax:
//                let id = publishNewID()
//                classHolders[id] = ClassHolder(ID: id)
                break
            case .ClassAccessLevel:
//                currentClassHolder.accessLevel = convertParsedElementToAccessLevel()
                break
            case .ClassName:
                break
            case .EndClassDeclSyntax:
                break
            case .StartEnumDeclSyntax:
//                let id = publishNewID()
//                enumHolders[id] = EnumHolder(ID: id)
                break
            case .EnumAccessLevel:
//                currentEnumHolder.accessLevel = convertParsedElementToAccessLevel()
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
//                let id = publishNewID()
//                protocolHolders[id] = ProtocolHolder(ID: id)
                break
            case .ProtocolAccessLevel:
//                currentProtocolHolder.accessLevel = convertParsedElementToAccessLevel()
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
                structHolderStackArray[positionInStructHolderStackArray].conformingProtocolNames.append(parsedElementArray[1])
            case .ConformedProtocolOrInheritedClassByClass:
                break
            case .ConformedProtocolByEnum:
                break
            case .ConformedProtocolByProtocol:
                break
            case .EndInheritedTypeListSyntax:
                break
            case .StartVariableDeclSyntax:
//                let id = publishNewID()
//                variableHolders[id] = VariableHolder(ID: id)
                break
            case .VariableCustomAttribute:
                break
            case .IsStaticVariable:
                break
            case .LazyVariable:
                break
            case .VariableAccessLevel:
//                currentVariableHolder.accessLevel = convertParsedElementToAccessLevel()
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
//                let id = publishNewID()
//                functionHolders[id] = FunctionHolder(ID: id)
                break
            case .IsStaticFunction:
                break
            case .FunctionAccessLevel:
//                currentFunctionHolder.accessLevel = convertParsedElementToAccessLevel()
                break
            case .IsOverrideFunction:
                break
            case .IsMutatingFunction:
                break
            case .FunctionName:
                break
            case .StartFunctionParameterSyntax:
//                let id = publishNewID()
//                functionParameterHolders[id] = FunctionParameterHolder(ID: id)
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
//                let id = publishNewID()
//                initializerHolders[id] = InitializerHolder(ID: id)
                break
            case .HaveConvenienceKeyword:
                break
            case .IsFailableInitializer:
                break
            case .StartInitializerParameter:
//                let id = publishNewID()
//                initializerParameterHolders[id] = InitializerParameterHolder(ID: id)
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
//                let id = publishNewID()
//                extensionHolders[id] = ExtensionHolder(ID: id)
                break
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
            } // end switch syntaxTag
        } // end for resultArray
        print("---------------------------------------")
        
        // parsedElementArray[1]に格納されている文字列を、AccessLevel型にキャストして返す
        func convertParsedElementToAccessLevel() -> AccessLevel {
            let string = parsedElementArray[1]
            guard let accessLevel = AccessLevel(rawValue: string) else {
                fatalError("ERROR: Failed to convert \"\(string)\" to AccessLevel.")
            }
            return accessLevel
        } // end onvertParsedElementToAccessLevel()
        
        func pushHolderTypeStackArray(_ holderType: HolderType) {
            holderTypeStackArray.append(holderType)
            positionInHolderTypeStackArray += 1
        }
        
        func popHolderTypeStackArray() {
            holderTypeStackArray.removeLast()
            positionInHolderTypeStackArray -= 1
        }
        // IDCounterをインクリメントして返す
//        func publishNewID() -> Int {
//            IDCounter += 1
//            return IDCounter
//        }
        
        // 指定した種類のHolderを、HolderStackArrayにプッシュする
//        func pushHolderStackArray(holderType: HolderType) {
//            positionInHolderStackArray += 1
//            switch holderType {
//            case .struct:
//                guard let id = currentStructHolder.ID else {
//                    fatalError("ERROR: Failed to convert currentStructHolder.ID to Int.")
//                }
//                holderStackArray.append(HolderStackArrayElement(holderType: .struct, ID: id))
//            case .class:
//                guard let id = currentClassHolder.ID else {
//                    fatalError("ERROR: Failed to convert currentClassHolder.ID to Int.")
//                }
//                holderStackArray.append(HolderStackArrayElement(holderType: .class, ID: id))
//            case .enum:
//                guard let id = currentEnumHolder.ID else {
//                    fatalError("ERROR: Failed to convert currentEnumHolder.ID to Int.")
//                }
//                holderStackArray.append(HolderStackArrayElement(holderType: .enum, ID: id))
//            case .protocol:
//                guard let id = currentProtocolHolder.ID else {
//                    fatalError("ERROR: Failed to convert currentProtocolHolder.ID to Int.")
//                }
//                holderStackArray.append(HolderStackArrayElement(holderType: .protocol, ID: id))
//            case .variable:
//                guard let id = currentVariableHolder.ID else {
//                    fatalError("ERROR: Failed to convert currentVariableHolder.ID to Int.")
//                }
//                holderStackArray.append(HolderStackArrayElement(holderType: .variable, ID: id))
//            case .function:
//                guard let id = currentFunctionHolder.ID else {
//                    fatalError("ERROR: Failed to convert currentFunctionHolder.ID to Int.")
//                }
//                holderStackArray.append(HolderStackArrayElement(holderType: .function, ID: id))
//            case .functionParameter:
//                guard let id = currentFunctionParameterHolder.ID else {
//                    fatalError("ERROR: Failed to convert currentFunctionParameterHolder.ID to Int.")
//                }
//                holderStackArray.append(HolderStackArrayElement(holderType: .functionParameter, ID: id))
//            case .initializer:
//                guard let id = currentInitializerHolder.ID else {
//                    fatalError("ERROR: Failed to convert currentInitializerHolder.ID to Int.")
//                }
//                holderStackArray.append(HolderStackArrayElement(holderType: .initializer, ID: id))
//            case .initializerParameter:
//                guard let id = currentInitializerParameterHolder.ID else {
//                    fatalError("ERROR: Failed to convert currentInitializerParameterHolder.ID to Int.")
//                }
//                holderStackArray.append(HolderStackArrayElement(holderType: .initializerParameter, ID: id))
//            case .extension:
//                guard let id = currentExtensionHolder.ID else {
//                    fatalError("ERROR: Failed to convert currentExtensionHolder.ID to Int.")
//                }
//                holderStackArray.append(HolderStackArrayElement(holderType: .extension, ID: id))
//            }
//        } // end func pushHolderStackArray()
        
        // HolderStackArrayをポップする
//        func popHolderStackArray() {
//            holderStackArray.removeLast()
//            positionInHolderStackArray -= 1
//        } // end func popHolderStackArray()
        
        // holderStackArrayに直前に追加した要素のIDを返す
//        func getCurrentIDInHolderStackArray() -> Int {
//            let id = holderStackArray[positionInHolderStackArray].ID
//            return id
//        }
    } // end func parseResultArray()
    
    func getResultStructHolders() -> [StructHolder] {
        return resultStructHolders
    }
} // end struct SyntaxArrayParser
