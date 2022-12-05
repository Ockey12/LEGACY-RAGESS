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
        }
        print("---------------------------------------")
    }
}
