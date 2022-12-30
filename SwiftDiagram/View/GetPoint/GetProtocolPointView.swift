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
                            guard let width = maxWidthHolder.maxWidthDict[protocolHolder.name]?.maxWidth else {
                                continue
                            }
                            let name = protocolHolder.name
                            var currentPoint = arrowPoint.getStartPoint()
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
                            
                            // Conform Component
                            getPointOfComponent(holderName: name,
                                                elementNames: protocolHolder.conformingProtocolNames,
                                                componentKind: .conform,
                                                currentPoint: &currentPoint)
                            
                            // Associated Type Component
                            getPointOfAssociatedType(numberOfAssociatedType: protocolHolder.associatedTypes.count,
                                                     currentPoint: &currentPoint)

                            // Typealias Component
                            getPointOfComponent(holderName: name,
                                                elementNames: protocolHolder.typealiases,
                                                componentKind: .typealias,
                                                currentPoint: &currentPoint)
                            
                            // Initializer Component
                            getPointOfComponent(holderName: name,
                                                elementNames: protocolHolder.initializers,
                                                componentKind: .initializer,
                                                currentPoint: &currentPoint)
                            
                            // Property Component
                            getPointOfComponent(holderName: name,
                                                elementNames: protocolHolder.variables,
                                                componentKind: .property,
                                                currentPoint: &currentPoint)
                            
                            // Method Component
                            getPointOfComponent(holderName: name,
                                                elementNames: protocolHolder.functions,
                                                componentKind: .method,
                                                currentPoint: &currentPoint)
                            
                            // MARK: - Extension Component
