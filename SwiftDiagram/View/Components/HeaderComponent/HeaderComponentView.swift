//
//  HeaderComponentView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/15.
//

import SwiftUI

struct HeaderComponentView: View {
    @EnvironmentObject var arrowPoint: ArrowPoint
    let accessLevelIcon: String
    let indexType: IndexComponentFrameWithText.IndexType
    let nameOfType: String
    let bodyWidth: CGFloat
    
    let itemHeight = ComponentSettingValues.itemHeight
    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            IndexComponentFrameWithText(accessLevelIcon: accessLevelIcon,
                                        headerComponentIndexType: indexType)
                .offset(x: arrowTerminalWidth, y: 0)
                .onTapGesture {
                    hideAllDependence()
                    showThisTypeAffects(name: nameOfType)
                }
            
            HeaderComponentFrameWithText(nameOfType: nameOfType, bodyWidth: bodyWidth)
                .offset(x: 0, y: itemHeight)
                .onTapGesture {
                    hideAllDependence()
                    showThisTypeAffects(name: nameOfType)
                }
        } // ZStack
    } // var body
    
    private func hideAllDependence() {
        for i in 0..<arrowPoint.points.count {
            arrowPoint.points[i].isVisible = false
        }
    }
    
    private func showThisTypeAffects(name: String) {
        for (index, point) in arrowPoint.points.enumerated() {
            if point.affecterName == name {
                arrowPoint.points[index].isVisible = true
                showThisTypeAffects(name: point.affectedName)
            }
        }
    } // func tappedTypePerform(name: String)
} // struct HeaderComponentView

//struct HeaderComponentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderComponentView(arrowPoint: ArrowPoint(),
//                            accessLevelIcon: "-",
//                            indexType: .class,
//                            nameOfType: "SomeClass",
//                            bodyWidth: 800)
//    }
//}
