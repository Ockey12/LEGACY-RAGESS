////
////  GetStructPointView.swift
////  SwiftDiagram
////
////  Created by オナガ・ハルキ on 2022/12/30.
////
//
//import SwiftUI
//
//struct GetStructPointView: View {
//    @EnvironmentObject var monitor: BuildFileMonitor
//    @EnvironmentObject var arrowPoint: ArrowPoint
//    @EnvironmentObject var maxWidthHolder: MaxWidthHolder
//    
//    @State private var maxWidth: Double = ComponentSettingValues.minWidth
//    private let allStringOfHolder = AllStringOfHolder()
//    
//    let textTrailPadding = ComponentSettingValues.textTrailPadding
//    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
//    let extensionOutsidePadding = ComponentSettingValues.extensionOutsidePadding
//    let connectionHeight = ComponentSettingValues.connectionHeight
//    let itemHeight = ComponentSettingValues.itemHeight
//    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
//    
//    var body: some View {
//        ZStack {
//            Text("")
//                .onChange(of: arrowPoint.changeDate) { _ in
//                    DispatchQueue.main.async {
//                        arrowPoint.moveToDownerHStack()
//                        for structHolder in monitor.getStruct() {
//                            var currentPoint = arrowPoint.getStartPoint()
//                            guard let width = maxWidthHolder.maxWidthDict[structHolder.name]?.maxWidth else {
//                                continue
//                            }
//                            if 0 < structHolder.extensions.count {
//                                // extensionが宣言されているので、extensionコンポーネントの幅を考慮する
//                                currentPoint.x += extensionOutsidePadding - arrowTerminalWidth
//                            }
//                            
//                            // MARK: - Header Component
//                            for (index, point) in arrowPoint.points.enumerated() {
//                                if point.affecterName == structHolder.name {
//                                    // このStructが影響を与える側のとき
//                                    let startRightX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2
//                                    arrowPoint.points[index].startLeft = currentPoint
//                                    arrowPoint.points[index].startRight = CGPoint(x: startRightX, y: currentPoint.y)
////                                    print("startRightX: \(startRightX)")
//                                }
//                            } // for (index, point) in arrowPoint.points.enumerated()
//                            currentPoint.y += itemHeight/2
//                            currentPoint.y += bottomPaddingForLastText
//                            currentPoint.y += connectionHeight
//                            
//                            var newCurrentX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2 + 300 + 300 + 4
//                            if 0 < structHolder.extensions.count {
//                                newCurrentX += extensionOutsidePadding - arrowTerminalWidth - 4
//                            }
//                            arrowPoint.setStartX(newCurrentX)
//                        }
//                    } // DispatchQueue.main.async
//                } // .onChange(of: monitor.getChangeDate())
//        } // ZStack
//    } // var body
//}
