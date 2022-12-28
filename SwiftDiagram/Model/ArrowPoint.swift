//
//  Point.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/27.
//

import Foundation

class ArrowPoint: ObservableObject {
    @Published private var currentX: CGFloat = 300
    @Published private var currentY: CGFloat = 300 + 90 + 45
    
    @Published private var startX: CGFloat = 300
    @Published private var startY: CGFloat = 300 + 90 + 45
    
    @Published private var maxY: CGFloat = 300 + 90 + 45
    
    // 矢印の始点と終点を保存する配列
    @Published var points = [Point]()
    struct Point {
        let affecter: String
        let affecteder: String
        var start: CGPoint?
        var end: CGPoint?
    }
    
    func initialize() {
        startX = 300
        startY = 300 + 90 + 45
        currentX = 300
        currentY = 300 + 90 + 45
    }
    
    
}
