//
//  DependenceHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/20.
//

import Foundation

struct DependenceHolder {
    var affectingTypeName: String
    var affectedTypes: [AffectedType]
    
    enum TypeKind {
        case `struct`
        case `class`
        case `enum`
        case `protocol`
    }
    
    struct AffectedType: Equatable {
        var affectedTypeKind: TypeKind
        var affectedTypeName: String
        var numberOfExtension: Int? = nil
        var componentKind: DetailComponentView.ComponentKind
        var numberOfComponent: Int
    }
}

extension DependenceHolder: Equatable {
    static func == (lhs: DependenceHolder, rhs: DependenceHolder) -> Bool {
        return (lhs.affectingTypeName == rhs.affectingTypeName) &&
                (lhs.affectedTypes == rhs.affectedTypes)
    }
}