//                            if 0 < protocolHolder.extensions.count {
//                                currentPoint.y += itemHeight/2
//                            }
                            for numOfExtension in 0..<protocolHolder.extensions.count {
                                guard let extensionWidth = maxWidthHolder.maxWidthDict[protocolHolder.name]?.extensionWidth[numOfExtension] else {
                                    continue
                                }
                                let extensionX = currentPoint.x + (width - extensionWidth)/2
                                let extensionHolder = protocolHolder.extensions[numOfExtension]
                                currentPoint.y += connectionHeight*2
                                
                                // Typealias Component
                                if 0 < extensionHolder.typealiases.count {
                                    currentPoint.y += itemHeight/2
                                }
                                for num in 0..<extensionHolder.typealiases.count {
                                    for (index, point) in arrowPoint.points.enumerated() {
                                        if (point.affectedName == protocolHolder.name) &&
                                            (point.numberOfAffectedExtension == numOfExtension) &&
                                            (point.affectedComponentKind == .typealias) &&
                                            (point.numberOfAffectedComponent == num) {
                                            let startRightX = extensionX + extensionWidth + textTrailPadding + arrowTerminalWidth*2
                                            arrowPoint.points[index].endLeft = CGPoint(x: extensionX, y: currentPoint.y)
                                            arrowPoint.points[index].endRight = CGPoint(x: startRightX, y: currentPoint.y)
                                        }
                                    } // for (index, point) in arrowPoint.points.enumerated()
                                    if num != extensionHolder.typealiases.count - 1 {
                                        currentPoint.y += itemHeight
                                    }
                                } // for num in 0..<protocolHolder.typealiases.count
                                if 0 < extensionHolder.typealiases.count {
                                    currentPoint.y += itemHeight/2
                                    currentPoint.y += bottomPaddingForLastText
                                    currentPoint.y += connectionHeight
                                }
                                
                                // Initializer Component
                                if 0 < extensionHolder.initializers.count {
                                    currentPoint.y += itemHeight/2
                                }
                                for num in 0..<extensionHolder.initializers.count {
                                    for (index, point) in arrowPoint.points.enumerated() {
                                        if (point.affectedName == protocolHolder.name) &&
                                            (point.numberOfAffectedExtension == numOfExtension) &&
                                            (point.affectedComponentKind == .initializer) &&
                                            (point.numberOfAffectedComponent == num) {
                                            let startRightX = extensionX + extensionWidth + textTrailPadding + arrowTerminalWidth*2
                                            arrowPoint.points[index].endLeft = CGPoint(x: extensionX, y: currentPoint.y)
                                            arrowPoint.points[index].endRight = CGPoint(x: startRightX, y: currentPoint.y)
                                        }
                                    } // for (index, point) in arrowPoint.points.enumerated()
                                    if num != extensionHolder.initializers.count - 1 {
                                        currentPoint.y += itemHeight
                                    }
                                } // for num in 0..<protocolHolder.typealiases.count
                                if 0 < extensionHolder.initializers.count {
                                    currentPoint.y += itemHeight/2
                                    currentPoint.y += bottomPaddingForLastText
                                    currentPoint.y += connectionHeight
                                }
                                
                                // Property Component
                                if 0 < extensionHolder.variables.count {
                                    currentPoint.y += itemHeight/2
                                }
                                for num in 0..<extensionHolder.variables.count {
                                    for (index, point) in arrowPoint.points.enumerated() {
                                        if (point.affectedName == protocolHolder.name) &&
                                            (point.numberOfAffectedExtension == numOfExtension) &&
                                            (point.affectedComponentKind == .property) &&
                                            (point.numberOfAffectedComponent == num) {
                                            let startRightX = extensionX + extensionWidth + textTrailPadding + arrowTerminalWidth*2
                                            arrowPoint.points[index].endLeft = CGPoint(x: extensionX, y: currentPoint.y)
                                            arrowPoint.points[index].endRight = CGPoint(x: startRightX, y: currentPoint.y)
                                        }
                                    } // for (index, point) in arrowPoint.points.enumerated()
                                    if num != extensionHolder.variables.count - 1 {
                                        currentPoint.y += itemHeight
                                    }
                                } // for num in 0..<protocolHolder.typealiases.count
                                if 0 < extensionHolder.variables.count {
                                    currentPoint.y += itemHeight/2
                                    currentPoint.y += bottomPaddingForLastText
                                    currentPoint.y += connectionHeight
                                }
                                
                                // Method Component
                                if 0 < extensionHolder.functions.count {
                                    currentPoint.y += itemHeight/2
                                }
                                for num in 0..<extensionHolder.functions.count {
                                    for (index, point) in arrowPoint.points.enumerated() {
                                        if (point.affectedName == protocolHolder.name) &&
                                            (point.numberOfAffectedExtension == numOfExtension) &&
                                            (point.affectedComponentKind == .method) &&
                                            (point.numberOfAffectedComponent == num) {
                                            let startRightX = extensionX + extensionWidth + textTrailPadding + arrowTerminalWidth*2
                                            arrowPoint.points[index].endLeft = CGPoint(x: extensionX, y: currentPoint.y)
                                            arrowPoint.points[index].endRight = CGPoint(x: startRightX, y: currentPoint.y)
                                        }
                                    } // for (index, point) in arrowPoint.points.enumerated()
                                    if num != extensionHolder.functions.count - 1 {
                                        currentPoint.y += itemHeight
                                    }
                                } // for num in 0..<protocolHolder.typealiases.count
                                if 0 < extensionHolder.functions.count {
                                    currentPoint.y += itemHeight/2
                                    currentPoint.y += bottomPaddingForLastText
                                    currentPoint.y += connectionHeight
                                }
                                
                            } // for num in 0..<protocolHolder.extensions.count
                            if 0 < protocolHolder.extensions.count {
                                currentPoint.y += itemHeight/2
                                currentPoint.y += bottomPaddingForLastText
                                currentPoint.y += connectionHeight
                            }
                            
                            var newCurrentX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2 + 300 + 300 + 4
                            if 0 < protocolHolder.extensions.count {
                                newCurrentX += extensionOutsidePadding - arrowTerminalWidth - 4
                            }
                            arrowPoint.setStartX(newCurrentX)
                            
                            if arrowPoint.maxY < currentPoint.y {
                                arrowPoint.maxY = currentPoint.y
                            }
                        } // for protocolHolder in monitor.getProtocol()
                    } // DispatchQueue.main.async
                } // .onChange(of: monitor.getChangeDate())
        } // ZStack
    } // var body
    
    private func getPointOfComponent(holderName: String, elementNames: [String], componentKind: DetailComponentView.ComponentKind, currentPoint: inout CGPoint) {
        guard let width = maxWidthHolder.maxWidthDict[holderName]?.maxWidth else {
            return
        }
        if 0 < elementNames.count {
            currentPoint.y += itemHeight/2
        }
        for num in 0..<elementNames.count {
            for (index, point) in arrowPoint.points.enumerated() {
                if (point.affectedName == holderName) &&
                    (point.affectedComponentKind == componentKind) &&
                    (point.numberOfAffectedComponent == num) {
                    let startRightX = currentPoint.x + width + textTrailPadding + arrowTerminalWidth*2
                    arrowPoint.points[index].endLeft = currentPoint
                    arrowPoint.points[index].endRight = CGPoint(x: startRightX, y: currentPoint.y)
                }
            } // for (index, point) in arrowPoint.points.enumerated()
            if num != elementNames.count - 1 {
                currentPoint.y += itemHeight
            }
        } // for num in 0..<elementNames.count
        if 0 < elementNames.count {
            currentPoint.y += itemHeight/2
            currentPoint.y += bottomPaddingForLastText
            currentPoint.y += connectionHeight
        }
    } // func getPointOfComponent(holderName: String, elementNames: [String], componentKind: DetailComponentView.ComponentKind, currentPoint: inout CGPoint)
    
    private func getPointOfAssociatedType(numberOfAssociatedType: Int, currentPoint: inout CGPoint) {
        // associatedtypeは新しく名前を宣言するだけで、他の型に依存しない
        if 0 < numberOfAssociatedType {
            currentPoint.y += itemHeight/2
        }
        for num in 0..<numberOfAssociatedType {
            if num != numberOfAssociatedType - 1 {
                currentPoint.y += itemHeight
            }
        }
        if 0 < numberOfAssociatedType {
            currentPoint.y += itemHeight/2
            currentPoint.y += bottomPaddingForLastText
            currentPoint.y += connectionHeight
        }
    } // func getPointOfAssociatedType(numberOfAssociatedType: Int, currentPoint: inout CGPoint)
} // struct GetProtocolPointView
