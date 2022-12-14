//
//  DetailComponentView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/15.
//

import SwiftUI

struct DetailComponentView: View {
    let componentType: ComponentType
    let strings: [String]
    let bodyWidth: CGFloat
    var widthFromLeftEdgeToConnection: CGFloat {
        (bodyWidth - connectionWidth) / 2 + arrowTerminalWidth
    }
    
    let connectionHeight = ComponentSettingValues.connectionHeight
    let connectionWidth = ComponentSettingValues.connectionWidth
    let itemHeight = ComponentSettingValues.itemHeight
    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    let textLeadingPadding = ComponentSettingValues.textLeadingPadding
    let borderWidth = ComponentSettingValues.borderWidth
    let fontSize = ComponentSettingValues.fontSize
    
    enum ComponentType {
        case generic
        case conform
        case `typealias`
        case initializer
        
        case superClass
        case rawvalueType
        case `case`
        case nest
        case property
        case method
        case associatedType
        
        var string: String {
            switch self {
            case .generic:
                return "Generic"
            case .conform:
                return "Conform"
            case .typealias:
                return "Typealias"
            case .initializer:
                return "Initializer"
                
            case .superClass:
                return "Super Class"
            case .rawvalueType:
                return "Rawvalue Type"
            case .case:
                return "Case"
            case .nest:
                return "Nest"
            case .property:
                return "Property"
            case .method:
                return "Method"
            case .associatedType:
                return "Associated Type"
            }
        }
    } // enum ComponentType
    
    var body: some View {
        ZStack {
            DetailComponentFrame(bodyWidth: bodyWidth, numberOfItems: strings.count)
                .stroke(lineWidth: borderWidth)
                .fill(.black)
            
            Text(componentType.string)
                .lineLimit(1)
                .font(.system(size: fontSize))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .position(x: bodyWidth/2 + arrowTerminalWidth, y: connectionHeight/2)
            
            ForEach(0..<strings.count, id: \.self) { numberOfString in
                Text(strings[numberOfString])
                    .lineLimit(1)
                    .font(.system(size: 50))
                    .foregroundColor(.black)
                    .background(.white)
                    .frame(width: bodyWidth, alignment: .leading)
                    .position(x: (bodyWidth + textLeadingPadding )/2 + arrowTerminalWidth,
                              y: connectionHeight + itemHeight*CGFloat(numberOfString) + itemHeight/2)
            }
        } // ZStack
    } // var body
} // struct DetailComponentView

//struct DetailComponentView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailComponentView()
//    }
//}
