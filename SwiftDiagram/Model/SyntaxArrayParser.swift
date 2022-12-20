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
    private var resultExtensionHolders = [ExtensionHolder]()
    
    // 型の依存関係を保持する
//    private var whomThisTypeAffectDict = [String: WhomThisTypeAffect]()
    private var resultDependenceHolders = [String: DependenceHolder]()
    
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
    
    var typealiasHolderStackArray = [TypealiasHolder]()
    var positionInTypealiasHolderStackArray = -1
    
    
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
        
//        print("-----SyntaxArrayParser.parseResultArray")
        // resultArrayに格納されているタグを1つずつ取り出して解析する
        for element in resultArray {
//            print(element)
            
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
                extractDependence(affectingTypeName: rawvalueType, componentKind: .rawvalueType)
                enumHolderStackArray[positionInEnumHolderStackArray].rawvalueType = rawvalueType
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
                extractDependence(affectingTypeName: associatedValueType, componentKind: .associatedType)
                enumHolderStackArray[positionInEnumHolderStackArray].cases[positionInCasesOfEnumHolder].associatedValueTypes.append(associatedValueType)
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
                extractDependence(affectingTypeName: protocolName, componentKind: .conform)
                structHolderStackArray[positionInStructHolderStackArray].conformingProtocolNames.append(protocolName)
            case .ConformedProtocolOrInheritedClassByClass:
                let protocolName = parsedElementArray[1]
                for superClass in classNameArray {
                    if protocolName == superClass {
                        extractDependence(affectingTypeName: protocolName, componentKind: .superClass)
                        classHolderStackArray[positionInClassHolderStackArray].superClassName = protocolName
                        break superSwitch
                    }
                }
                extractDependence(affectingTypeName: protocolName, componentKind: .conform)
                classHolderStackArray[positionInClassHolderStackArray].conformingProtocolNames.append(protocolName)
            case .ConformedProtocolByEnum:
                let protocolName = parsedElementArray[1]
                extractDependence(affectingTypeName: protocolName, componentKind: .conform)
                enumHolderStackArray[positionInEnumHolderStackArray].conformingProtocolNames.append(protocolName)
            case .ConformedProtocolByProtocol:
                let conformedProtocol = parsedElementArray[1]
//                let conformingProtocol = protocolHolderStackArray[positionInProtocolHolderStackArray].name
                extractDependence(affectingTypeName: conformedProtocol, componentKind: .conform)
                protocolHolderStackArray[positionInProtocolHolderStackArray].conformingProtocolNames.append(conformedProtocol)
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
//                let superTypeName = getSuperTypeName(reducePosition: 1)
//                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].literalType = type
                extractDependence(affectingTypeName: type, componentKind: .property)
            case .StartArrayTypeSyntaxOfVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].kind = .array
            case .ArrayTypeOfVariable:
                let type = parsedElementArray[1]
//                let superTypeName = getSuperTypeName(reducePosition: 1)
//                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].arrayType = type
                extractDependence(affectingTypeName: type, componentKind: .property)
            case .EndArrayTypeSyntaxOfVariable:
                break
            case .StartDictionaryTypeSyntaxOfVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].kind = .dictionary
            case .DictionaryKeyTypeOfVariable:
                let type = parsedElementArray[1]
//                let superTypeName = getSuperTypeName(reducePosition: 1)
//                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].dictionaryKeyType = type
                extractDependence(affectingTypeName: type, componentKind: .property)
            case .DictionaryValueTypeOfVariable:
                let type = parsedElementArray[1]
//                let superTypeName = getSuperTypeName(reducePosition: 1)
//                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].dictionaryValueType = type
                extractDependence(affectingTypeName: type, componentKind: .property)
            case .EndDictionaryTypeSyntaxOfVariable:
                break
            case .StartTupleTypeSyntaxOfVariable:
                variableHolderStackArray[positionInVariableHolderStackArray].kind = .tuple
            case .TupleTypeOfVariable:
                let type = parsedElementArray[1]
