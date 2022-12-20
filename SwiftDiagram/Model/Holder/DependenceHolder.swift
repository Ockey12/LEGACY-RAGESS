//
//  DependenceHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/20.
//

import Foundation

struct DependenceHolder {
//    var affectingTypeKind: TypeKind
    var affectingTypeName: String
    var affectedTypes: [AffectedType]
    
    enum TypeKind {
        case `struct`
        case `class`
        case `enum`
        case `protocol`
    }
    
    struct AffectedType {
        var affectedTypeKind: TypeKind
        var affectedTypeName: String
        var componentKind: DetailComponentView.ComponentKind
        var numberOfComponent: Int
    }
}
