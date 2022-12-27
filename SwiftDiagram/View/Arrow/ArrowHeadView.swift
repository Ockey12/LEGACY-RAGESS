//
//  ArrowHeadShape.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/27.
//

import SwiftUI

struct ArrowHeadView: View {
    let centerOfRotation: CGPoint
    let rotate: Angle
    let arrowHeadFrameLength: CGFloat
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: arrowHeadFrameLength, y: arrowHeadFrameLength/2))
            
            path.addLine(to: CGPoint(x: 0, y: arrowHeadFrameLength))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: arrowHeadFrameLength, y: arrowHeadFrameLength/2))
        }
        .fill(.black)
        .rotationEffect(rotate)
    }
}

//struct ArrowHeadShape_Previews: PreviewProvider {
//    static var previews: some View {
//        ArrowHeadView()
//    }
//}