//                let superTypeName = getSuperTypeName(reducePosition: 1)
//                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].tupleTypes.append(type)
                extractDependence(affectingTypeName: type, componentKind: .property)
            case .EndTupleTypeSyntaxOfVariable:
                break
            case .ConformedProtocolByOpaqueResultTypeOfVariable:
                let protocolName = parsedElementArray[1]
//                let superTypeName = getSuperTypeName(reducePosition: 1)
//                let variableName = variableHolderStackArray[positionInVariableHolderStackArray].name
                variableHolderStackArray[positionInVariableHolderStackArray].kind = .opaqueResultType
                variableHolderStackArray[positionInVariableHolderStackArray].conformedProtocolByOpaqueResultType = protocolName
                extractDependence(affectingTypeName: protocolName, componentKind: .property)
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
                extractDependence(affectingTypeName: type, componentKind: .method)
            case .StartArrayTypeSyntaxOfFunctionParameter:
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].kind = .array
            case .ArrayTypeOfFunctionParameter:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].arrayType = type
                extractDependence(affectingTypeName: type, componentKind: .method)
            case .EndArrayTypeSyntaxOfFunctionParameter:
                break
            case .StartDictionaryTypeSyntaxOfFunctionParameter:
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].kind = .dictionary
            case .DictionaryKeyTypeOfFunctionParameter:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].dictionaryKeyType = type
                extractDependence(affectingTypeName: type, componentKind: .method)
            case .DictionaryValueTypeOfFunctionParameter:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].dictionaryValueType = type
                extractDependence(affectingTypeName: type, componentKind: .method)
            case .EndDictionaryTypeSyntaxOfFunctionParameter:
                break
            case .StartTupleTypeSyntaxOfFunctionParameter:
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].kind = .tuple
            case .TupleTypeOfFunctionParameter:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].parameters[positionInFunctionParameters].tupleTypes.append(type)
                extractDependence(affectingTypeName: type, componentKind: .method)
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
                extractDependence(affectingTypeName: type, componentKind: .method)
            case .StartArrayTypeSyntaxOfFunctionReturnValue:
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.kind = .array
            case .ArrayTypeOfFunctionReturnValue:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.arrayType = type
                extractDependence(affectingTypeName: type, componentKind: .method)
            case .EndArrayTypeSyntaxOfFunctionReturnValue:
                break
            case .StartDictionaryTypeSyntaxOfFunctionReturnValue:
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.kind = .dictionary
            case .DictionaryKeyTypeOfFunctionReturnValue:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.dictionaryKeyType = type
                extractDependence(affectingTypeName: type, componentKind: .method)
            case .DictionaryValueTypeOfFunctionReturnValue:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.dictionaryValueType = type
                extractDependence(affectingTypeName: type, componentKind: .method)
            case .EndDictionaryTypeSyntaxOfFunctionReturnValue:
                break
            case .StartTupleTypeSyntaxOfFunctionReturnValue:
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.kind = .tuple
            case .TupleTypeOfFunctionReturnValue:
                let type = parsedElementArray[1]
                functionHolderStackArray[positionInFunctionHolderStackArray].returnValue!.tupleTypes.append(type)
                extractDependence(affectingTypeName: type, componentKind: .method)
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
                extractDependence(affectingTypeName: type, componentKind: .initializer)
            case .StartArrayTypeSyntaxOfInitializer:
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].kind = .array
            case .ArrayTypeOfInitializer:
                let type = parsedElementArray[1]
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].arrayType = type
                extractDependence(affectingTypeName: type, componentKind: .initializer)
            case .EndArrayTypeSyntaxOfInitializer:
                break
            case .StartDictionaryTypeSyntaxOfInitializer:
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].kind = .dictionary
            case .DictionaryKeyTypeOfInitializer:
                let type = parsedElementArray[1]
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].dictionaryKeyType = type
                extractDependence(affectingTypeName: type, componentKind: .initializer)
            case .DictionaryValueTypeOfInitializer:
                let type = parsedElementArray[1]
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].dictionaryValueType = type
                extractDependence(affectingTypeName: type, componentKind: .initializer)
            case .EndDictionaryTypeSyntaxOfInitializer:
                break
            case .StartTupleTypeSyntaxOfInitializer:
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].kind = .tuple
            case .TupleTypeOfInitializer:
                let type = parsedElementArray[1]
                initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].tupleTypes.append(type)
                extractDependence(affectingTypeName: type, componentKind: .initializer)
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
//                let extensionedTypeName = extensionHolderStackArray[positionInExtensionHolderStackArray].extensionedTypeName!
                let protocolName = parsedElementArray[1]
                extensionHolderStackArray[positionInExtensionHolderStackArray].conformingProtocolNames.append(protocolName)
