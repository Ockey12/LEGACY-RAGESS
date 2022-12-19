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
    
    var body: some View {
        VStack(alignment: .leading) {
            // Protocol
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    ForEach(monitor.convertedProtocolHolders, id: \.self) { holder in
                        ProtocolView(holder: holder)
                            .padding()
                    }
                } // HStack
                Rectangle()
                    .frame(height: connectionHeight)
                    .foregroundColor(.clear)
            } // VStack
            
            // Struct
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    ForEach(monitor.convertedStructHolders, id: \.self) { holder in
                        StructView(holder: holder)
                            .padding()
                    }
                } // HStack
                Rectangle()
                    .frame(height: connectionHeight)
                    .foregroundColor(.clear)
            } // VStack
            
            // Class
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    ForEach(monitor.convertedClassHolders, id: \.self) { holder in
                        ClassView(holder: holder)
                            .padding()
                    }
                } // HStack
                Rectangle()
                    .frame(height: connectionHeight)
                    .foregroundColor(.clear)
            } // VStack
            
            // Enum
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    ForEach(monitor.convertedEnumHolders, id: \.self) { holder in
                        EnumView(holder: holder)
                            .padding()
                    }
                } // HStack
                Rectangle()
                    .frame(height: connectionHeight)
                    .foregroundColor(.clear)
            } // VStack
            
        } // VStack
    }
}

//struct DiagramView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiagramView()
//    }
//}
