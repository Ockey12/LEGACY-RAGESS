//
//  IndexComponentFrameWithText.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/14.
//

import SwiftUI

struct IndexComponentFrameWithText: View {
    let accessLevelIcon: String
    let headerComponentIndexType: IndexType
    
    let width = ComponentSettingValues.indexWidth
    let height = ComponentSettingValues.itemHeight
    let borderWidth = ComponentSettingValues.borderWidth
    let fontSize = ComponentSettingValues.fontSize
    
    var text: String {
        if accessLevelIcon == AccessLevel.internal.icon {
            return headerComponentIndexType.string
        } else {
            return accessLevelIcon + "  " + headerComponentIndexType.string
        }
    }
    
    enum IndexType {
        case `struct`
        case `class`
        case `enum`
        case `protocol`
        
        var string: String {
            switch self {
            case .struct:
                return "Struct"
            case .class:
                return "Class"
            case .enum:
                return "Enum"
            case .protocol:
                return "Protocol"
            }
        }
    }
    
    var body: some View {
        ZStack {
            IndexComponentFrame()
                .fill(Color(red: 180/256, green: 180/256, blue: 180/256))
                .frame(width: width, height: height)
            
            IndexComponentFrame()
                .stroke(lineWidth: borderWidth)
                .fill(Color.black)
                .frame(width: width, height: height)
            
            Text(text)
                .lineLimit(1)
                .frame(width: width, height: height)
                .font(.system(size: 50))
                .foregroundColor(.black)
        } // ZStack
    } // var body
} // struct IndexComponentFrameWithText

//struct IndexComponentFrameWithText_Previews: PreviewProvider {
//    static var previews: some View {
//        IndexComponentFrameWithText()
//    }
//}
