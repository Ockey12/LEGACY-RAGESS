//
//  FunctionHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/05.
//

import Foundation

struct FunctionHolder: HaveNameAndAccessLevelHolder {
    var ID: Int?
    var name: String = ""
    var accessLevel: AccessLevel = .internal
    
    var isStatic = false
    var isOverride = false
    var isMutating = false
    
    struct ParameterHolder: Holder {
        
    }
}
