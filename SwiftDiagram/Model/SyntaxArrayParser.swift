//
//  SyntaxArrayParser.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

// TokenVisitorクラスが出力したresultArrayを解析し、各Holder構造体のインスタンスを生成する
struct SyntaxArrayParser {
    let classNameArray: [String]
    
    init(classNameArray: [String]) {
        self.classNameArray = classNameArray
    }
    // 解析結果を保持する各Holderの配列
    private var resultStructHolders = [StructHolder]()
    private var resultClassHolders = [ClassHolder]()
    private var resultEnumHolders = [EnumHolder]()
    private var resultProtocolHolders = [ProtocolHolder]()
    private var resultVariableHolders = [VariableHolder]()
    private var resultFunctionHolders = [FunctionHolder]()
    private var resultExtensionHolders = [ExtensionHolder]()
    
    // 型の依存関係を保持する
    private var whomThisTypeAffectDict = [String: WhomThisTypeAffect]()
    
    // 抽出した全ての型の名前を保持する
    private var allTypeNames = [String]()
    
    var holderTypeStackArray = [HolderType]()
    var positionInHolderTypeStackArray = -1
    
    var structHolderStackArray = [StructHolder]()
    var positionInStructHolderStackArray = -1
    
    var classHolderStackArray = [ClassHolder]()
    var positionInClassHolderStackArray = -1
    
