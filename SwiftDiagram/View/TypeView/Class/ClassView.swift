//
//  ClassView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/18.
//

import SwiftUI

struct ClassView: View {
    let holder: ConvertedToStringClassHolder
    @State private var maxTextWidth = ComponentSettingValues.minWidth
    
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
        var strings = [holder.name]
        strings += holder.generics
        if let superClass = holder.superClassName {
            strings.append(superClass)
        }
        strings += holder.conformingProtocolNames
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
        
        let extensions = holder.extensions
        for extensionHolder in extensions {
            strings += extensionHolder.conformingProtocolNames
            strings += extensionHolder.typealiases
            strings += extensionHolder.initializers
            strings += extensionHolder.variables
            strings += extensionHolder.functions

            let nestedStructs = extensionHolder.nestingConvertedToStringStructHolders
            for nestedStruct in nestedStructs {
                strings += nestedStruct.generics
                strings += nestedStruct.conformingProtocolNames
                strings += nestedStruct.typealiases
                strings += nestedStruct.initializers
                strings += nestedStruct.variables
                strings += nestedStruct.functions
            }

            let nestedClasses = extensionHolder.nestingConvertedToStringClassHolders
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

            let nestedEnums = extensionHolder.nestingConvertedToStringEnumHolders
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
        } // for extensionHolder in extensions
        
        return strings
    } // var allStrings
    
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

            GetTextsMaxWidthView(holderName: holder.name, strings: allStrings, maxWidth: $maxTextWidth)
            
            VStack(spacing: 0) {
                // Header
                HeaderComponentView(accessLevelIcon: holder.accessLevelIcon,
                                    indexType: .class,
                                    nameOfType: holder.name,
                                    bodyWidth: bodyWidth)
                .offset(x: 0, y: 2)
                .frame(width: frameWidth ,
                       height: headerItemHeight)
                
                // DetailComponent
                ClassDetailView(holder: holder,
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
//                ForEach(holder.extensions, id: \.self) { extensionHolder in
//                    let height = extensionHeightCalculater.calculateExtensionFrameHeight(holder: extensionHolder)
//                    ExtensionView(superHolderName: holder.name, holder: extensionHolder, outsideFrameWidth: maxTextWidth)
//                        .frame(width: bodyWidth + extensionOutsidePadding*2,
//                               height: height)
//                }
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
} // struct ClassView

//struct ClassView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassView()
//    }
//}
