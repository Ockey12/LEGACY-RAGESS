//
//  GetProtocolPointView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/28.
//

import SwiftUI

struct GetProtocolPointView: View {
    @EnvironmentObject var monitor: BuildFileMonitor
    @EnvironmentObject var arrowPoint: ArrowPoint
    @State private var maxWidth: Double = ComponentSettingValues.minWidth
    private let allStringOfHolder = AllStringOfHolder()
    
    var body: some View {
        ZStack {
            Text("")
                .onChange(of: monitor.getChangeDate()) { _ in
                    arrowPoint.initialize()
                    print("a")
                }
                .onChange(of: maxWidth) { _ in
                    arrowPoint.initialize()
                    print("b")
                }
            ZStack {
                ForEach(monitor.getProtocol(), id: \.self) { protocolHolder in
                    let allString = allStringOfHolder.ofProtocol(protocolHolder)
                    Text("")
                        .onAppear {
                            print("c")
                        }
                    GetTextsMaxWidthView(holderName: protocolHolder.name, strings: allString, maxWidth: $maxWidth)
                        .onAppear {
                            maxWidth = ComponentSettingValues.minWidth
                            print("d")
                        }
                    
                } // ForEach(monitor.getProtocol(), id: \.self)
            } // ZStack
        } // ZStack
    } // var body
} // struct GetProtocolPointView
