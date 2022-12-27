//
//  Point.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/27.
//

import Foundation

class ArrowPoint: ObservableObject {
    @Published var currentX: CGFloat = 300
    @Published var currentY: CGFloat = 300 + 90 + 45
    
    @Published var startX: CGFloat = 300
    @Published var startY: CGFloat = 300 + 90 + 45
    
    @Published var maxY: CGFloat = 300 + 90 + 45
    
    // 矢印の始点と終点を保存する辞書
    @Published var points = [String: Point]()
    struct Point {
//        let affecter: String
//        let affecteder: String
        var start: CGPoint?
        var end: CGPoint?
    }
}
