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
//    private var resultVariableHolders = [VariableHolder]()
//    private var resultFunctionHolders = [FunctionHolder]()
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
    
    var initializerHolderStackArray = [InitializerHolder]()
    var positionInInitializerHolderStackArray = -1
    var positionInInitializerParameters = -1
    var numberOfInitializer = -1
    
    var extensionHolderStackArray = [ExtensionHolder]()
    var positionInExtensionHolderStackArray = -1
    
    var genericHolderStackArray = [GenericHolder]()
    var positionInGenericHolderStackArray = -1
    var positionInGenericParameter = -1
    
    
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
                resetNumberOfInitializer()
                resetNumberOfGeneric()
            case .StructAccessLevel:
                structHolderStackArray[positionInStructHolderStackArray].accessLevel = convertParsedElementToAccessLevel()
            case .StructName:
                let name = parsedElementArray[1]
                structHolderStackArray[positionInStructHolderStackArray].name = name
                allTypeNames.append(name)
            case .EndStructDeclSyntax:
                let structHolder = structHolderStackArray[positionInStructHolderStackArray]
                addNestedStructToSuperHolderOrPopHolderTypeStackArray(structHolder: structHolder)
            // classの宣言
            case .StartClassDeclSyntax:
                pushHolderTypeStackArray(.class)
                classHolderStackArray.append(ClassHolder())
                positionInClassHolderStackArray += 1
                resetNumberOfInitializer()
                resetNumberOfGeneric()
            case .ClassAccessLevel:
                classHolderStackArray[positionInClassHolderStackArray].accessLevel = convertParsedElementToAccessLevel()
            case .ClassName:
                let name = parsedElementArray[1]
                classHolderStackArray[positionInClassHolderStackArray].name = name
                allTypeNames.append(name)
            case .EndClassDeclSyntax:
                let classHolder = classHolderStackArray[positionInClassHolderStackArray]
                addNestedClassToSuperHolderOrPopHolderTypeStackArray(classHolder: classHolder)
            // enumの宣言
            case .StartEnumDeclSyntax:
                pushHolderTypeStackArray(.enum)
                enumHolderStackArray.append(EnumHolder())
                positionInEnumHolderStackArray += 1
                positionInCasesOfEnumHolder = -1
                resetNumberOfInitializer()
                resetNumberOfGeneric()
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
                break
            case .EndEnumDeclSyntax:
                let enumHolder = enumHolderStackArray[positionInEnumHolderStackArray]
                addNestedEnumToSuperHolderOrPopHolderTypeStackArray(enumHolder: enumHolder)
            // protocolの宣言
            case .StartProtocolDeclSyntax:
                pushHolderTypeStackArray(.protocol)
                protocolHolderStackArray.append(ProtocolHolder())
                positionInProtocolHolderStackArray += 1
                resetNumberOfInitializer()
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
                let superTypeName = getSuperTypeName(reducePosition: 1)
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].literalType = type
                extractingDependencies(affectingTypeName: type, affectedTypeName: superTypeName, affectedElementName: variableName)
            case .StartArrayTypeSyntaxOfVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].kind = .array
            case .ArrayTypeOfVariable:
                let type = parsedElementArray[1]
                let superTypeName = getSuperTypeName(reducePosition: 1)
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].arrayType = type
                extractingDependencies(affectingTypeName: type, affectedTypeName: superTypeName, affectedElementName: variableName)
            case .EndArrayTypeSyntaxOfVariable:
                break
            case .StartDictionaryTypeSyntaxOfVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].kind = .dictionary
            case .DictionaryKeyTypeOfVariable:
                let type = parsedElementArray[1]
                let superTypeName = getSuperTypeName(reducePosition: 1)
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].dictionaryKeyType = type
                extractingDependencies(affectingTypeName: type, affectedTypeName: superTypeName, affectedElementName: variableName)
            case .DictionaryValueTypeOfVariable:
                let type = parsedElementArray[1]
                let superTypeName = getSuperTypeName(reducePosition: 1)
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].dictionaryValueType = type
                extractingDependencies(affectingTypeName: type, affectedTypeName: superTypeName, affectedElementName: variableName)
            case .EndDictionaryTypeSyntaxOfVariable:
                break
            case .StartTupleTypeSyntaxOfVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].kind = .tuple
            case .TupleTypeOfVariable:
                let type = parsedElementArray[1]
                let superTypeName = getSuperTypeName(reducePosition: 1)
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].tupleTypes.append(type)
                extractingDependencies(affectingTypeName: type, affectedTypeName: superTypeName, affectedElementName: variableName)
            case .EndTupleTypeSyntaxOfVariable:
                break
            case .ConformedProtocolByOpaqueResultTypeOfVariable:
                let protocolName = parsedElementArray[1]
                let superTypeName = getSuperTypeName(reducePosition: 1)
                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].conformedProtocolByOpaqueResultType = protocolName
                extractingDependencies(affectingTypeName: protocolName, affectedTypeName: superTypeName, affectedElementName: variableName)
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
                resetNumberOfGeneric()
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
            case .InitialValueOfFunctionParameter:
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
                pushHolderTypeStackArray(.initializer)
                initializerHolderStackArray.append(InitializerHolder())
                positionInInitializerHolderStackArray += 1
                positionInInitializerParameters = -1
                numberOfInitializer += 1
            case .HaveConvenienceKeyword:
                initializerHolderStackArray[positionInInitializerHolderStackArray].isConvenience = true
            case .IsFailableInitializer:
                initializerHolderStackArray[positionInInitializerHolderStackArray].isFailable = true
            case .StartInitializerParameter:
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters.append(InitializerHolder.ParameterHolder())
                positionInInitializerParameters += 1
            case .InitializerParameterName:
                let name = parsedElementArray[1]
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].name = name
            case .InitializerParameterType:
                let type = parsedElementArray[1]
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].literalType = type
                extractingDependenciesOfInitializer(affectingTypeName: type)
            case .StartArrayTypeSyntaxOfInitializer:
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].kind = .array
            case .ArrayTypeOfInitializer:
                let type = parsedElementArray[1]
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].arrayType = type
                extractingDependenciesOfInitializer(affectingTypeName: type)
            case .EndArrayTypeSyntaxOfInitializer:
                break
            case .StartDictionaryTypeSyntaxOfInitializer:
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].kind = .dictionary
            case .DictionaryKeyTypeOfInitializer:
                let type = parsedElementArray[1]
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].dictionaryKeyType = type
                extractingDependenciesOfInitializer(affectingTypeName: type)
            case .DictionaryValueTypeOfInitializer:
                let type = parsedElementArray[1]
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].dictionaryValueType = type
                extractingDependenciesOfInitializer(affectingTypeName: type)
            case .EndDictionaryTypeSyntaxOfInitializer:
                break
            case .StartTupleTypeSyntaxOfInitializer:
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].kind = .tuple
            case .TupleTypeOfInitializer:
                let type = parsedElementArray[1]
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].tupleTypes.append(type)
                extractingDependenciesOfInitializer(affectingTypeName: type)
            case .EndTupleTypeSyntaxOfInitializer:
                break
            case .InitialValueOfInitializerParameter:
                let initialValue = parsedElementArray[1]
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].initialValue = initialValue
            case .EndInitializerParameter:
                break
            case .EndInitializerDeclSyntax:
                addInitializerHolderToSuperHolder()
            // extensionの宣言
            case .StartExtensionDeclSyntax:
                resetNumberOfInitializer()
                pushHolderTypeStackArray(.extension)
                extensionHolderStackArray.append(ExtensionHolder())
                positionInExtensionHolderStackArray += 1
            case .ExtensiondTypeName:
                let name = parsedElementArray[1]
                extensionHolderStackArray[positionInExtensionHolderStackArray].extensionedTypeName = name
            case .ConformedProtocolByExtension:
                let extensionedTypeName = extensionHolderStackArray[positionInExtensionHolderStackArray].extensionedTypeName!
                let protocolName = parsedElementArray[1]
                extensionHolderStackArray[positionInExtensionHolderStackArray].conformingProtocolNames.append(protocolName)
                extractingDependencies(affectingTypeName: protocolName, affectedTypeName: extensionedTypeName)
            case .EndExtensionDeclSyntax:
                let extensionHolder = extensionHolderStackArray[positionInExtensionHolderStackArray]
                resultExtensionHolders.append(extensionHolder)
                extensionHolderStackArray.removeLast()
                positionInExtensionHolderStackArray -= 1
                popHolderTypeStackArray()
            // genericsの宣言
            case .StartGenericParameterSyntax:
                pushHolderTypeStackArray(.generic)
                genericHolderStackArray.append(GenericHolder())
                positionInGenericHolderStackArray += 1
                positionInGenericParameter += 1
            case .ParameterTypeOfGenerics:
                let type = parsedElementArray[1]
                genericHolderStackArray[positionInGenericHolderStackArray].parameterType = type
            case .ConformedProtocolOrInheritedClassByGenerics:
                let protocolName = parsedElementArray[1]
                for superClass in classNameArray {
                    if protocolName == superClass {
                        genericHolderStackArray[positionInGenericHolderStackArray].inheritedClassName = superClass
                        break superSwitch
                    }
                }
                genericHolderStackArray[positionInGenericHolderStackArray].conformedProtocolName = protocolName
            case .EndGenericParameterSyntaxOf:
                let genericHolder = genericHolderStackArray[positionInGenericHolderStackArray]
                addGenericToSuperHolder(generic: genericHolder)
            // typealiasの宣言
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
            // オプショナル型
            case .IsOptionalType:
                let typeKind = parsedElementArray[1]
                addIsOptional(typeKind: typeKind)
            // スペース
            case .Space:
                break
            } // end switch syntaxTag
        } // end for element in resultArray
        addExtensionHoldersToSuperHolder()
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
    
