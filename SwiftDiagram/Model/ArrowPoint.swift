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
    let connectionHeight = ComponentSettingValues.connectionHeight
    let itemHeight = ComponentSettingValues.itemHeight
    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    let protocolIndent = ComponentSettingValues.protocolIndent
    let structIndent = ComponentSettingValues.structIndent
    let classIndent = ComponentSettingValues.classIndent
    let enumIndent = ComponentSettingValues.enumIndent
    
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
        
        var start: CGPoint? {
            guard let startR = startRight,
                  let startL = startLeft,
                  let endR = endRight,
                  let endL = endLeft
            else {
                      return nil
                  }
            
            var startPoint = startR
            // 右から右
            var length = sqrt(pow(startR.x - endR.x, 2) + pow(startR.y - endR.y, 2))
            if sqrt(pow(startR.x - endL.x, 2) + pow(startR.y - endL.y, 2)) < length {
                // 右から左
                length = sqrt(pow(startR.x - endL.x, 2) + pow(startR.y - endL.y, 2))
            }
            if sqrt(pow(startL.x - endR.x, 2) + pow(startL.y - endR.y, 2)) < length {
                // 左から右
                startPoint = startL
                length = sqrt(pow(startL.x - endR.x, 2) + pow(startL.y - endR.y, 2))
            }
            if sqrt(pow(startL.x - endL.x, 2) + pow(startL.y - endL.y, 2)) < length {
                // 左から左
                startPoint = startL
                length = sqrt(pow(startL.x - endL.x, 2) + pow(startL.y - endL.y, 2))
            }
            return startPoint
        } // var start
        
        var end: CGPoint? {
            guard let startR = startRight,
                  let startL = startLeft,
                  let endR = endRight,
                  let endL = endLeft
            else {
                      return nil
                  }
            var endPoint = endR
            // 右から右
            var length = sqrt(pow(startR.x - endR.x, 2) + pow(startR.y - endR.y, 2))
            if sqrt(pow(startR.x - endL.x, 2) + pow(startR.y - endL.y, 2)) < length {
                // 右から左
                endPoint = endL
                length = sqrt(pow(startR.x - endL.x, 2) + pow(startR.y - endL.y, 2))
            }
            if sqrt(pow(startL.x - endR.x, 2) + pow(startL.y - endR.y, 2)) < length {
                // 左から右
                endPoint = endRight!
                length = sqrt(pow(startL.x - endR.x, 2) + pow(startL.y - endR.y, 2))
            }
            if sqrt(pow(startL.x - endL.x, 2) + pow(startL.y - endL.y, 2)) < length {
                // 左から左
                endPoint = endLeft!
                length = sqrt(pow(startL.x - endL.x, 2) + pow(startL.y - endL.y, 2))
            }
            return endPoint
        } // var end
    } // struct Point
    
    func getStartPoint() -> CGPoint {
        return startPoint
    }
    
    func initialize() {
        startPoint = CGPoint(x: 300 + protocolIndent, y: 300 + 90 + 45)
        maxY = 300 + 90 + 45
    }
    
    func moveToDownerHStack(typeKind: HolderType) {
        startPoint.x = 300
        switch typeKind {
        case .struct:
            startPoint.x += structIndent
        case .class:
            startPoint.x += classIndent
        case .enum:
            startPoint.x += enumIndent
        default:
            fatalError()
        }
        
        startPoint.y = maxY + 300 + 90 + 45 + 45
    }
    
    func moveToNextType(currentPoint: CGPoint, width: Double, numberOfExtensin: Int) {
        var newCurrentX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2 + 300 + 300 + 4
        if 0 < numberOfExtensin {
            newCurrentX += extensionOutsidePadding - arrowTerminalWidth - 4
        }
        startPoint.x = newCurrentX
        
        var currentY = currentPoint.y
        if numberOfExtensin == 0 {
            currentY += itemHeight/2
            currentY += bottomPaddingForLastText
            currentY += connectionHeight
        }
        if maxY < currentY {
            maxY = currentY
        }
    }
    
    func setStartX(_ x: CGFloat) {
        startPoint.x = x
    }
    
    func numberOfDependence() -> Int {
        points.count
    }
}
