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
    @EnvironmentObject var maxWidthHolder: MaxWidthHolder
    
    @State private var maxWidth: Double = ComponentSettingValues.minWidth
    private let allStringOfHolder = AllStringOfHolder()
    
    let textTrailPadding = ComponentSettingValues.textTrailPadding
    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    
    var body: some View {
        ZStack {
            Text("")
                .onChange(of: monitor.getChangeDate()) { _ in
                    DispatchQueue.main.async {
                        arrowPoint.initialize()
                        for protocolHolder in monitor.getProtocol() {
                            for (index, point) in arrowPoint.points.enumerated() {
                                if point.affecter == protocolHolder.name {
                                    // TODO<extensionも考慮>
                                    var currentPoint = arrowPoint.getCurrent()
                                    guard let width = maxWidthHolder.maxWidthDict[protocolHolder.name] else {
                                        continue
                                    }
    //                                let width = maxWidthHolder.maxWidthDict[protocolHolder.name]!
                                    let startRightX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2
                                    arrowPoint.points[index].startLeft = currentPoint
                                    arrowPoint.points[index].startRight = CGPoint(x: startRightX, y: currentPoint.y)
                                }
                            }
                            
                            if let maxWidth = maxWidthHolder.maxWidthDict[protocolHolder.name] {
                                let newCurrentX = arrowPoint.getCurrent().x + maxWidth + textTrailPadding + arrowTerminalWidth*2 + 300 + 300
                                arrowPoint.setCurrentX(newCurrentX)
                            }
    //                        let newCurrentX = arrowPoint.getCurrent().x + maxWidthHolder.maxWidthDict[protocolHolder.name]! + textTrailPadding + arrowTerminalWidth + 300 + 300
    //                        arrowPoint.setCurrentX(newCurrentX)
                        } // for protocolHolder in monitor.getProtocol()
                        print("a")
                    } // DispatchQueue.main.async
                } // .onChange(of: monitor.getChangeDate())
//                .onChange(of: maxWidth) { _ in
//                    arrowPoint.initialize()
//                    print("b")
//                }
//            ZStack {
//                ForEach(monitor.getProtocol(), id: \.self) { protocolHolder in
//                    let allString = allStringOfHolder.ofProtocol(protocolHolder)
//                    Text("")
//                        .onAppear {
//                            print("c")
//                        }
//                    GetTextsMaxWidthView(holderName: protocolHolder.name, strings: allString, maxWidth: $maxWidth)
//                        .onAppear {
//                            maxWidth = ComponentSettingValues.minWidth
//                            print("d")
//                        }
//                } // ForEach(monitor.getProtocol(), id: \.self)
//            } // ZStack
        } // ZStack
    } // var body
} // struct GetProtocolPointView
