//
//  ArrowLineShape.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/27.
//

import SwiftUI

struct ArrowLineView: View {
    let start: CGPoint
    let end: CGPoint
    
    var body: some View {
        Path { path in
            path.move(to: start)
            path.addLine(to: end)
        }
        .stroke(lineWidth: 20)
        .fill(.black)
    }
}

//struct ArrowLineShape_Previews: PreviewProvider {
//    static var previews: some View {
//        ArrowLineView()
//    }
//}
