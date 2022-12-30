//
//  Point.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/27.
//

import Foundation

class ArrowPoint: ObservableObject {
    @Published var changeDate = ""
    @Published private var startPoint = CGPoint(x: 300, y: 300 + 90 + 45)
    @Published var maxY: CGFloat = 300 + 90 + 45
    
    let textTrailPadding = ComponentSettingValues.textTrailPadding
    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    let extensionOutsidePadding = ComponentSettingValues.extensionOutsidePadding
    
    // 矢印の始点と終点を保存する配列
    @Published var points = [Point]()
    struct Point: Hashable {
        let affecterName: String
        let affectedName: String
        let affectedComponentKind: DetailComponentView.ComponentKind
        let numberOfAffectedComponent: Int
        var numberOfAffectedExtension: Int?
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
    
    func getStartPoint() -> CGPoint {
        return startPoint
    }
    
    func initialize() {
        startPoint = CGPoint(x: 300, y: 300 + 90 + 45)
        maxY = 300 + 90 + 45
    }
    
    func moveToDownerHStack() {
        startPoint.x = 300
        startPoint.y = maxY + 300 + 90 + 45 + 45
    }
    
    func moveToNextType(currentPoint: CGPoint, width: Double, numberOfExtensin: Int) {
        var newCurrentX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2 + 300 + 300 + 4
        if 0 < numberOfExtensin {
            newCurrentX += extensionOutsidePadding - arrowTerminalWidth - 4
        }
        startPoint.x = newCurrentX
        
        if maxY < currentPoint.y {
            maxY = currentPoint.y
        }
    }
    
    func setStartX(_ x: CGFloat) {
        startPoint.x = x
    }
}