//                extractingDependencies(affectingTypeName: protocolName, affectedTypeName: extensionedTypeName)
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
                extractDependence(affectingTypeName: protocolName, componentKind: .generic)
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
                pushHolderTypeStackArray(.typealias)
                typealiasHolderStackArray.append(TypealiasHolder())
                positionInTypealiasHolderStackArray += 1
            case .TypealiasAssociatedTypeName:
                let name = parsedElementArray[1]
                typealiasHolderStackArray[positionInTypealiasHolderStackArray].associatedTypeName = name
            case .TypealiasType:
                let literalType = parsedElementArray[1]
                typealiasHolderStackArray[positionInTypealiasHolderStackArray].literalType = literalType
                extractDependence(affectingTypeName: literalType, componentKind: .typealias)
            case .StartArrayTypeSyntaxOfTypealias:
                typealiasHolderStackArray[positionInTypealiasHolderStackArray].variableKind = .array
            case .ArrayTypeOfTypealias:
                let arrayType = parsedElementArray[1]
                typealiasHolderStackArray[positionInTypealiasHolderStackArray].arrayType = arrayType
                extractDependence(affectingTypeName: arrayType, componentKind: .typealias)
            case .EndArrayTypeSyntaxOfTypealias:
                break
            case .StartDictionaryTypeSyntaxOfTypealias:
                typealiasHolderStackArray[positionInTypealiasHolderStackArray].variableKind = .dictionary
            case .DictionaryKeyTypeOfTypealias:
                let keyType = parsedElementArray[1]
                typealiasHolderStackArray[positionInTypealiasHolderStackArray].dictionaryKeyType = keyType
                extractDependence(affectingTypeName: keyType, componentKind: .typealias)
            case .DictionaryValueTypeOfTypealias:
                let valueType = parsedElementArray[1]
                typealiasHolderStackArray[positionInTypealiasHolderStackArray].dictionaryValueType = valueType
                extractDependence(affectingTypeName: valueType, componentKind: .typealias)
            case .EndDictionaryTypeSyntaxOfTypealias:
                break
            case .StartTupleTypeSyntaxOfTypealias:
                typealiasHolderStackArray[positionInTypealiasHolderStackArray].variableKind = .tuple
            case .TupleTypeOfTypealias:
                let tupleType = parsedElementArray[1]
                typealiasHolderStackArray[positionInTypealiasHolderStackArray].tupleTypes.append(tupleType)
                extractDependence(affectingTypeName: tupleType, componentKind: .typealias)
            case .EndTupleTypeSyntaxOfTypealias:
                break
            case .EndTypealiasDecl:
                addTypealiasHolderToSuperHolder()
            // オプショナル型
            case .IsOptionalType:
                let typeKind = parsedElementArray[1]
                addIsOptional(typeKind: typeKind)
            // スペース
            case .Space:
                break
            } // end switch syntaxTag
        } // end for element in resultArray
        
        // 拡張される型よりextensionが先に検査される可能性がるので、extensionは全ての型を検査した後に各Holderへ格納する
        addExtensionHoldersToSuperHolder()
//        print("---------------------------------------")
        
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
    
