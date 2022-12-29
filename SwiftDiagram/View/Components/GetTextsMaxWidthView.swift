//
//  GetTextWidthView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/15.
//

import SwiftUI

struct GetTextsMaxWidthView: View {
    @EnvironmentObject var arrowPoint: ArrowPoint
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
                        let dt = Date()
                        let dateFormatter: DateFormatter = DateFormatter()
                        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
                        if maxWidth < width {
                            maxWidth = width
//                            arrowPoint.refreshFlag.toggle()
                        }
//                        arrowPoint.refreshFlag.toggle()
                        arrowPoint.changeDate = "\(dateFormatter.string(from: dt))"
                        maxWidthHolder.maxWidthDict[holderName] = maxWidth
                        print("<DEBUG>GetTextsMaxWidthView: " + holderName)
                        print("<DEBUG>GetTextsMaxWidthView: \(dateFormatter.string(from: dt))")
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
