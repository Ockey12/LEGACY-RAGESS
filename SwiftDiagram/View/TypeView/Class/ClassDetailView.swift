//
//  ClassDetailView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/18.
//

import SwiftUI

struct ClassDetailView: View {
    let holder: ConvertedToStringClassHolder
    let bodyWidth: CGFloat
    let frameWidth: CGFloat
    
    let connectionHeight = ComponentSettingValues.connectionHeight
    let itemHeight = ComponentSettingValues.itemHeight
    let bottomPaddingForLastText = ComponentSettingValues.bottomPaddingForLastText
    
    var body: some View {
        VStack(spacing: 0) {
            // generic
            if 0 < holder.generics.count {
                DetailComponentView(componentType: .generic,
                                    strings: holder.generics,
                                    bodyWidth: bodyWidth)
                .frame(width: frameWidth,
                       height: calculateDetailComponentFrameHeight(numberOfItems: holder.generics.count))
            } // if 0 < holder.generics.count
            
            // super Class
            if let superClass = holder.superClassName {
                DetailComponentView(componentType: .superClass,
                                    strings: [superClass],
                                    bodyWidth: bodyWidth)
                .frame(width: frameWidth,
                       height: calculateDetailComponentFrameHeight(numberOfItems: 1))
            }
            
            // conform
            if 0 < holder.conformingProtocolNames.count {
                DetailComponentView(componentType: .conform,
                                    strings: holder.conformingProtocolNames,
                                    bodyWidth: bodyWidth)
                .frame(width: frameWidth,
                       height: calculateDetailComponentFrameHeight(numberOfItems: holder.conformingProtocolNames.count))
            } // if 0 < holder.conformingProtocolNames.count
            
            // typealiases
            if 0 < holder.typealiases.count {
                DetailComponentView(componentType: .typealias,
                                    strings: holder.typealiases,
                                    bodyWidth: bodyWidth)
                .frame(width: frameWidth,
                       height: calculateDetailComponentFrameHeight(numberOfItems: holder.typealiases.count))
            } // if 0 < holder.typealiases.count
            
            // property
            if 0 < holder.variables.count {
                DetailComponentView(componentType: .property,
                                    strings: holder.variables,
                                    bodyWidth: bodyWidth)
                .frame(width: frameWidth,
                       height: calculateDetailComponentFrameHeight(numberOfItems: holder.variables.count))
            } // if 0 < holder.variables.count
            
            // initializer
            if 0 < holder.initializers.count {
                DetailComponentView(componentType: .initializer,
                                    strings: holder.initializers,
                                    bodyWidth: bodyWidth)
                .frame(width: frameWidth,
                       height: calculateDetailComponentFrameHeight(numberOfItems: holder.initializers.count))
            } // if 0 < holder.initializers.count
            
            // method
            if 0 < holder.functions.count {
                DetailComponentView(componentType: .method,
                                    strings: holder.functions,
                                    bodyWidth: bodyWidth)
                .frame(width: frameWidth,
                       height: calculateDetailComponentFrameHeight(numberOfItems: holder.functions.count))
            } // if 0 < holder.functions.count
        } // VStack
    } // var body
    
    private func calculateDetailComponentFrameHeight(numberOfItems: Int) -> CGFloat {
        var height = connectionHeight
        height += itemHeight*CGFloat(numberOfItems)
        height += bottomPaddingForLastText
        return height
    } // func calculateDetailComponentFrameHeight(numberOfItems: Int) -> CGFloat
} // struct ClassDetailView

//struct ClassDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassDetailView()
//    }
//}