//    func getWhomThisTypeAffectArray() -> [WhomThisTypeAffect] {
//        var array = [WhomThisTypeAffect]()
//        for dict in whomThisTypeAffectDict {
//            array.append(dict.value)
//        }
//        return array
//    }
    
    func getResultDependenceHolders() -> [DependenceHolder] {
        var array = [DependenceHolder]()
        for dict in resultDependenceHolders {
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
//    mutating private func extractingDependencies(affectingTypeName: String, affectedTypeName: String, affectedElementName: String? = nil) {
//        if let _ = whomThisTypeAffectDict[affectingTypeName] {
//            // 影響を及ぼす側の型の名前が、whomThisTypeAffectDictのKeyに既に登録されているとき
//            // affectingTypeNameをKeyに持つ要素のaffectedTypesNameに、affectedTypeNameを追加する
//            if let element = affectedElementName {
//                whomThisTypeAffectDict[affectingTypeName]!.affectedTypesName.append(WhomThisTypeAffect.Element(typeName: affectedTypeName, elementName: element))
//            } else {
//                whomThisTypeAffectDict[affectingTypeName]!.affectedTypesName.append(WhomThisTypeAffect.Element(typeName: affectedTypeName))
//            }
//        } else {
//            // 影響を及ぼす側の型の名前が、whomThisTypeAffectDictのKeyにまだ登録されていないとき
//            // affectingTypeNameをKeyとした、新しい要素を追加する
//            if let element = affectedElementName {
//                whomThisTypeAffectDict[affectingTypeName] = WhomThisTypeAffect(affectingTypeName: affectingTypeName, affectedTypesName: [WhomThisTypeAffect.Element(typeName: affectedTypeName, elementName: element)])
//            } else {
//                whomThisTypeAffectDict[affectingTypeName] = WhomThisTypeAffect(affectingTypeName: affectingTypeName, affectedTypesName: [WhomThisTypeAffect.Element(typeName: affectedTypeName)])
//            }
//        }
//    } // func extractingDependencies(affectingTypeName: String, affectedTypeName: String, affectedElementName: String? = nil)
    
    mutating private func extractDependence(affectingTypeName: String, componentKind: DetailComponentView.ComponentKind) {
        var affectedTypeKind = DependenceHolder.TypeKind.struct
        let declaringTypeKind = holderTypeStackArray[positionInHolderTypeStackArray]
        var declaringTypeName = ""
        
        // 宣言中の型の種類を取得する
        switch declaringTypeKind {
        case .struct:
            break
        case .class:
            affectedTypeKind = .class
        case .enum:
            affectedTypeKind = .enum
        case .protocol:
            affectedTypeKind = .protocol
        case .variable:
            let superTypeKind = holderTypeStackArray[positionInHolderTypeStackArray - 1]
            switch superTypeKind {
            case .struct:
                break
            case .class:
                affectedTypeKind = .class
            case .enum:
                affectedTypeKind = .enum
            case .protocol:
                affectedTypeKind = .protocol
            case .extension:
                return
            default:
                fatalError()
            }
        case .function:
            let superTypeKind = holderTypeStackArray[positionInHolderTypeStackArray - 1]
            switch superTypeKind {
            case .struct:
                break
            case .class:
                affectedTypeKind = .class
            case .enum:
                affectedTypeKind = .enum
            case .protocol:
                affectedTypeKind = .protocol
            case .extension:
                return
            default:
                fatalError()
            }
        case .initializer:
            let superTypeKind = holderTypeStackArray[positionInHolderTypeStackArray - 1]
            switch superTypeKind {
            case .struct:
                break
            case .class:
                affectedTypeKind = .class
            case .enum:
                affectedTypeKind = .enum
            case .protocol:
                affectedTypeKind = .protocol
            case .extension:
                return
            default:
                fatalError()
            }
        case .typealias:
            let superTypeKind = holderTypeStackArray[positionInHolderTypeStackArray - 1]
            switch superTypeKind {
            case .struct:
                break
            case .class:
                affectedTypeKind = .class
            case .enum:
                affectedTypeKind = .enum
            case .protocol:
                affectedTypeKind = .protocol
            case .extension:
                return
            default:
                fatalError()
            }
        case .generic:
            let superTypeKind = holderTypeStackArray[positionInHolderTypeStackArray - 1]
            switch superTypeKind {
            case .struct:
                break
            case .class:
                affectedTypeKind = .class
            case .enum:
                affectedTypeKind = .enum
            default:
                fatalError()
            }
        default:
            fatalError()
        }
        
        // 宣言中の型の名前を取得する
        switch affectedTypeKind {
        case .struct:
            declaringTypeName = structHolderStackArray[positionInStructHolderStackArray].name
        case .class:
            declaringTypeName = classHolderStackArray[positionInClassHolderStackArray].name
        case .enum:
            declaringTypeName = enumHolderStackArray[positionInEnumHolderStackArray].name
        case .protocol:
            declaringTypeName = protocolHolderStackArray[positionInProtocolHolderStackArray].name
        }
        
        // 現在宣言中の要素が、型の中で何番目になるかを取得する
        let newIndex = getNewIndexOfComponent(typKind: affectedTypeKind, componentKind: componentKind)
        
        let affectedType = DependenceHolder.AffectedType(affectedTypeKind: affectedTypeKind,
                                                         affectedTypeName: declaringTypeName,
                                                         componentKind: componentKind,
                                                         numberOfComponent: newIndex)
        
        // 抽出した依存関係をresultDependenceHoldersに格納する
        addAffectedTypeToRecultDependenceHolders(affectingTypeName: affectingTypeName, affectedType: affectedType)
    } // func extractDependence(affectingTypeName: String, componentKind: DetailComponentView.ComponentKind)
    
    // 抽出した依存関係をresultDependenceHoldersに格納する
    mutating private func addAffectedTypeToRecultDependenceHolders(affectingTypeName: String, affectedType: DependenceHolder.AffectedType) {
        if let _ = resultDependenceHolders[affectingTypeName] {
            // affectingTypeNameをKeyとする要素が既に存在するとき
            resultDependenceHolders[affectingTypeName]!.affectedTypes.append(affectedType)
        } else {
            // affectingTypeNameをKeyとする要素がまだないとき
            let dependenceHolder = DependenceHolder(affectingTypeName: affectingTypeName, affectedTypes: [affectedType])
            resultDependenceHolders[affectingTypeName] = dependenceHolder
        }
    } // func addAffectedTypeToRecultDependenceHolders(affectingTypeName: String, affectedType: DependenceHolder.AffectedType)
    
    private func getNewIndexOfComponent(typKind: DependenceHolder.TypeKind, componentKind: DetailComponentView.ComponentKind) -> Int {
        var index = 0
        
        switch typKind {
        case .struct:
            switch componentKind {
            case .generic:
                index = structHolderStackArray[positionInStructHolderStackArray].generics.count
            case .conform:
                index = structHolderStackArray[positionInStructHolderStackArray].conformingProtocolNames.count
            case .typealias:
                index = structHolderStackArray[positionInStructHolderStackArray].typealiases.count
            case .initializer:
                index = structHolderStackArray[positionInStructHolderStackArray].initializers.count
            case .property:
                index = structHolderStackArray[positionInStructHolderStackArray].variables.count
            case .method:
                index = structHolderStackArray[positionInStructHolderStackArray].functions.count
            default:
                fatalError()
            }
        case .class:
            switch componentKind {
            case .generic:
                index = classHolderStackArray[positionInClassHolderStackArray].generics.count
            case .conform:
                index = classHolderStackArray[positionInClassHolderStackArray].conformingProtocolNames.count
            case .typealias:
                index = classHolderStackArray[positionInClassHolderStackArray].typealiases.count
            case .initializer:
                index = classHolderStackArray[positionInClassHolderStackArray].initializers.count
            case .property:
                index = classHolderStackArray[positionInClassHolderStackArray].variables.count
            case .method:
                index = classHolderStackArray[positionInClassHolderStackArray].functions.count
            case .superClass:
                break
            default:
                fatalError()
            }
        case .enum:
            switch componentKind {
            case .generic:
                index = enumHolderStackArray[positionInEnumHolderStackArray].generics.count
            case .conform:
                index = enumHolderStackArray[positionInEnumHolderStackArray].conformingProtocolNames.count
            case .typealias:
                index = enumHolderStackArray[positionInEnumHolderStackArray].typealiases.count
            case .initializer:
                index = enumHolderStackArray[positionInEnumHolderStackArray].initializers.count
            case .property:
                index = enumHolderStackArray[positionInEnumHolderStackArray].variables.count
            case .method:
                index = enumHolderStackArray[positionInEnumHolderStackArray].functions.count
            case .rawvalueType:
                break
            case .case:
                index = enumHolderStackArray[positionInEnumHolderStackArray].cases.count
            case .associatedType:
                // 既にcaseが.append()されているため、1減らす
                index = enumHolderStackArray[positionInEnumHolderStackArray].cases.count - 1
            default:
                fatalError()
            }
        case .protocol:
            switch componentKind {
            case .conform:
                index = protocolHolderStackArray[positionInProtocolHolderStackArray].conformingProtocolNames.count
            case .typealias:
                index = protocolHolderStackArray[positionInProtocolHolderStackArray].typealiases.count
            case .initializer:
                index = protocolHolderStackArray[positionInProtocolHolderStackArray].initializers.count
            case .property:
                index = protocolHolderStackArray[positionInProtocolHolderStackArray].variables.count
            case .method:
                index = protocolHolderStackArray[positionInProtocolHolderStackArray].functions.count
            case .associatedType:
                index = protocolHolderStackArray[positionInProtocolHolderStackArray].associatedTypes.count
            default:
                fatalError()
            }
        } // switch typKind
        return index
    } // func getNewIndexOfComponent(typKind: DependenceHolder.TypeKind, componentKind: DetailComponentView.ComponentKind) -> Int
    
    
//    // function宣言中に依存関係を抽出したとき、"影響を及ぼす型->functionを持つHolder.function"の依存関係を保存する
//    mutating private func extractingDependenciesOfFunction(affectingTypeName: String) {
//        let functionName = functionHolderStackArray[positionInFunctionHolderStackArray].name
//        let superHolderName = getSuperTypeName(reducePosition: 1)
//        extractingDependencies(affectingTypeName: affectingTypeName, affectedTypeName: superHolderName, affectedElementName: functionName)
//    }
    
//    // initializer宣言中に依存関係を抽出したとき、"影響を及ぼす型->initializerを持つHolder.init"の依存関係を保存する
//    // initializerは名前を持たないので、affectedElementNameには、そのinitializerが型内で何番目かの数字を渡す
//    mutating private func extractingDependenciesOfInitializer(affectingTypeName: String) {
//        let num = numberOfInitializer
//        let superHolderName = getSuperTypeName(reducePosition: 1)
//        extractingDependencies(affectingTypeName: affectingTypeName, affectedTypeName: superHolderName, affectedElementName: "init \(num)")
//    }
    
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
            fatalError()
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
            fatalError()
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
                    let numberOfExtension = resultStructHolders[index].extensions.count
                    extractDependenceOfExtension(affectedTypeKind: .struct, extensionHolder: extensionHolder, numberOfExtension: numberOfExtension)
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
    } // func addExtensionHolderToSuperHolder()
    
    mutating private func extractDependenceOfExtension(affectedTypeKind: DependenceHolder.TypeKind, extensionHolder: ExtensionHolder, numberOfExtension num: Int) {
        let affectedTypeName = extensionHolder.extensionedTypeName!
        let numberOfExtension = num - 1
        
        // プロトコルへの準拠
        for (index, protocolName) in extensionHolder.conformingProtocolNames.enumerated() {
            let affectedType = DependenceHolder.AffectedType(affectedTypeKind: affectedTypeKind,
                                                             affectedTypeName: affectedTypeName,
                                                             numberOfExtension: numberOfExtension,
                                                             componentKind: .conform,
                                                             numberOfComponent: index)
            addAffectedTypeToRecultDependenceHolders(affectingTypeName: protocolName, affectedType: affectedType)
        }
        
        // typealias
        for (index, aliase) in extensionHolder.typealiases.enumerated() {
            let affectedType = DependenceHolder.AffectedType(affectedTypeKind: affectedTypeKind,
                                                             affectedTypeName: affectedTypeName,
                                                             numberOfExtension: numberOfExtension,
                                                             componentKind: .typealias,
                                                             numberOfComponent: index)
            switch aliase.variableKind {
            case .literal:
                addAffectedTypeToRecultDependenceHolders(affectingTypeName: aliase.literalType!, affectedType: affectedType)
            case .array:
                addAffectedTypeToRecultDependenceHolders(affectingTypeName: aliase.arrayType!, affectedType: affectedType)
            case .dictionary:
                addAffectedTypeToRecultDependenceHolders(affectingTypeName: aliase.dictionaryKeyType!, affectedType: affectedType)
                addAffectedTypeToRecultDependenceHolders(affectingTypeName: aliase.dictionaryValueType!, affectedType: affectedType)
            case .tuple:
                for tupleTypeName in aliase.tupleTypes {
                    addAffectedTypeToRecultDependenceHolders(affectingTypeName: tupleTypeName, affectedType: affectedType)
                }
            default:
                fatalError()
            } // switch aliase.variableKind
        } // for (index, aliase) in extensionHolder.typealiases.enumerated()
        
        // initializer
        for (index, initializer) in extensionHolder.initializers.enumerated() {
            let affectedType = DependenceHolder.AffectedType(affectedTypeKind: affectedTypeKind,
                                                             affectedTypeName: affectedTypeName,
                                                             numberOfExtension: numberOfExtension,
                                                             componentKind: .initializer,
                                                             numberOfComponent: index)
            for parameterHolder in initializer.parameters {
                switch parameterHolder.kind {
                case .literal:
                    addAffectedTypeToRecultDependenceHolders(affectingTypeName: parameterHolder.literalType!, affectedType: affectedType)
                case .array:
                    addAffectedTypeToRecultDependenceHolders(affectingTypeName: parameterHolder.arrayType!, affectedType: affectedType)
                case .dictionary:
                    addAffectedTypeToRecultDependenceHolders(affectingTypeName: parameterHolder.dictionaryKeyType!, affectedType: affectedType)
                    addAffectedTypeToRecultDependenceHolders(affectingTypeName: parameterHolder.dictionaryValueType!, affectedType: affectedType)
                case .tuple:
                    for tupleTypeName in parameterHolder.tupleTypes {
                        addAffectedTypeToRecultDependenceHolders(affectingTypeName: tupleTypeName, affectedType: affectedType)
                    }
                default:
                    fatalError()
                } // switch parameterHolder.kind
            } // for parameterHolder in initializer.parameters
        } // for (index, initializer) in extensionHolder.initializers.enumerated()
        
        // variable
        for (index, variable) in extensionHolder.variables.enumerated() {
            let affectedType = DependenceHolder.AffectedType(affectedTypeKind: affectedTypeKind,
                                                             affectedTypeName: affectedTypeName,
                                                             numberOfExtension: numberOfExtension,
                                                             componentKind: .property,
                                                             numberOfComponent: index)
            switch variable.kind {
            case .literal:
                addAffectedTypeToRecultDependenceHolders(affectingTypeName: variable.literalType!, affectedType: affectedType)
            case .array:
                addAffectedTypeToRecultDependenceHolders(affectingTypeName: variable.arrayType!, affectedType: affectedType)
            case .dictionary:
                addAffectedTypeToRecultDependenceHolders(affectingTypeName: variable.dictionaryKeyType!, affectedType: affectedType)
                addAffectedTypeToRecultDependenceHolders(affectingTypeName: variable.dictionaryValueType!, affectedType: affectedType)
            case .tuple:
                for tupleTypeName in variable.tupleTypes {
                    addAffectedTypeToRecultDependenceHolders(affectingTypeName: tupleTypeName, affectedType: affectedType)
                }
            case .opaqueResultType:
                addAffectedTypeToRecultDependenceHolders(affectingTypeName: variable.conformedProtocolByOpaqueResultType!, affectedType: affectedType)
            } // switch variable.kind
        } // for (index, variable) in extensionHolder.variables.enumerated()
    } // func extractDependenceOfExtension(affectedTypeKind: DependenceHolder.TypeKind, extensionHolder: ExtensionHolder, numberOfExtension num: Int)
    
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
            fatalError()
        }
    } // func getSuperType() -> String
    
    // 変数や引数がオプショナル型である情報を、それぞれのHolderに追加する
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
            functionHolderStackArray[positionInFunctionHolderStackArray].returnValue?.isOptional = true
        case .initializerParameter:
            initializerHolderStackArray[positionInInitializerHolderStackArray].parameters[positionInInitializerParameters].isOptionalType = true
        }
    }
    
    // numberOfInitializerを-1にリセットする
    mutating private func resetNumberOfInitializer() {
        numberOfInitializer = -1
    }
    
    // structの宣言を終了する
    // 親となるHolderがあるとき、そのnestingStructsに追加する
    // 親となるHolderがないとき、resultStructHoldersに追加する
    // HolderTypeStackArrayのポップ操作を行う
    // structHolderStackArrayのポップ操作を行う
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
//            print("resultStructHolders.append(structHolder) " + structHolder.name)
        }
        
        popHolderTypeStackArray()
        structHolderStackArray.removeLast()
        positionInStructHolderStackArray -= 1
    } // func addNestedStructToSuperHolderOrPopHolderTypeStackArray(structHolder: StructHolder)
    
    // classの宣言を終了する
    // 親となるHolderがあるとき、そのnestingClassesに追加する
    // 親となるHolderがないとき、resultClassHoldersに追加する
    // HolderTypeStackArrayのポップ操作を行う
    // classHolderStackArrayのポップ操作を行う
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
    
    // enumの宣言を終了する
    // 親となるHolderがあるとき、そのnestingEnumsに追加する
    // 親となるHolderがないとき、resultEnumHoldersに追加する
    // HolderTypeStackArrayのポップ操作を行う
    // enumHolderStackArrayのポップ操作を行う
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
    
    // genericを、親のgenericsプロパティに追加する
    // genericの宣言終了を検出したときに呼び出す
    // popHolderTypeStackArrayのポップ操作を行う
    // genericHolderStackArrayのポップ操作を行う
    // ジェネリック型のとき、"型制約のスーパークラスまたはプロトコル" -> "ジェネリック型" . "何番目の型引数かを表すインデックス"の依存関係を抽出する
    // ジェネリック関数のとき、"型制約のスーパークラスまたはプロトコル" -> "ジェネリック型" . "関数名"の依存関係を抽出する
    mutating private func addGenericToSuperHolder(generic: GenericHolder) {
        let holderType = holderTypeStackArray[positionInHolderTypeStackArray - 1]
        switch holderType {
        case .struct:
            structHolderStackArray[positionInStructHolderStackArray].generics.append(generic)
        case .class:
            classHolderStackArray[positionInClassHolderStackArray].generics.append(generic)
        case .enum:
            enumHolderStackArray[positionInEnumHolderStackArray].generics.append(generic)
        case .function:
            functionHolderStackArray[positionInFunctionHolderStackArray].generics.append(generic)
        default:
            fatalError()
        }
        
        popHolderTypeStackArray()
        genericHolderStackArray.removeLast()
        positionInGenericHolderStackArray -= 1
    } // func addGenericToSuperHolder(generic: GenericHolder)
    
    // positionInGenericParameterを-1にリセットする
    mutating private func resetNumberOfGeneric() {
        positionInGenericParameter = -1
    }
    
    // TypealiasHolderを、親のtypealiasesプロパティに追加する
    // typealiasの宣言終了を検出したときに呼び出す
    // popHolderTypeStackArrayのポップ操作を行う
    // typealiasHolderStackArrayのポップ操作を行う
    mutating private func addTypealiasHolderToSuperHolder() {
        let typealiasHolder = typealiasHolderStackArray[positionInTypealiasHolderStackArray]
        let holderType = holderTypeStackArray[positionInHolderTypeStackArray - 1]
        
        switch holderType {
        case .struct:
            structHolderStackArray[positionInStructHolderStackArray].typealiases.append(typealiasHolder)
        case .class:
            classHolderStackArray[positionInClassHolderStackArray].typealiases.append(typealiasHolder)
        case .enum:
            enumHolderStackArray[positionInEnumHolderStackArray].typealiases.append(typealiasHolder)
        case .protocol:
            protocolHolderStackArray[positionInProtocolHolderStackArray].typealiases.append(typealiasHolder)
        case .extension:
            extensionHolderStackArray[positionInExtensionHolderStackArray].typealiases.append(typealiasHolder)
        default:
            fatalError()
        }
        
        popHolderTypeStackArray()
        typealiasHolderStackArray.removeLast()
        positionInTypealiasHolderStackArray -= 1
    } // func addTypealiasHolderToSuperHolder()
} // end struct SyntaxArrayParser
