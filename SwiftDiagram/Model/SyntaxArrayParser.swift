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
    
    var enumHolderStackArray = [EnumHolder]()
    var positionInEnumHolderStackArray = -1
    var positionInCasesOfEnumHolder = -1
    
    var protocolHolderStackArray = [ProtocolHolder]()
    var positionInProtocolHolderStackArray = -1
    var positionInAssociatedTypes = -1
    
    var variableHolderStackArray = [VariableHolder]()
    var positionInVariableHolderStackArray = -1
    
    var functionHolderStackArray = [FunctionHolder]()
    var positionInFunctionHolderStackArray = -1
    var positionInFunctionParameters = -1
    
    
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
                pushHolderTypeStackArray(.enum)
                enumHolderStackArray.append(EnumHolder())
                positionInEnumHolderStackArray += 1
                positionInCasesOfEnumHolder = -1
            case .EnumAccessLevel:
                enumHolderStackArray[positionInEnumHolderStackArray].accessLevel = convertParsedElementToAccessLevel()
            case .EnumName:
                let name = parsedElementArray[1]
                enumHolderStackArray[positionInEnumHolderStackArray].name = name
                allTypeNames.append(name)
            case .RawvalueType:
                let rawvalueType = parsedElementArray[1]
                let enumName = enumHolderStackArray[positionInEnumHolderStackArray].name
                enumHolderStackArray[positionInEnumHolderStackArray].rawvalueType = rawvalueType
                extractingDependencies(affectingTypeName: rawvalueType, affectedTypeName: enumName)
            case .StartEnumCaseElementSyntax:
                enumHolderStackArray[positionInEnumHolderStackArray].cases.append(EnumHolder.CaseHolder())
                positionInCasesOfEnumHolder += 1
            case .EnumCase:
                let name = parsedElementArray[1]
                enumHolderStackArray[positionInEnumHolderStackArray].cases[positionInCasesOfEnumHolder].caseName = name
            case .Rawvalue:
                let rawvalue = parsedElementArray[1]
                enumHolderStackArray[positionInEnumHolderStackArray].cases[positionInCasesOfEnumHolder].rawvalue = rawvalue
            case .CaseAssociatedValue:
                let associatedValueType = parsedElementArray[1]
                let enumName = enumHolderStackArray[positionInEnumHolderStackArray].name
                let caseName = enumHolderStackArray[positionInEnumHolderStackArray].cases[positionInCasesOfEnumHolder].caseName
                enumHolderStackArray[positionInEnumHolderStackArray].cases[positionInCasesOfEnumHolder].associatedValueTypes.append(associatedValueType)
                extractingDependencies(affectingTypeName: associatedValueType, affectedTypeName: enumName, affectedElementName: caseName)
            case .EndEnumCaseElementSyntax:
                positionInCasesOfEnumHolder -= 1
            case .EndEnumDeclSyntax:
                resultEnumHolders.append(enumHolderStackArray.last!)
                popHolderTypeStackArray()
                enumHolderStackArray.removeLast()
                positionInEnumHolderStackArray -= 1
            // protocolの宣言
            case .StartProtocolDeclSyntax:
                pushHolderTypeStackArray(.protocol)
                protocolHolderStackArray.append(ProtocolHolder())
                positionInProtocolHolderStackArray += 1
            case .ProtocolAccessLevel:
                protocolHolderStackArray[positionInProtocolHolderStackArray].accessLevel = convertParsedElementToAccessLevel()
            case .ProtocolName:
                let name = parsedElementArray[1]
                protocolHolderStackArray[positionInProtocolHolderStackArray].name = name
                allTypeNames.append(name)
            case .StartAssociatedtypeDeclSyntax:
                break
            case .AssociatedType:
                let name = parsedElementArray[1]
                protocolHolderStackArray[positionInProtocolHolderStackArray].associatedTypes.append(ProtocolHolder.AssociatedType(name: name))
                positionInAssociatedTypes += 1
            case .ConformedProtocolOrInheritedClassByAssociatedType:
                let name = parsedElementArray[1]
                protocolHolderStackArray[positionInProtocolHolderStackArray].associatedTypes[positionInAssociatedTypes].protocolOrSuperClassName = name
            case .EndAssociatedtypeDeclSyntax:
                break
            case .EndProtocolDeclSyntax:
                resultProtocolHolders.append(protocolHolderStackArray.last!)
                popHolderTypeStackArray()
                protocolHolderStackArray.removeLast()
                positionInProtocolHolderStackArray -= 1
            // プロトコルへの準拠、スーパークラスの継承
            case .StartInheritedTypeListSyntax:
                break
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
                let protocolName = parsedElementArray[1]
                let enumName = enumHolderStackArray[positionInEnumHolderStackArray].name
                enumHolderStackArray[positionInEnumHolderStackArray].conformingProtocolNames.append(protocolName)
                extractingDependencies(affectingTypeName: protocolName, affectedTypeName: enumName)
            case .ConformedProtocolByProtocol:
                let conformedProtocol = parsedElementArray[1]
                let conformingProtocol = protocolHolderStackArray[positionInProtocolHolderStackArray].name
                protocolHolderStackArray[positionInProtocolHolderStackArray].conformingProtocolNames.append(conformedProtocol)
                extractingDependencies(affectingTypeName: conformedProtocol, affectedTypeName: conformingProtocol)
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
                let superTypeName = getSuperTypeName()
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].literalType = type
                extractingDependencies(affectingTypeName: type, affectedTypeName: superTypeName, affectedElementName: variableName)
            case .StartArrayTypeSyntaxOfVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].kind = .array
            case .ArrayTypeOfVariable:
                let type = parsedElementArray[1]
                let superTypeName = getSuperTypeName()
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].arrayType = type
                extractingDependencies(affectingTypeName: type, affectedTypeName: superTypeName, affectedElementName: variableName)
            case .EndArrayTypeSyntaxOfVariable:
                break
            case .StartDictionaryTypeSyntaxOfVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].kind = .dictionary
            case .DictionaryKeyTypeOfVariable:
                let type = parsedElementArray[1]
                let superTypeName = getSuperTypeName()
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].dictionaryKeyType = type
                extractingDependencies(affectingTypeName: type, affectedTypeName: superTypeName, affectedElementName: variableName)
            case .DictionaryValueTypeOfVariable:
                let type = parsedElementArray[1]
                let superTypeName = getSuperTypeName()
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].dictionaryValueType = type
                extractingDependencies(affectingTypeName: type, affectedTypeName: superTypeName, affectedElementName: variableName)
            case .EndDictionaryTypeSyntaxOfVariable:
                break
            case .StartTupleTypeSyntaxOfVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].kind = .tuple
            case .TupleTypeOfVariable:
                let type = parsedElementArray[1]
                let superTypeName = getSuperTypeName()
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].tupleTypes.append(type)
                extractingDependencies(affectingTypeName: type, affectedTypeName: superTypeName, affectedElementName: variableName)
            case .EndTupleTypeSyntaxOfVariable:
                break
            case .ConformedProtocolByOpaqueResultTypeOfVariable:
                let protocolName = parsedElementArray[1]
                let superTypeName = getSuperTypeName()
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].conformedProtocolByOpaqueResultType = protocolName
                extractingDependencies(affectingTypeName: protocolName, affectedTypeName: superTypeName, affectedElementName: variableName)
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
                pushHolderTypeStackArray(.function)
                functionHolderStackArray.append(FunctionHolder())
                positionInFunctionHolderStackArray += 1
                positionInFunctionParameters = -1
            case .IsStaticFunction:
                functionHolderStackArray[positionInFunctionHolderStackArray].isStatic = true
            case .FunctionAccessLevel:
                functionHolderStackArray[positionInFunctionHolderStackArray].accessLevel = convertParsedElementToAccessLevel()
            case .IsOverrideFunction:
                functionHolderStackArray[positionInFunctionHolderStackArray].isOverride = true
            case .IsMutatingFunction:
                functionHolderStackArray[positionInFunctionHolderStackArray].isMutating = true
            case .FunctionName:
                let name = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].name = name
            case .StartFunctionParameterSyntax:
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters.append(FunctionHolder.ParameterHolder())
                positionInFunctionParameters += 1
            case .ExternalParameterName:
                let name = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].externalName = name
            case .InternalParameterName:
                let name = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].internalName = name
            case .HaveInoutKeyword:
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].haveInoutKeyword = true
            case .IsVariadicParameter:
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].isVariadic = true
            case .FunctionParameterType:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].literalType = type
                extractingDependenciesOfFunction(affectingTypeName: type)
            case .StartArrayTypeSyntaxOfFunctionParameter:
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].kind = .array
            case .ArrayTypeOfFunctionParameter:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].arrayType = type
                extractingDependenciesOfFunction(affectingTypeName: type)
            case .EndArrayTypeSyntaxOfFunctionParameter:
                break
            case .StartDictionaryTypeSyntaxOfFunctionParameter:
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].kind = .dictionary
            case .DictionaryKeyTypeOfFunctionParameter:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].dictionaryKeyType = type
                extractingDependenciesOfFunction(affectingTypeName: type)
            case .DictionaryValueTypeOfFunctionParameter:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].dictionaryValueType = type
                extractingDependenciesOfFunction(affectingTypeName: type)
            case .EndDictionaryTypeSyntaxOfFunctionParameter:
                break
            case .StartTupleTypeSyntaxOfFunctionParameter:
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].kind = .tuple
            case .TupleTypeOfFunctionParameter:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].tupleTypes.append(type)
                extractingDependenciesOfFunction(affectingTypeName: type)
            case .EndTupleTypeSyntaxOfFunctionParameter:
                break
            case .InitialValueOfParameter:
                let value = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].initialValue = value
            case .EndFunctionParameterSyntax:
                break
            case .StartFunctionReturnValueType:
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue = FunctionHolder.ReturnValueHolder()
            case .FunctionReturnValueType:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.literalType = type
                extractingDependenciesOfFunction(affectingTypeName: type)
            case .StartArrayTypeSyntaxOfFunctionReturnValue:
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.kind = .array
            case .ArrayTypeOfFunctionReturnValue:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.arrayType = type
                extractingDependenciesOfFunction(affectingTypeName: type)
            case .EndArrayTypeSyntaxOfFunctionReturnValue:
                break
            case .StartDictionaryTypeSyntaxOfFunctionReturnValue:
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.kind = .dictionary
            case .DictionaryKeyTypeOfFunctionReturnValue:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.dictionaryKeyType = type
                extractingDependenciesOfFunction(affectingTypeName: type)
            case .DictionaryValueTypeOfFunctionReturnValue:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.dictionaryValueType = type
                extractingDependenciesOfFunction(affectingTypeName: type)
            case .EndDictionaryTypeSyntaxOfFunctionReturnValue:
                break
            case .StartTupleTypeSyntaxOfFunctionReturnValue:
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.kind = .tuple
            case .TupleTypeOfFunctionReturnValue:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.tupleTypes.append(type)
                extractingDependenciesOfFunction(affectingTypeName: type)
            case .EndTupleTypeSyntaxOfFunctionReturnValue:
                break
            case .ConformedProtocolByOpaqueResultTypeOfFunctionReturnValue:
                let protocolName = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.conformedProtocolByOpaqueResultTypeOfReturnValue = protocolName
            case .EndFunctionReturnValueType:
                break
            case .EndFunctionDeclSyntax:
                addFunctionHolderToSuperHolder()
            // initializerの宣言
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
            // extensionの宣言
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
            // スペース
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
    
    func getResultEnumHolders() -> [EnumHolder] {
        return resultEnumHolders
    }
    
    func getResultProtocolHolders() -> [ProtocolHolder] {
        return resultProtocolHolders
    }
    
    func getResultFunctionHolders() -> [FunctionHolder] {
        return resultFunctionHolders
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
    mutating private func extractingDependencies(affectingTypeName: String, affectedTypeName: String, affectedElementName: String? = nil) {
        if let _ = whomThisTypeAffectDict[affectingTypeName] {
            // 影響を及ぼす側の型の名前が、whomThisTypeAffectDictのKeyに既に登録されているとき
            // affectingTypeNameをKeyに持つ要素のaffectedTypesNameに、affectedTypeNameを追加する
            if let element = affectedElementName {
                whomThisTypeAffectDict[affectingTypeName]!.affectedTypesName.append(WhomThisTypeAffect.Element(typeName: affectedTypeName, elementName: element))
            } else {
                whomThisTypeAffectDict[affectingTypeName]!.affectedTypesName.append(WhomThisTypeAffect.Element(typeName: affectedTypeName))
            }
        } else {
            // 影響を及ぼす側の型の名前が、whomThisTypeAffectDictのKeyにまだ登録されていないとき
            // affectingTypeNameをKeyとした、新しい要素を追加する
            if let element = affectedElementName {
                whomThisTypeAffectDict[affectingTypeName] = WhomThisTypeAffect(affectingTypeName: affectingTypeName, affectedTypesName: [WhomThisTypeAffect.Element(typeName: affectedTypeName, elementName: element)])
            } else {
                whomThisTypeAffectDict[affectingTypeName] = WhomThisTypeAffect(affectingTypeName: affectingTypeName, affectedTypesName: [WhomThisTypeAffect.Element(typeName: affectedTypeName)])
            }
        }
    } // func extractingDependencies()
    
    
    // function宣言中に依存関係を抽出したとき、"影響を及ぼす型->functionを持つHolder.function"の依存関係を保存する
    mutating private func extractingDependenciesOfFunction(affectingTypeName: String) {
        let functionName = functionHolderStackArray[positionInFunctionHolderStackArray].name
        let superHolderName = getSuperTypeName()
        extractingDependencies(affectingTypeName: affectingTypeName, affectedTypeName: superHolderName, affectedElementName: functionName)
    }
    
    // VariableHolderを、親のvariablesプロパティに追加する
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
        case .enum:
            enumHolderStackArray[positionInEnumHolderStackArray].variables.append(variableHolder)
        case .protocol:
            protocolHolderStackArray[positionInProtocolHolderStackArray].variables.append(variableHolder)
        default:
            fatalError("ERROR: holderTypeStackArray[positionInHolderTypeStackArray] hasn't variables property")
        }
        
        variableHolderStackArray.removeLast()
        positionInVariableHolderStackArray -= 1
        popHolderTypeStackArray()
    } // func addVariableHolderToSuperHolder()
    
    // FunctionHolderを、親のfunctionsプロパティに追加する
    // functionの宣言終了を検出したときに呼び出す
    // popHolderTypeStackArrayのポップ操作を行う
    // functionHolderStackArrayのポップ操作を行う
    mutating private func addFunctionHolderToSuperHolder() {
        let functionHolder = functionHolderStackArray[positionInFunctionHolderStackArray]
        let holderType = holderTypeStackArray[positionInHolderTypeStackArray - 1]
        
        switch holderType {
        case .struct:
            structHolderStackArray[positionInStructHolderStackArray].functions.append(functionHolder)
        case .class:
            classHolderStackArray[positionInClassHolderStackArray].functions.append(functionHolder)
        case .enum:
            enumHolderStackArray[positionInEnumHolderStackArray].functions.append(functionHolder)
        case .protocol:
            protocolHolderStackArray[positionInProtocolHolderStackArray].functions.append(functionHolder)
        default:
            fatalError("")
        }
        
        functionHolderStackArray.removeLast()
        positionInFunctionHolderStackArray -= 1
        popHolderTypeStackArray()
    }
    
    // そのvariableやfunctionを保有している型の名前を返す
    private func getSuperTypeName() -> String {
        let holderType = holderTypeStackArray[positionInHolderTypeStackArray - 1]
        
        switch holderType {
        case .struct:
            return structHolderStackArray[positionInStructHolderStackArray].name
        case .class:
            return classHolderStackArray[positionInClassHolderStackArray].name
        case .enum:
            return enumHolderStackArray[positionInEnumHolderStackArray].name
        case .protocol:
            return protocolHolderStackArray[positionInProtocolHolderStackArray].name
        default:
            fatalError("")
        }
    } // func getSuperType()
} // end struct SyntaxArrayParser
