//
//  Nestable.swift
//  RUISS
//
//  Created by オナガ・ハルキ on 2023/01/24.
//

import Foundation

protocol Nestable {
    // この型がネストしている型
    var nestingStructs: [StructHolder] { get set }
    var nestingClasses: [ClassHolder] { get set }
    var nestingEnums: [EnumHolder] { get set }
}
