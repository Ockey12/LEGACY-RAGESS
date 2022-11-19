//
//  CodeScrollView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/19.
//

import SwiftUI

struct CodeScrollView: View {
    @Binding var displayedText: String
    
    var body: some View {
        ScrollView {
            Text(displayedText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

//struct CodeScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        CodeScrollView()
//    }
//}