    var variableHolderStackArray = [VariableHolder]()
    var positionInVariableHolderStackArray = -1
    
    
    mutating func parseResultArray(resultArray: [String]) {
        // 変数の初期化
        allTypeNames = []
        
        holderTypeStackArray = []
        positionInHolderTypeStackArray = -1
        
        structHolderStackArray = []
        positionInStructHolderStackArray = -1
        
        variableHolderStackArray = []
        positionInVariableHolderStackArray = -1
        
        // resultArrayの要素1つをスペースで分割した結果を保持する
        var parsedElementArray = [String]()
        
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
            superSwitch: switch syntaxTag {
            // structの宣言
            case .StartStructDeclSyntax:
                pushHolderTypeStackArray(.struct)
                structHolderStackArray.append(StructHolder())
                positionInStructHolderStackArray += 1
            case .StructAccessLevel:
                structHolderStackArray[positionInStructHolderStackArray].accessLevel = convertParsedElementToAccessLevel()
            case .StructName:
                let name = parsedElementArray[1]
                structHolderStackArray[positionInStructHolderStackArray].name = name
                allTypeNames.append(name)
            case .EndStructDeclSyntax:
                resultStructHolders.append(structHolderStackArray.last!)
                popHolderTypeStackArray()
                structHolderStackArray.removeLast()
                positionInStructHolderStackArray -= 1
            // classの宣言
            case .StartClassDeclSyntax:
                pushHolderTypeStackArray(.class)
                classHolderStackArray.append(ClassHolder())
                positionInClassHolderStackArray += 1
                break
            case .ClassAccessLevel:
                classHolderStackArray[positionInClassHolderStackArray].accessLevel = convertParsedElementToAccessLevel()
            case .ClassName:
                let name = parsedElementArray[1]
                classHolderStackArray[positionInClassHolderStackArray].name = name
                allTypeNames.append(name)
            case .EndClassDeclSyntax:
                resultClassHolders.append(classHolderStackArray.last!)
                popHolderTypeStackArray()
                classHolderStackArray.removeLast()
                positionInClassHolderStackArray -= 1
            // enumの宣言
            case .StartEnumDeclSyntax:
                break
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
                break
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
            // プロトコルへの準拠、スーパークラスの継承
            case .ConformedProtocolByStruct:
                let protocolName = parsedElementArray[1]
                let structName = structHolderStackArray[positionInStructHolderStackArray].name
                structHolderStackArray[positionInStructHolderStackArray].conformingProtocolNames.append(protocolName)
                extractingDependencies(affectingTypeName: protocolName, affectedTypeName: structName)
            case .ConformedProtocolOrInheritedClassByClass:
                let protocolName = parsedElementArray[1]
                let className = classHolderStackArray[positionInClassHolderStackArray].name
                for superClass in classNameArray {
                    if protocolName == superClass {
                        classHolderStackArray[positionInClassHolderStackArray].superClassName = protocolName
                        extractingDependencies(affectingTypeName: protocolName, affectedTypeName: className)
                        break superSwitch
                    }
                }
                classHolderStackArray[positionInClassHolderStackArray].conformingProtocolNames.append(protocolName)
                extractingDependencies(affectingTypeName: protocolName, affectedTypeName: className)
            case .ConformedProtocolByEnum:
                break
            case .ConformedProtocolByProtocol:
                break
            case .EndInheritedTypeListSyntax:
                break
            // variableの宣言
            case .StartVariableDeclSyntax:
                pushHolderTypeStackArray(.variable)
                variableHolderStackArray.append(VariableHolder())
                positionInVariableHolderStackArray += 1
                break
            case .VariableCustomAttribute:
                let customAttribute = parsedElementArray[1]
                variableHolderStackArray[positionInVariableHolderStackArray].customAttribute = customAttribute
            case .IsStaticVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].isStatic = true
            case .LazyVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].isLazy = true
            case .VariableAccessLevel:
                variableHolderStackArray[positionInVariableHolderStackArray].accessLevel = convertParsedElementToAccessLevel()
            case .HaveLetKeyword:
                variableHolderStackArray[positionInVariableHolderStackArray].isConstant = true
            case .VariableName:
                let name = parsedElementArray[1]
                variableHolderStackArray[positionInVariableHolderStackArray].name = name
            case .VariableType:
                let type = parsedElementArray[1]
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].literalType = type
                extractingDependencies(affectingTypeName: type, affectedTypeName: variableName)
            case .StartArrayTypeSyntaxOfVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].kind = .array
            case .ArrayTypeOfVariable:
                let type = parsedElementArray[1]
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].arrayType = type
                extractingDependencies(affectingTypeName: type, affectedTypeName: variableName)
            case .EndArrayTypeSyntaxOfVariable:
                break
            case .StartDictionaryTypeSyntaxOfVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].kind = .dictionary
            case .DictionaryKeyTypeOfVariable:
                let type = parsedElementArray[1]
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].dictionaryKeyType = type
                extractingDependencies(affectingTypeName: type, affectedTypeName: variableName)
            case .DictionaryValueTypeOfVariable:
                let type = parsedElementArray[1]
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].dictionaryValueType = type
                extractingDependencies(affectingTypeName: type, affectedTypeName: variableName)
            case .EndDictionaryTypeSyntaxOfVariable:
                break
            case .StartTupleTypeSyntaxOfVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].kind = .tuple
            case .TupleTypeOfVariable:
                let type = parsedElementArray[1]
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].tupleTypes.append(type)
                extractingDependencies(affectingTypeName: type, affectedTypeName: variableName)
            case .EndTupleTypeSyntaxOfVariable:
                break
            case .ConformedProtocolByOpaqueResultTypeOfVariable:
                let protocolName = parsedElementArray[1]
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].conformedProtocolByOpaqueResultType = protocolName
                extractingDependencies(affectingTypeName: protocolName, affectedTypeName: variableName)
            case .IsOptionalType:
                variableHolderStackArray[positionInVariableHolderStackArray].isOptionalType = true
            case .InitialValueOfVariable:
                let initialValue = parsedElementArray[1]
                variableHolderStackArray[positionInVariableHolderStackArray].initialValue = initialValue
            case .HaveWillSet:
                variableHolderStackArray[positionInVariableHolderStackArray].haveWillSet = true
            case .HaveDidSet:
                variableHolderStackArray[positionInVariableHolderStackArray].haveDidSet = true
            case .HaveGetter:
                variableHolderStackArray[positionInVariableHolderStackArray].haveGetter = true
            case .HaveSetter:
                variableHolderStackArray[positionInVariableHolderStackArray].haveSetter = true
            case .EndVariableDeclSyntax:
                addVariableHolderToSuperHolder()
            // functionの宣言
            case .StartFunctionDeclSyntax:
                break
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
    } // end func parseResultArray()
    
    func getResultStructHolders() -> [StructHolder] {
        return resultStructHolders
    }
    
    func getResultClassHolders() -> [ClassHolder] {
        return resultClassHolders
    }
    
    func getWhomThisTypeAffectArray() -> [WhomThisTypeAffect] {
        var array = [WhomThisTypeAffect]()
        for dict in whomThisTypeAffectDict {
            array.append(dict.value)
        }
        return array
    }
    
    mutating func pushHolderTypeStackArray(_ holderType: HolderType) {
        holderTypeStackArray.append(holderType)
        positionInHolderTypeStackArray += 1
    }
    
    mutating func popHolderTypeStackArray() {
        holderTypeStackArray.removeLast()
        positionInHolderTypeStackArray -= 1
    }
    
    // 型の依存関係を抽出する
    // affectingTypeName: 影響を及ぼす側の型の名前
    // affectedTypeName: 影響を受ける側の型の名前
    mutating private func extractingDependencies(affectingTypeName: String, affectedTypeName: String) {
        if let _ = whomThisTypeAffectDict[affectingTypeName] {
            // 影響を及ぼす側の型の名前が、whomThisTypeAffectDictのKeyに既に登録されているとき
            // affectingTypeNameをKeyに持つ要素のaffectedTypesNameに、affectedTypeNameを追加する
            whomThisTypeAffectDict[affectingTypeName]!.affectedTypesName.append(affectedTypeName)
        } else {
            // 影響を及ぼす側の型の名前が、whomThisTypeAffectDictのKeyにまだ登録されていないとき
            // affectingTypeNameをKeyとした、新しい要素を追加する
            whomThisTypeAffectDict[affectingTypeName] = WhomThisTypeAffect(affectingTypeName: affectingTypeName, affectedTypesName: [affectedTypeName])
        }
    } // func extractingDependencies()
    
    // VariableHolderを、親のvariableプロパティに追加する
    // variableの宣言終了を検出したときに呼び出す
    // popHolderTypeStackArrayのポップ操作を行う
    // variableHolderStackArrayのポップ操作を行う
    mutating private func addVariableHolderToSuperHolder() {
        let variableHolder = variableHolderStackArray[positionInVariableHolderStackArray]
        let holderType = holderTypeStackArray[positionInHolderTypeStackArray - 1]
        
        switch holderType {
        case .struct:
            structHolderStackArray[positionInStructHolderStackArray].variables.append(variableHolder)
        case .class:
            classHolderStackArray[positionInClassHolderStackArray].variables.append(variableHolder)
        default:
            fatalError("ERROR: holderTypeStackArray[positionInHolderTypeStackArray] hasn't variables property")
        }
        
        variableHolderStackArray.removeLast()
        positionInVariableHolderStackArray -= 1
        popHolderTypeStackArray()
    } // func addVariableHolderToSuperHolder()
} // end struct SyntaxArrayParser