//    func getResultFunctionHolders() -> [FunctionHolder] {
//        return resultFunctionHolders
//    }
    
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
    } // func extractingDependencies(affectingTypeName: String, affectedTypeName: String, affectedElementName: String? = nil)
    
    
    // function宣言中に依存関係を抽出したとき、"影響を及ぼす型->functionを持つHolder.function"の依存関係を保存する
    mutating private func extractingDependenciesOfFunction(affectingTypeName: String) {
        let functionName = functionHolderStackArray[positionInFunctionHolderStackArray].name
        let superHolderName = getSuperTypeName(reducePosition: 1)
        extractingDependencies(affectingTypeName: affectingTypeName, affectedTypeName: superHolderName, affectedElementName: functionName)
    }
    
    // initializer宣言中に依存関係を抽出したとき、"影響を及ぼす型->initializerを持つHolder.init"の依存関係を保存する
    // initializerは名前を持たないので、affectedElementNameには、そのinitializerが型内で何番目かの数字を渡す
    mutating private func extractingDependenciesOfInitializer(affectingTypeName: String) {
        let num = numberOfInitializer
        let superHolderName = getSuperTypeName(reducePosition: 1)
        extractingDependencies(affectingTypeName: affectingTypeName, affectedTypeName: superHolderName, affectedElementName: "init \(num)")
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
        case .extension:
            extensionHolderStackArray[positionInExtensionHolderStackArray].variables.append(variableHolder)
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
        case .extension:
            extensionHolderStackArray[positionInExtensionHolderStackArray].functions.append(functionHolder)
        default:
            fatalError("")
        }
        
        functionHolderStackArray.removeLast()
        positionInFunctionHolderStackArray -= 1
        popHolderTypeStackArray()
    } // func addFunctionHolderToSuperHolder()
    
    // InitializerHolderを、親のfunctionsプロパティに追加する
    // initializerの宣言終了を検出したときに呼び出す
    // popHolderTypeStackArrayのポップ操作を行う
    // initializerHolderStackArrayのポップ操作を行う
    mutating private func addInitializerHolderToSuperHolder() {
        let initializerHolder = initializerHolderStackArray[positionInInitializerHolderStackArray]
        let holderType = holderTypeStackArray[positionInHolderTypeStackArray - 1]
        
        switch holderType {
        case .struct:
            structHolderStackArray[positionInStructHolderStackArray].initializers.append(initializerHolder)
        case .class:
            classHolderStackArray[positionInClassHolderStackArray].initializers.append(initializerHolder)
        case .enum:
            enumHolderStackArray[positionInEnumHolderStackArray].initializers.append(initializerHolder)
        case .protocol:
            protocolHolderStackArray[positionInProtocolHolderStackArray].initializers.append(initializerHolder)
        case .extension:
            extensionHolderStackArray[positionInExtensionHolderStackArray].initializers.append(initializerHolder)
        default:
            fatalError("")
        }
        
        initializerHolderStackArray.removeLast()
        positionInInitializerHolderStackArray -= 1
        popHolderTypeStackArray()
    } // func addInitializerHolderToSuperHolder()
    
    // ExtensionHolderを、親のextensionsプロパティに追加する
    // Extensionの宣言終了を検出したときに呼び出す
    // popHolderTypeStackArrayのポップ操作を行う
    // extensionHolderStackArrayのポップ操作を行う
    mutating private func addExtensionHoldersToSuperHolder() {
        forExtensionHolder: for extensionHolder in resultExtensionHolders {
            let extensionedTypeName = extensionHolder.extensionedTypeName
            
            for (index, structHolder) in resultStructHolders.enumerated() {
                if structHolder.name == extensionedTypeName {
                    resultStructHolders[index].extensions.append(extensionHolder)
                    continue forExtensionHolder
                }
            }
            
            for (index, classHolder) in resultClassHolders.enumerated() {
                if classHolder.name == extensionedTypeName {
                    resultClassHolders[index].extensions.append(extensionHolder)
                    continue forExtensionHolder
                }
            }
            
            for (index, enumHolder) in resultEnumHolders.enumerated() {
                if enumHolder.name == extensionedTypeName {
                    resultEnumHolders[index].extensions.append(extensionHolder)
                    continue forExtensionHolder
                }
            }
        
            for (index, protocolHolder) in resultProtocolHolders.enumerated() {
                if protocolHolder.name == extensionedTypeName {
                    resultProtocolHolders[index].extensions.append(extensionHolder)
                }
            }
        }
//        let extensionHolder = extensionHolderStackArray[positionInExtensionHolderStackArray]
//        let extensionedTypeName = extensionHolder.extensionedTypeName
//
//        extensionHolderStackArray.removeLast()
//        positionInExtensionHolderStackArray -= 1
//        popHolderTypeStackArray()
    } // func addExtensionHolderToSuperHolder()
    
    // そのvariableやfunctionを保有している型の名前を返す
    private func getSuperTypeName(reducePosition: Int) -> String {
        let holderType = holderTypeStackArray[positionInHolderTypeStackArray - reducePosition]
        
        switch holderType {
        case .struct:
            return structHolderStackArray[positionInStructHolderStackArray].name
        case .class:
            return classHolderStackArray[positionInClassHolderStackArray].name
        case .enum:
            return enumHolderStackArray[positionInEnumHolderStackArray].name
        case .protocol:
            return protocolHolderStackArray[positionInProtocolHolderStackArray].name
        case .extension:
            return extensionHolderStackArray[positionInExtensionHolderStackArray].extensionedTypeName!
        default:
            fatalError("")
        }
    } // func getSuperType() -> String
    
    mutating private func addIsOptional(typeKind: String) {
        guard let optionalTypeKind = OptionalTypeKind(typeKind) else {
            fatalError()
        }
        
        switch optionalTypeKind {
        case .variable:
            variableHolderStackArray[positionInVariableHolderStackArray].isOptionalType = true
        case .functionParameter:
            functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].isOptionalType = true
        case .functionReturnValue:
            functionHolderStackArray[positionInFunctionHolderStackArray].returnValueIsOptional = true
        case .initializerParameter:
            initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].isOptionalType = true
        }
    }
    
    // numberOfInitializerを-1にリセットする
    mutating private func resetNumberOfInitializer() {
        numberOfInitializer = -1
    }
    
    mutating private func addNestedStructToSuperHolderOrPopHolderTypeStackArray(structHolder: StructHolder) {
        if 0 < positionInHolderTypeStackArray {
            // 親となるSuperHolderがあるとき
            let holderType = holderTypeStackArray[positionInHolderTypeStackArray - 1]
            switch holderType {
            case .struct:
                structHolderStackArray[positionInStructHolderStackArray - 1].nestingStructs.append(structHolder)
            case .class:
                classHolderStackArray[positionInClassHolderStackArray].nestingStructs.append(structHolder)
            case.enum:
                enumHolderStackArray[positionInEnumHolderStackArray].nestingStructs.append(structHolder)
            case .extension:
                extensionHolderStackArray[positionInExtensionHolderStackArray].nestingStructs.append(structHolder)
            default:
                fatalError()
            }
        } else {
            // 親となるSuperHolderがないとき
            resultStructHolders.append(structHolder)
        }
        
        popHolderTypeStackArray()
        structHolderStackArray.removeLast()
        positionInStructHolderStackArray -= 1
    } // func addNestedStructToSuperHolderOrPopHolderTypeStackArray(structHolder: StructHolder)
    
    mutating private func addNestedClassToSuperHolderOrPopHolderTypeStackArray(classHolder: ClassHolder) {
        if 0 < positionInHolderTypeStackArray {
            // 親となるSuperHolderがあるとき
            let holderType = holderTypeStackArray[positionInHolderTypeStackArray - 1]
            switch holderType {
            case .struct:
                structHolderStackArray[positionInStructHolderStackArray].nestingClasses.append(classHolder)
            case .class:
                classHolderStackArray[positionInClassHolderStackArray - 1].nestingClasses.append(classHolder)
            case.enum:
                enumHolderStackArray[positionInEnumHolderStackArray].nestingClasses.append(classHolder)
            case .extension:
                extensionHolderStackArray[positionInExtensionHolderStackArray].nestingClasses.append(classHolder)
            default:
                fatalError()
            }
        } else {
            // 親となるSuperHolderがないとき
            resultClassHolders.append(classHolder)
        }
        
        popHolderTypeStackArray()
        classHolderStackArray.removeLast()
        positionInClassHolderStackArray -= 1
    } // func addNestedClassToSuperHolderOrPopHolderTypeStackArray(classHolder: ClassHolder)
    
    mutating private func addNestedEnumToSuperHolderOrPopHolderTypeStackArray(enumHolder: EnumHolder) {
        if 0 < positionInHolderTypeStackArray {
            // 親となるSuperHolderがあるとき
            let holderType = holderTypeStackArray[positionInHolderTypeStackArray - 1]
            switch holderType {
            case .struct:
                structHolderStackArray[positionInStructHolderStackArray].nestingEnums.append(enumHolder)
            case .class:
                classHolderStackArray[positionInClassHolderStackArray].nestingEnums.append(enumHolder)
            case.enum:
                enumHolderStackArray[positionInEnumHolderStackArray - 1].nestingEnums.append(enumHolder)
            case .extension:
                extensionHolderStackArray[positionInExtensionHolderStackArray].nestingEnums.append(enumHolder)
            default:
                fatalError()
            }
        } else {
            // 親となるSuperHolderがないとき
            resultEnumHolders.append(enumHolder)
        }
        
        popHolderTypeStackArray()
        enumHolderStackArray.removeLast()
        positionInEnumHolderStackArray -= 1
    } // func addNestedEnumToSuperHolderOrPopHolderTypeStackArray(enumHolder: EnumHolder)
    
    mutating private func addGenericToSuperHolder(generic: GenericHolder) {
//        let num = position
        var affectingTypeName = ""
        if let protocolName = generic.conformedProtocolName {
            affectingTypeName = protocolName
        } else if let superClassName = generic.inheritedClassName {
            affectingTypeName = superClassName
        }
        
        let holderType = holderTypeStackArray[positionInHolderTypeStackArray - 1]
        switch holderType {
        case .struct:
            let structName = structHolderStackArray[positionInStructHolderStackArray].name
            structHolderStackArray[positionInStructHolderStackArray].generics.append(generic)
            if affectingTypeName != "" {
                extractingDependencies(affectingTypeName: affectingTypeName, affectedTypeName: structName, affectedElementName: "generic \(positionInGenericParameter)")
            }
        case .class:
            let className = classHolderStackArray[positionInClassHolderStackArray].name
            classHolderStackArray[positionInClassHolderStackArray].generics.append(generic)
            if affectingTypeName != "" {
                extractingDependencies(affectingTypeName: affectingTypeName, affectedTypeName: className, affectedElementName: "generic \(positionInGenericParameter)")
            }
        case .enum:
            let enumName = enumHolderStackArray[positionInEnumHolderStackArray].name
            enumHolderStackArray[positionInEnumHolderStackArray].generics.append(generic)
            if affectingTypeName != "" {
                extractingDependencies(affectingTypeName: affectingTypeName, affectedTypeName: enumName, affectedElementName: "generic \(positionInGenericParameter)")
            }
        case .function:
            let functionName = functionHolderStackArray[positionInFunctionHolderStackArray].name
            let superHolderName = getSuperTypeName(reducePosition: 2)
            functionHolderStackArray[positionInFunctionHolderStackArray].generics.append(generic)
            if affectingTypeName != "" {
                extractingDependencies(affectingTypeName: affectingTypeName, affectedTypeName: superHolderName, affectedElementName: "\(functionName)")
            }
        default:
            fatalError()
        }
        
        popHolderTypeStackArray()
        genericHolderStackArray.removeLast()
        positionInGenericHolderStackArray -= 1
    } // func addGenericToSuperHolder(generic: GenericHolder)
    
    mutating private func resetNumberOfGeneric() {
        positionInGenericParameter = -1
    }
} // end struct SyntaxArrayParser
