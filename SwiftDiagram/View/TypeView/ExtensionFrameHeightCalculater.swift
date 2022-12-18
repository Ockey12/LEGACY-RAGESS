//
//  ExtensionFrameHeightCalculater.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/19.
//

import Foundation

struct ExtensionFrameHeightCalculater {
    let headerItemHeight = ComponentSettingValues.headerItemHeight
    let connectionHeight = ComponentSettingValues.connectionHeight
    let itemHeight = ComponentSettingValues.itemHeight
    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    let extensionTopPadding = ComponentSettingValues.extensionTopPadding
    let nestTopPaddingWithConnectionHeight = ComponentSettingValues.nestTopPaddingWithConnectionHeight
    let nestBottomPadding = ComponentSettingValues.nestBottomPadding
    
    func calculateExtensionFrameHeight(holder: ConvertedToStringExtensionHolder) -> CGFloat {

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
        
        let nestedClasses = holder.nestingConvertedToStringClassHolders
        for nestedClass in nestedClasses {
            height += headerItemHeight + nestTopPaddingWithConnectionHeight
            if 0 < nestedClass.generics.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedClass.generics.count)
                height += bottomPaddingForLastText
            }
            if let _ = nestedClass.superClassName {
                height += connectionHeight
                height += itemHeight
                height += bottomPaddingForLastText
            }
            if 0 < nestedClass.conformingProtocolNames.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedClass.conformingProtocolNames.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedClass.typealiases.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedClass.typealiases.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedClass.initializers.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedClass.initializers.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedClass.variables.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedClass.variables.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedClass.functions.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedClass.functions.count)
                height += bottomPaddingForLastText
            }
            height += nestBottomPadding
        } // for nestedClass in nestedClasses
        
        let nestedEnums = holder.nestingConvertedToStringEnumHolders
        for nestedEnum in nestedEnums {
            height += headerItemHeight + nestTopPaddingWithConnectionHeight
            if 0 < nestedEnum.generics.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedEnum.generics.count)
                height += bottomPaddingForLastText
            }
            if let _ = nestedEnum.rawvalueType {
                height += connectionHeight
                height += itemHeight
                height += bottomPaddingForLastText
            }
            if 0 < nestedEnum.conformingProtocolNames.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedEnum.conformingProtocolNames.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedEnum.typealiases.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedEnum.typealiases.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedEnum.initializers.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedEnum.initializers.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedEnum.cases.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedEnum.cases.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedEnum.variables.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedEnum.variables.count)
                height += bottomPaddingForLastText
            }
            if 0 < nestedEnum.functions.count {
                height += connectionHeight
                height += itemHeight*CGFloat(nestedEnum.functions.count)
                height += bottomPaddingForLastText
            }
            height += nestBottomPadding
        } // for nestedEnum in nestedEnums
        
        return height
    } // func calculateExtensionFrameHeight() -> CGFloat
}
