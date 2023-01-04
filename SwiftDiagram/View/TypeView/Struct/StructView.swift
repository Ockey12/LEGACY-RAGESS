//
//  StructView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/15.
//

import SwiftUI

struct StructView: View {
    
    let holder: ConvertedToStringStructHolder
    
    @EnvironmentObject var arrowPoint: ArrowPoint
    
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
        return allStringOfHolder.ofStruct(holder)
    } // var allStrings
    
    var maxTextWidth: Double {
        let calculator = MaxTextWidthCalculator()
        let width = calculator.getMaxWidth(allStrings)
        if ComponentSettingValues.minWidth < width {
            return width
        } else {
            return ComponentSettingValues.minWidth
        }
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

            VStack(spacing: 0) {
                // Header
                HeaderComponentView(accessLevelIcon: holder.accessLevelIcon,
                                    indexType: .struct,
                                    nameOfType: holder.name,
                                    bodyWidth: bodyWidth)
                .offset(x: 0, y: 2)
                .frame(width: frameWidth ,
                       height: headerItemHeight)
                
                // DetailComponent
                StructDetailView(holder: holder,
                                 bodyWidth: bodyWidth,
                                 frameWidth: frameWidth)
                
                // nested Struct
                ForEach(holder.nestingConvertedToStringStructHolders, id: \.self) { nestedStruct in
                    NestStructView(holder: nestedStruct, outsideFrameWidth: maxTextWidth)
                        .frame(width: frameWidth)
                }
                
                // nested Class
                ForEach(holder.nestingConvertedToStringClassHolders, id: \.self) { nestedClass in
                    NestClassView(holder: nestedClass, outsideFrameWidth: maxTextWidth)
                        .frame(width: frameWidth)
                }
                
                // nested Enum
                ForEach(holder.nestingConvertedToStringEnumHolders, id: \.self) { nestedEnum in
                    NestEnumView(holder: nestedEnum, outsideFrameWidth: maxTextWidth)
                        .frame(width: frameWidth)
                }
                
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
} // struct StructView
