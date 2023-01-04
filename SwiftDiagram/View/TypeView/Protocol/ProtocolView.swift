//
//  ProtocolView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/18.
//

import SwiftUI

struct ProtocolView: View {
    let holder: ConvertedToStringProtocolHolder
    
    @EnvironmentObject var monitor: BuildFileMonitor
    @EnvironmentObject var arrowPoint: ArrowPoint
    @EnvironmentObject var maxWidthHolder: MaxWidthHolder
    @EnvironmentObject var redrawCounter: RedrawCounter
    
    let borderWidth = ComponentSettingValues.borderWidth
    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    let textTrailPadding = ComponentSettingValues.textTrailPadding
    let headerItemHeight = ComponentSettingValues.headerItemHeight
    let connectionHeight = ComponentSettingValues.connectionHeight
    let itemHeight = ComponentSettingValues.itemHeight
    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    let extensionOutsidePadding = ComponentSettingValues.extensionOutsidePadding
    
    let extensionHeightCalculater = ExtensionFrameHeightCalculater()
    
    var allStrings: [String] {
        let allStringOfHolder = AllStringOfHolder()
        return allStringOfHolder.ofProtocol(holder)
    } // var allStrings
    
    var maxTextWidth: Double {
        let calculator = MaxTextWidthCalculator()
        var width = calculator.getMaxWidth(allStrings)
        if width < ComponentSettingValues.minWidth {
            width = ComponentSettingValues.minWidth
        }
        if redrawCounter.getCount() < (monitor.numerOfAllType() + arrowPoint.numberOfDependence())*10 {
            DispatchQueue.main.async {
                if let _ = maxWidthHolder.maxWidthDict[holder.name] {
                    maxWidthHolder.maxWidthDict[holder.name]!.maxWidth = width
                } else {
                    maxWidthHolder.maxWidthDict[holder.name] = MaxWidthHolder.Value(maxWidth: width)
                }
                let dt = Date()
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
                arrowPoint.changeDate = "\(dateFormatter.string(from: dt))"
                redrawCounter.increment()
            }
        }
        
        return width
    }
    
    var bodyWidth: Double {
        return maxTextWidth + textTrailPadding
    }
    
    var frameWidth: Double {
        return bodyWidth + arrowTerminalWidth*2 + 4
    }
    
    var body: some View {
        ZStack {
            // changeDateを更新するとき、ZStack全体が更新される
            Text(holder.changeDate)
                .font(.system(size: 50))
                .foregroundColor(.clear)
                .background(.clear)
//                .onChange(of: monitor.getChangeDate()) { newValue in
//                    DispatchQueue.main.async {
//                        if let _ = maxWidthHolder.maxWidthDict[holder.name] {
//                            maxWidthHolder.maxWidthDict[holder.name]!.maxWidth = maxTextWidth
//                        } else {
//                            maxWidthHolder.maxWidthDict[holder.name] = MaxWidthHolder.Value(maxWidth: maxTextWidth)
//                        }
//                        let dt = Date()
//                        let dateFormatter: DateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
//                        arrowPoint.changeDate = "\(dateFormatter.string(from: dt))"
//                    }
//                }

            VStack(spacing: 0) {
                // Header
                HeaderComponentView(accessLevelIcon: holder.accessLevelIcon,
                                    indexType: .protocol,
                                    nameOfType: holder.name,
                                    bodyWidth: bodyWidth)
                .offset(x: 0, y: 2)
                .frame(width: frameWidth ,
                       height: headerItemHeight)
                
                // DetailComponent
                ProtocolDetailView(holder: holder,
                                 bodyWidth: bodyWidth,
                                 frameWidth: frameWidth)
                
                // extension
                ForEach(0..<holder.extensions.count, id: \.self) { index in
                    let extensionHolder = holder.extensions[index]
                    let height = extensionHeightCalculater.calculateExtensionFrameHeight(holder: extensionHolder)
                    ExtensionView(superHolderName: holder.name, numberOfExtension: index, holder: extensionHolder, outsideFrameWidth: maxTextWidth)
                        .frame(width: bodyWidth + extensionOutsidePadding*2,
                               height: height)
                }
            } // VStack
        } // ZStack
    } // var body
} // struct ProtocolView
