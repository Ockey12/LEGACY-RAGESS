//
//  TypeHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

protocol TypeHolder: HaveNameAndAccessLevelHolder {
    // この型が準拠しているプロトコル
    var conformingProtocols: [String] { get set }
    
    // プロパティ
    var variables: [VariableHolder] { get set }
    
    // メソッド
    var functions: [FunctionHolder] { get set }
    
    // この型がネストしている型
    var nestingStructs: [StructHolder] { get set }
    var nestingClasses: [ClassHolder] { get set }
    var nestingEnums: [EnumHolder] { get set }
    
    // この型をネストしている型
    var nestSuperTypeName: String? { get set }
}
