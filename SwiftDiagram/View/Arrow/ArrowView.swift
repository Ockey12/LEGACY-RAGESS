//
//  ArrowView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/27.
//

import SwiftUI

struct ArrowView: View {
    let start: CGPoint
    let end: CGPoint
    
    let arrowHeadFrameLength: CGFloat = 70
    
    var body: some View {
        ZStack {
            ZStack {
                ArrowHeadView(centerOfRotation: endPoint(start: start, end: end), rotate: angle(a: start, b: end), arrowHeadFrameLength: arrowHeadFrameLength)
            }
            .frame(width: arrowHeadFrameLength, height: arrowHeadFrameLength)
            .position(x: endPoint(start: start, end: end).x, y: endPoint(start: start, end: end).y)
            ArrowLineView(start: start, end: endPoint(start: start, end: end))
        }
    } // var body
    
    // 線分をendまで伸ばすと、三角形の角よりも線分の角のほうが外側になってしまう
    // 線分の終端の(x, y)座標を、それぞれtipMarginの値の分だけ線分が短くなるようにする
    // 短くなった新しい線分の終端の座標を返す
    private func endPoint(start: CGPoint, end: CGPoint) -> CGPoint {
        let tipMargin: CGFloat = 20
        var endX = end.x
        var endY = end.y
        
        if end.x < start.x {
            endX += tipMargin
        } else if start.x < end.x {
            endX -= tipMargin
        }
        
        if end.y < start.y {
            endY += tipMargin
        } else if start.y < end.y {
            endY -= tipMargin
        }
        
        return CGPoint(x: endX, y: endY)
    } // func endPoint(start: CGPoint, end: CGPoint) -> CGPoint
    
    private func angle(a: CGPoint, b: CGPoint) -> Angle {
        var r = atan2(b.y - a.y, b.x - a.x)
        if r < 0 {
            r = r + 2*Double.pi
        }
        return Angle(degrees: floor(r*360 / (2*Double.pi)))
    } // func angle(a: CGPoint, b: CGPoint) -> Angle
}

//struct ArrowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArrowView()
//    }
//}
