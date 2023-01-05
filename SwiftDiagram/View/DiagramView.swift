//
//  DiagramView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/19.
//

import SwiftUI

struct DiagramView: View {
    @EnvironmentObject var monitor: BuildFileMonitor
    @EnvironmentObject var arrowPoint: ArrowPoint
    
    let connectionHeight = ComponentSettingValues.connectionHeight
    let protocolIndent = ComponentSettingValues.protocolIndent
    let structIndent = ComponentSettingValues.structIndent
    let classIndent = ComponentSettingValues.classIndent
    let enumIndent = ComponentSettingValues.enumIndent
    
    @State var x: CGFloat = 0
    @State var y: CGFloat = 0
    
    @State var circlePositions = [CirclePosition]()
    
    struct CirclePosition: Hashable {
        var x: CGFloat
        var y: CGFloat
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Protocol
            HStack(alignment: .top, spacing: 0) {
                Rectangle()
                    .frame(width: protocolIndent)
                    .foregroundColor(.clear)
                ForEach(monitor.getProtocol(), id: \.self) { holder in
                    ProtocolView(holder: holder)
                        .padding(.init(top: 300, leading: 300, bottom: 300, trailing: 300))
                }
            } // HStack
            
            // Struct
            HStack(alignment: .top, spacing: 0) {
                Rectangle()
                    .frame(width: structIndent)
                    .foregroundColor(.clear)
                ForEach(monitor.getStruct(), id: \.self) { holder in
                    StructView(holder: holder)
                        .padding(.init(top: 300, leading: 300, bottom: 300, trailing: 300))
                }
            } // HStack
            
            // Class
            HStack(alignment: .top, spacing: 0) {
                Rectangle()
                    .frame(width: classIndent)
                    .foregroundColor(.clear)
                ForEach(monitor.getClass(), id: \.self) { holder in
                    ClassView(holder: holder)
                        .padding(.init(top: 300, leading: 300, bottom: 300, trailing: 300))
                }
            } // HStack

            // Enum
            HStack(alignment: .top, spacing: 0) {
                Rectangle()
                    .frame(width: enumIndent)
                    .foregroundColor(.clear)
                ForEach(monitor.getEnum(), id: \.self) { holder in
                    EnumView(holder: holder)
                        .padding(.init(top: 300, leading: 300, bottom: 300, trailing: 300))
                }
            } // HStack
            
        } // VStack
    } // var body
} // struct DiagramView
