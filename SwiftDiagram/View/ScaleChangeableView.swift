//
//  ScaleChangeableView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/19.
//

import SwiftUI

struct ScaleChangeableView: View {
    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            MonitorView()
        } // ScrollView
        .background(.white)
        
    }
}

//struct ScaleChangeableView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScaleChangeableView()
//    }
//}
