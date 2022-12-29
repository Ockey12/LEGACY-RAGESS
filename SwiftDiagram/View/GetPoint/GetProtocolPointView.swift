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
    let connectionHeight = ComponentSettingValues.connectionHeight
    let itemHeight = ComponentSettingValues.itemHeight
    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    
    var body: some View {
        ZStack {
            Text("")
                .onChange(of: arrowPoint.changeDate) { _ in
                    DispatchQueue.main.async {
                        arrowPoint.initialize()
                        for protocolHolder in monitor.getProtocol() {
                            var currentPoint = arrowPoint.getStartPoint()
                            guard let width = maxWidthHolder.maxWidthDict[protocolHolder.name] else {
                                continue
                            }
                            if 0 < protocolHolder.extensions.count {
                                // extensionが宣言されているので、extensionコンポーネントの幅を考慮する
                                currentPoint.x += extensionOutsidePadding - arrowTerminalWidth
                            }
                            
                            // MARK: - Header Component
                            for (index, point) in arrowPoint.points.enumerated() {
                                if point.affecterName == protocolHolder.name {
                                    // このプロトコルが影響を与える側のとき
                                    let startRightX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2
                                    arrowPoint.points[index].startLeft = currentPoint
                                    arrowPoint.points[index].startRight = CGPoint(x: startRightX, y: currentPoint.y)
                                    print("startRightX: \(startRightX)")
                                }
                            } // for (index, point) in arrowPoint.points.enumerated()
                            currentPoint.y += itemHeight/2
                            currentPoint.y += bottomPaddingForLastText
                            currentPoint.y += connectionHeight
                            
                            // MARK: - Conform Component
                            if 0 < protocolHolder.conformingProtocolNames.count {
                                currentPoint.y += itemHeight/2
                            }
                            for num in 0..<protocolHolder.conformingProtocolNames.count {
                                for (index, point) in arrowPoint.points.enumerated() {
                                    if (point.affectedName == protocolHolder.name) &&
                                        (point.affectedComponentKind == .conform) &&
                                        (point.numberOfAffectedComponent == num) {
                                        let startRightX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2
                                        arrowPoint.points[index].endLeft = currentPoint
                                        arrowPoint.points[index].endRight = CGPoint(x: startRightX, y: currentPoint.y)
                                    }
                                } // for (index, point) in arrowPoint.points.enumerated()
                                if num != protocolHolder.conformingProtocolNames.count - 1 {
                                    currentPoint.y += itemHeight
                                }
                            } // for protocolName in protocolHolder
                            if 0 < protocolHolder.conformingProtocolNames.count {
                                currentPoint.y += itemHeight/2
                                currentPoint.y += bottomPaddingForLastText
                                currentPoint.y += connectionHeight
                            }
                            
                            // MARK: - AssociatedType Component
                            // associatedtypeは新しく名前を宣言するだけで、他の型に依存しない
                            if 0 < protocolHolder.associatedTypes.count {
                                currentPoint.y += itemHeight/2
                            }
                            for num in 0..<protocolHolder.associatedTypes.count {
                                if num != protocolHolder.associatedTypes.count - 1 {
                                    currentPoint.y += itemHeight
                                }
                            }
                            if 0 < protocolHolder.associatedTypes.count {
                                currentPoint.y += itemHeight/2
                                currentPoint.y += bottomPaddingForLastText
                                currentPoint.y += connectionHeight
                            }
                            
                            // MARK: - Typealias Component
                            if 0 < protocolHolder.typealiases.count {
                                currentPoint.y += itemHeight/2
                            }
                            for num in 0..<protocolHolder.typealiases.count {
                                for (index, point) in arrowPoint.points.enumerated() {
                                    if (point.affectedName == protocolHolder.name) &&
                                        (point.affectedComponentKind == .typealias) &&
                                        (point.numberOfAffectedComponent == num) {
                                        let startRightX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2
                                        arrowPoint.points[index].endLeft = currentPoint
                                        arrowPoint.points[index].endRight = CGPoint(x: startRightX, y: currentPoint.y)
                                    }
                                } // for (index, point) in arrowPoint.points.enumerated()
                                if num != protocolHolder.typealiases.count - 1 {
                                    currentPoint.y += itemHeight
                                }
                            } // for num in 0..<protocolHolder.typealiases.count
                            if 0 < protocolHolder.typealiases.count {
                                currentPoint.y += itemHeight/2
                                currentPoint.y += bottomPaddingForLastText
                                currentPoint.y += connectionHeight
                            }
                            
                            // MARK: - Initializer Component
                            if 0 < protocolHolder.initializers.count {
                                currentPoint.y += itemHeight/2
                            }
                            for num in 0..<protocolHolder.initializers.count {
                                for (index, point) in arrowPoint.points.enumerated() {
                                    if (point.affectedName == protocolHolder.name) &&
                                        (point.affectedComponentKind == .initializer) &&
                                        (point.numberOfAffectedComponent == num) {
                                        let startRightX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2
                                        arrowPoint.points[index].endLeft = currentPoint
                                        arrowPoint.points[index].endRight = CGPoint(x: startRightX, y: currentPoint.y)
                                    }
                                } // for (index, point) in arrowPoint.points.enumerated()
                                if num != protocolHolder.initializers.count - 1 {
                                    currentPoint.y += itemHeight
                                }
                            } // for num in 0..<protocolHolder.initializers.count
                            if 0 < protocolHolder.initializers.count {
                                currentPoint.y += itemHeight/2
                                currentPoint.y += bottomPaddingForLastText
                                currentPoint.y += connectionHeight
                            }
                            
                            // MARK: - Property Component
                            if 0 < protocolHolder.variables.count {
                                currentPoint.y += itemHeight/2
                            }
                            for num in 0..<protocolHolder.variables.count {
                                for (index, point) in arrowPoint.points.enumerated() {
                                    if (point.affectedName == protocolHolder.name) &&
                                        (point.affectedComponentKind == .property) &&
                                        (point.numberOfAffectedComponent == num) {
                                        let startRightX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2
                                        arrowPoint.points[index].endLeft = currentPoint
                                        arrowPoint.points[index].endRight = CGPoint(x: startRightX, y: currentPoint.y)
                                    }
                                } // for (index, point) in arrowPoint.points.enumerated()
                                if num != protocolHolder.variables.count - 1 {
                                    currentPoint.y += itemHeight
                                }
                            } // for num in 0..<protocolHolder.variables.count
                            if 0 < protocolHolder.variables.count {
                                currentPoint.y += itemHeight/2
                                currentPoint.y += bottomPaddingForLastText
                                currentPoint.y += connectionHeight
                            }
                            
                            // MARK: - Method Component
                            if 0 < protocolHolder.functions.count {
                                currentPoint.y += itemHeight/2
                            }
                            for num in 0..<protocolHolder.functions.count {
                                for (index, point) in arrowPoint.points.enumerated() {
                                    if (point.affectedName == protocolHolder.name) &&
                                        (point.affectedComponentKind == .method) &&
                                        (point.numberOfAffectedComponent == num) {
                                        let startRightX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2
                                        arrowPoint.points[index].endLeft = currentPoint
                                        arrowPoint.points[index].endRight = CGPoint(x: startRightX, y: currentPoint.y)
                                    }
                                } // for (index, point) in arrowPoint.points.enumerated()
                                if num != protocolHolder.functions.count - 1 {
                                    currentPoint.y += itemHeight
                                }
                            } // for num in 0..<protocolHolder.variables.count
                            if 0 < protocolHolder.functions.count {
                                currentPoint.y += itemHeight/2
                                currentPoint.y += bottomPaddingForLastText
                                currentPoint.y += connectionHeight
                            }
                            
                            if let maxWidth = maxWidthHolder.maxWidthDict[protocolHolder.name] {
                                var newCurrentX = currentPoint.x + maxWidth + textTrailPadding + arrowTerminalWidth*2 + 300 + 300 + 4
                                if 0 < protocolHolder.extensions.count {
                                    newCurrentX += extensionOutsidePadding - arrowTerminalWidth - 4
                                }
                                arrowPoint.setStartX(newCurrentX)
                            }
                        } // for protocolHolder in monitor.getProtocol()
                    } // DispatchQueue.main.async
                } // .onChange(of: monitor.getChangeDate())
        } // ZStack
    } // var body
} // struct GetProtocolPointView
