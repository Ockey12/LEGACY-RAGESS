//
//  TypeHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

protocol TypeHolder: Holder {
    // この型が準拠しているプロトコル
    var conformingProtocolNames: [String] { get set }
    
    // typealias
    var typealiases: [TypealiasHolder] { get set }
    
    // イニシャライザ
    var initializers: [InitializerHolder] { get set }
    
    // プロパティ
    var variables: [VariableHolder] { get set }
    
    // メソッド
    var functions: [FunctionHolder] { get set }
}
