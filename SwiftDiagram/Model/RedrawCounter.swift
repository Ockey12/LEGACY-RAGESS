//
//  RedrawCounter.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2023/01/04.
//

import Foundation

class RedrawCounter: ObservableObject {
    @Published var count: Int = 0
    
    func increment() {
        count += 1
    }
    
    func reset() {
        count = 0
    }
    
    func getCount() -> Int {
        count
    }
    
    func canRedraw() -> Bool {
        if count < 5 {
            return true
        } else {
            return false
        }
    }
}
