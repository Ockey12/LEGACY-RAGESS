//
//  DiagramView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/19.
//

import SwiftUI

struct DiagramView: View {
    @EnvironmentObject var monitor: BuildFileMonitor
    
    let connectionHeight = ComponentSettingValues.connectionHeight
    
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
                ForEach(monitor.convertedProtocolHolders, id: \.self) { holder in
                    ProtocolView(holder: holder)
                        .padding(.init(top: 300, leading: 300, bottom: 300, trailing: 300))
                }
            } // HStack
            
            // Struct
            HStack(alignment: .top, spacing: 0) {
                ForEach(monitor.convertedStructHolders, id: \.self) { holder in
                    StructView(holder: holder)
                        .padding(.init(top: 300, leading: 300, bottom: 300, trailing: 300))
                }
            } // HStack
//            .onAppear {
//                print("bbbbbbbbbb")
//            }
            
            // Class
            HStack(alignment: .top, spacing: 0) {
                ForEach(monitor.convertedClassHolders, id: \.self) { holder in
                    ClassView(holder: holder)
                        .padding(.init(top: 300, leading: 300, bottom: 300, trailing: 300))
                }
            } // HStack

            // Enum
            HStack(alignment: .top, spacing: 0) {
                ForEach(monitor.convertedEnumHolders, id: \.self) { holder in
                    EnumView(holder: holder)
                        .padding(.init(top: 300, leading: 300, bottom: 300, trailing: 300))
                }
            } // HStack
            
        } // VStack
    } // var body
} // struct DiagramView
