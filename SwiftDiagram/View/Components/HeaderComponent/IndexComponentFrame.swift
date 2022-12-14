//
//  IndexComponentFrame.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/14.
//

import SwiftUI

struct IndexComponentFrame: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            // bottom left
            path.move(to: CGPoint(x: 0, y: rect.height))
            // bottom right
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            // top right
            path.addLine(to: CGPoint(x: rect.width, y: rect.height * 1/4))
            path.addArc(center: CGPoint(x: rect.width - rect.height * 1/4,
                                        y: rect.height * 1/4),
                        radius: rect.height * 1/4,
                        startAngle: .degrees(0),
                        endAngle: .degrees(-90),
                        clockwise: true)
            // top
            path.addLine(to: CGPoint(x: rect.height * 1/4, y: 0))
            // top left
            path.addArc(center: CGPoint(x: rect.height * 1/4,
                                        y: rect.height * 1/4),
                        radius: rect.height * 1/4,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(-180),
                        clockwise: true)
            path.closeSubpath()
        } // Path
    } // func path(in rect: CGRect) -> Path
} // struct IndexComponentFrame

struct IndexComponentFrame_Previews: PreviewProvider {
    static var previews: some View {
        IndexComponentFrame()
    }
}
