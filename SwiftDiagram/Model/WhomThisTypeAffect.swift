//
//  WhomThisTypeAffect.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/06.
//

import Foundation

struct WhomThisTypeAffect {
    var affectingTypeName: String
    var affectedTypesName: [Element]
    
    struct Element {
        var typeName: String
        var elementName: String?
    }
}
