//
//  GetTextWidthView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/15.
//

import SwiftUI

struct GetTextWidthView: View {
    var strings: [String]
    @Binding var maxWidth: Double
    @State private var textSize: CGSize = CGSize()
    let fontSize = ComponentSettingValues.fontSize
    
    var body: some View {
        VStack {
            ForEach(strings, id: \.self) { string in
                Text(string)
                    .font(.system(size: fontSize))
                    .foregroundColor(.clear)
                    .background(.clear)
                    .background() {
                        GeometryReader { geometry in
                            Path { path in
                                let width = geometry.size.width
                                DispatchQueue.main.async {
                                    if maxWidth < width {
                                        maxWidth = width
                                    }
                                }
                            } // Path
                        } // GeometryReader
                    } // .background()
            } // ForEach(strings, id: \.self)
        } // VStack
    } // var body
} // struct GetTextWidthView

//struct GetTextWidthView_Previews: PreviewProvider {
//    static var previews: some View {
//        GetTextWidthView()
//    }
//}
