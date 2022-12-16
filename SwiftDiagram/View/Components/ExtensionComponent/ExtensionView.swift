//
//  ExtensionView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/16.
//

import SwiftUI

struct ExtensionView: View {
    let holder: ConvertedToStringExtensionHolder
    let outsideFrameWidth: CGFloat

    @State private var maxTextWidth = ComponentSettingValues.minWidth
    
    let borderWidth = ComponentSettingValues.borderWidth
    let arrowTerminalWidth = ComponentSettingValues.arrowTerminalWidth
    let textTrailPadding = ComponentSettingValues.textTrailPadding
    
    let headerItemHeight = ComponentSettingValues.headerItemHeight
    
    let connectionHeight = ComponentSettingValues.connectionHeight
    let itemHeight = ComponentSettingValues.itemHeight
    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    
    let extensionOutsidePadding = ComponentSettingValues.extensionOutsidePadding
    let extensionTopPadding = ComponentSettingValues.extensionTopPadding
    let extensionBottomPadding = ComponentSettingValues.extensionBottomPadding
    
    let nestTopPaddingWithConnectionHeight = ComponentSettingValues.nestTopPaddingWithConnectionHeight
    let nestBottomPadding = ComponentSettingValues.nestBottomPadding
    
    let fontSize = ComponentSettingValues.fontSize
    
    var allStrings: [String] {
        var strings = holder.conformingProtocolNames
        strings += holder.typealiases
        strings += holder.initializers
        strings += holder.variables
        strings += holder.functions
        
        let nestedStructs = holder.nestingConvertedToStringStructHolders
        for nestedStruct in nestedStructs {
            strings += nestedStruct.generics
            strings += nestedStruct.conformingProtocolNames
            strings += nestedStruct.typealiases
            strings += nestedStruct.initializers
            strings += nestedStruct.variables
            strings += nestedStruct.functions
        }
        
        let nestedClasses = holder.nestingConvertedToStringClassHolders
        for nestedClass in nestedClasses {
            strings += nestedClass.generics
            if let superClass = nestedClass.superClassName {
                strings.append(superClass)
            }
            strings += nestedClass.conformingProtocolNames
            strings += nestedClass.typealiases
            strings += nestedClass.initializers
            strings += nestedClass.variables
            strings += nestedClass.functions
        }
        
        let nestedEnums = holder.nestingConvertedToStringEnumHolders
        for nestedEnum in nestedEnums {
            strings += nestedEnum.generics
            if let rawvalueType = nestedEnum.rawvalueType {
                strings.append(rawvalueType)
            }
            strings += nestedEnum.conformingProtocolNames
            strings += nestedEnum.typealiases
            strings += nestedEnum.initializers
            strings += nestedEnum.cases
            strings += nestedEnum.variables
            strings += nestedEnum.functions
        }
        
        return strings
    }
    
    var bodyWidth: Double {
        return maxTextWidth + textTrailPadding
    }
    
    var frameWidth: Double {
        return bodyWidth + arrowTerminalWidth*2 + CGFloat(4)
    }
    
    var outsideWidth: Double {
        return outsideFrameWidth + textTrailPadding
    }
    
    var body: some View {
        ZStack {
            GetTextsMaxWidthView(strings: allStrings, maxWidth: $maxTextWidth)
            
            ExtensionFrame(holder: holder, bodyWidth: outsideWidth)
                .stroke(lineWidth: ComponentSettingValues.borderWidth)
                .fill(.black)
                .frame(width: outsideWidth + extensionOutsidePadding*2 + CGFloat(4), height: calculateFrameHeight())
//                .background(.pink)
            
            Text("Extension")
                .lineLimit(1)
                .font(.system(size: fontSize))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .position(x: outsideWidth/2 + extensionOutsidePadding, y: connectionHeight/2)
            
            VStack(spacing: 0) {
                // conform
                if 0 < holder.conformingProtocolNames.count {
                    DetailComponentView(componentType: .conform,
                                        strings: holder.conformingProtocolNames,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.conformingProtocolNames.count))
                }

                // typealiases
                if 0 < holder.typealiases.count {
                    DetailComponentView(componentType: .typealias,
                                        strings: holder.typealiases,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.typealiases.count))
                }

                // initializer
                if 0 < holder.initializers.count {
                    DetailComponentView(componentType: .initializer,
                                        strings: holder.initializers,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.initializers.count))
                }

