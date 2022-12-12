//
//  VariableKind.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/06.
//

import Foundation

// variableやfunctionParameterの型の種類
enum VariableKind {
    case literal // String, Intなど
    case array
    case dictionary
    case tuple
    case opaqueResultType
}
