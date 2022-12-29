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
    let extensionOutsidePadding = ComponentSettingValues.extensionOutsidePadding
    
    var body: some View {
        ZStack {
            Text("")
                .onChange(of: arrowPoint.changeDate) { _ in
                    DispatchQueue.main.async {
                        arrowPoint.initialize()
                        for protocolHolder in monitor.getProtocol() {
                            var currentPoint = arrowPoint.getCurrent()
                            if 0 < protocolHolder.extensions.count {
                                // extensionが宣言されているので、extensionコンポーネントの幅を考慮する
                                currentPoint.x += extensionOutsidePadding - arrowTerminalWidth
                            }
                            for (index, point) in arrowPoint.points.enumerated() {
                                if point.affecter == protocolHolder.name {
                                    // TODO<extensionも考慮>
//                                    var currentPoint = arrowPoint.getCurrent()
//                                    if 0 < protocolHolder.extensions.count {
//                                        // extensionが宣言されているので、extensionコンポーネントの幅を考慮する
//                                        currentPoint.x += extensionOutsidePadding
//                                    }
                                    guard let width = maxWidthHolder.maxWidthDict[protocolHolder.name] else {
                                        continue
                                    }
    //                                let width = maxWidthHolder.maxWidthDict[protocolHolder.name]!
                                    let startRightX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2
                                    arrowPoint.points[index].startLeft = currentPoint
                                    arrowPoint.points[index].startRight = CGPoint(x: startRightX, y: currentPoint.y)
                                    print("startRightX: \(startRightX)")
                                }
                            }
                            
                            if let maxWidth = maxWidthHolder.maxWidthDict[protocolHolder.name] {
                                var newCurrentX = currentPoint.x + maxWidth + textTrailPadding + arrowTerminalWidth*2 + 300 + 300 + 4
                                if 0 < protocolHolder.extensions.count {
                                    newCurrentX += extensionOutsidePadding - arrowTerminalWidth - 4
                                }
                                arrowPoint.setCurrentX(newCurrentX)
                            }
                        } // for protocolHolder in monitor.getProtocol()
//                        monitor.objectWillChange.send()
//                        arrowPoint.changeDate = monitor.getChangeDate()
                        print("<DEBUG>GetProtocolPointView")
//                        arrowPoint.refreshFlag.toggle()
                    } // DispatchQueue.main.async
                } // .onChange(of: monitor.getChangeDate())
        } // ZStack
    } // var body
} // struct GetProtocolPointView
