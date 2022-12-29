//
//  Point.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/27.
//

import Foundation

class ArrowPoint: ObservableObject {
    @Published var changeDate = ""
    @Published var refreshFlag = true
//    @Published private var currentX: CGFloat = 300
//    @Published private var currentY: CGFloat = 300 + 90 + 45
    @Published private var currentPoint = CGPoint(x: 300, y: 300 + 90 + 45)
    
    @Published private var startX: CGFloat = 300
    @Published private var startY: CGFloat = 300 + 90 + 45
    
    @Published private var maxY: CGFloat = 300 + 90 + 45
    
    // 矢印の始点と終点を保存する配列
    @Published var points = [Point]()
    struct Point: Hashable {
        let affecter: String
        let affecteder: String
        var startRight: CGPoint?
        var startLeft: CGPoint?
        var endRight: CGPoint?
        var endLeft: CGPoint?
        
        var start: CGPoint {
            var startPoint = startRight!
            // 右から右
            var length = sqrt(pow(startRight!.x - endRight!.x, 2) + pow(startRight!.y - endRight!.y, 2))
            if sqrt(pow(startRight!.x - endLeft!.x, 2) + pow(startRight!.y - endLeft!.y, 2)) < length {
                // 右から左
                length = sqrt(pow(startRight!.x - endLeft!.x, 2) + pow(startRight!.y - endLeft!.y, 2))
            }
            if sqrt(pow(startLeft!.x - endRight!.x, 2) + pow(startLeft!.y - endRight!.y, 2)) < length {
                // 左から右
                startPoint = startLeft!
                length = sqrt(pow(startLeft!.x - endRight!.x, 2) + pow(startLeft!.y - endRight!.y, 2))
            }
            if sqrt(pow(startLeft!.x - endLeft!.x, 2) + pow(startLeft!.y - endLeft!.y, 2)) < length {
                // 左から左
                startPoint = startLeft!
                length = sqrt(pow(startLeft!.x - endLeft!.x, 2) + pow(startLeft!.y - endLeft!.y, 2))
            }
            return startPoint
        } // var start
        
        var end: CGPoint {
            var endPoint = endRight!
            // 右から右
            var length = sqrt(pow(startRight!.x - endRight!.x, 2) + pow(startRight!.y - endRight!.y, 2))
            if sqrt(pow(startRight!.x - endLeft!.x, 2) + pow(startRight!.y - endLeft!.y, 2)) < length {
                // 右から左
                endPoint = endLeft!
                length = sqrt(pow(startRight!.x - endLeft!.x, 2) + pow(startRight!.y - endLeft!.y, 2))
            }
            if sqrt(pow(startLeft!.x - endRight!.x, 2) + pow(startLeft!.y - endRight!.y, 2)) < length {
                // 左から右
                endPoint = endRight!
                length = sqrt(pow(startLeft!.x - endRight!.x, 2) + pow(startLeft!.y - endRight!.y, 2))
            }
            if sqrt(pow(startLeft!.x - endLeft!.x, 2) + pow(startLeft!.y - endLeft!.y, 2)) < length {
                // 左から左
                endPoint = endLeft!
                length = sqrt(pow(startLeft!.x - endLeft!.x, 2) + pow(startLeft!.y - endLeft!.y, 2))
            }
            return endPoint
        } // var end
    } // struct Point
    
    func getCurrent() -> CGPoint {
        return currentPoint
    }
    
    func initialize() {
        startX = 300
        startY = 300 + 90 + 45
        currentPoint = CGPoint(x: 300, y: 300 + 90 + 45)
    }
    
    func setCurrentX(_ x: CGFloat) {
        currentPoint.x = x
    }
}
