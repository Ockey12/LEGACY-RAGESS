//
//  GetTextWidthView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/15.
//

import SwiftUI

struct GetTextsMaxWidthView: View {
    var holderName: String
    var strings: [String]
    @EnvironmentObject var maxWidthHolder: MaxWidthHolder
    @Binding var maxWidth: Double
    @State private var textSize: CGSize = CGSize()
    let fontSize = ComponentSettingValues.fontSize
    
    var body: some View {
        VStack {
            ForEach(strings, id: \.self) { string in
                Text(string)
                    .lineLimit(1)
                    .font(.system(size: fontSize))
                    .foregroundColor(.clear)
                    .background(.clear)
            } // ForEach(strings, id: \.self)
        } // VStack
        .background() {
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    DispatchQueue.main.async {
                        if maxWidth < width {
                            maxWidth = width
                            print("e")
                        }
                        maxWidthHolder.maxWidthDict[holderName] = maxWidth
                    }
                } // Path
            } // GeometryReader
        } // .background()
    } // var body
} // struct GetTextWidthView

//struct GetTextWidthView_Previews: PreviewProvider {
//    static var previews: some View {
//        GetTextWidthView()
//    }
//}