                // property
                if 0 < holder.variables.count {
                    DetailComponentView(componentType: .property,
                                        strings: holder.variables,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.variables.count))
                }

                // method
                if 0 < holder.functions.count {
                    DetailComponentView(componentType: .method,
                                        strings: holder.functions,
                                        bodyWidth: bodyWidth)
                    .frame(width: frameWidth,
                           height: calculateDetailComponentFrameHeight(numberOfItems: holder.functions.count))
//                    .background(.green)
                }
                
                // nested Struct
                ForEach(holder.nestingConvertedToStringStructHolders, id: \.self) { nestedStruct in
//                    NestStructView(holder: nestedStruct, maxTextWidth: maxTextWidth)
                    NestStructView(holder: nestedStruct, outsideFrameWidth: maxTextWidth)
                        .frame(width: frameWidth)
//                        .background(.gray)
                }
                
                // nested Class
                ForEach(holder.nestingConvertedToStringClassHolders, id: \.self) { nestedClass in
//                    NestStructView(holder: nestedStruct, maxTextWidth: maxTextWidth)
                    NestClassView(holder: nestedClass, outsideFrameWidth: maxTextWidth)
                        .frame(width: frameWidth)
                }
                
                // nested Enum
                ForEach(holder.nestingConvertedToStringEnumHolders, id: \.self) { nestedEnum in
//                    NestStructView(holder: nestedStruct, maxTextWidth: maxTextWidth)
                    NestEnumView(holder: nestedEnum, outsideFrameWidth: maxTextWidth)
                        .frame(width: frameWidth)
                }
            } // VStack
//            .background(.cyan)
            .offset(y: connectionHeight)
            
        } // ZStack
    } // var body
    
    private func calculateFrameHeight() -> CGFloat {
        var height: CGFloat = extensionTopPadding
        
        // conform
        if 0 < holder.conformingProtocolNames.count {
            height += connectionHeight
            height += itemHeight*CGFloat(holder.conformingProtocolNames.count)
            height += bottomPaddingForLastText
        }
        
        // typealiases
        if 0 < holder.typealiases.count {
            height += connectionHeight
            height += itemHeight*CGFloat(holder.typealiases.count)
            height += bottomPaddingForLastText
        }
        
        // initializers
        if 0 < holder.initializers.count {
            height += connectionHeight
            height += itemHeight*CGFloat(holder.initializers.count)
            height += bottomPaddingForLastText
        }
        
        // property
        if 0 < holder.variables.count {
            height += connectionHeight
            height += itemHeight*CGFloat(holder.variables.count)
            height += bottomPaddingForLastText
        }
        
        // method
        if 0 < holder.functions.count {
            height += connectionHeight
            height += itemHeight*CGFloat(holder.functions.count)
            height += bottomPaddingForLastText
        }
        
        let nestedStructs = holder.nestingConvertedToStringStructHolders
        for nestedStruct in nestedStructs {
            height += headerItemHeight + nestTopPaddingWithConnectionHeight
            if 0 < nestedStruct.generics.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedStruct.generics.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedStruct.conformingProtocolNames.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedStruct.conformingProtocolNames.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedStruct.typealiases.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedStruct.typealiases.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedStruct.initializers.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedStruct.initializers.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedStruct.variables.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedStruct.variables.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedStruct.functions.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedStruct.functions.count)
                height += bottomPaddingForLastText
            }
            height += nestBottomPadding
        } // for nestedStruct in nestedStructs
        
//        height += extensionBottomPadding
        
        return height
    } // func calculateFrameHeight() -> CGFloat
    
    private func calculateDetailComponentFrameHeight(numberOfItems: Int) -> CGFloat {
        var height = connectionHeight
        height += itemHeight*CGFloat(numberOfItems)
        height += bottomPaddingForLastText
        return height
    } // func calculateDetailComponentFrameHeight(numberOfItems: Int) -> CGFloat
}

//struct ExtensionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExtensionView()
//    }
//}
