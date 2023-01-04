//
//  CanDrawArrowFlag.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2023/01/04.
//

import Foundation

class CanDrawArrowFlag: ObservableObject {
    @Published var flag = false
    
    func reset() {
        flag = false
    }
}
