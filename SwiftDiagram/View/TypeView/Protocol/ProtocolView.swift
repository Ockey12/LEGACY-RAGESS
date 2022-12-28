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
        let allStringOfHolder = AllStringOfHolder()
        return allStringOfHolder.ofProtocol(holder)
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
                                    indexType: .protocol,
                                    nameOfType: holder.name,
                                    bodyWidth: bodyWidth)
                .offset(x: 0, y: 2)
                .frame(width: frameWidth ,
                       height: headerItemHeight)
//                .onAppear {
//                    for dependence in monitor.dependenceHolders {
//                        // 依存関係
//                        if dependence.affectingTypeName == holder.name {
//                            // この型が影響を与える側の依存関係
//                            for affectedType in dependence.affectedTypes {
//                                // 影響を受ける型とその要素の情報
//                                
//                                // 検索用の辞書のKey
//                                var key = ""
//                                if let numOfExtension = affectedType.numberOfExtension {
//                                    // extensionで宣言されているとき
//                                    // 影響を受ける側の型の何番目のextensionかを区別する番号をKeyに含める
//                                    key = holder.name + "->" + affectedType.affectedTypeName + "\(affectedType.affectedTypeKind)" + "\(numOfExtension)" + "-" + "\(affectedType.numberOfComponent)"
//                                } else {
//                                    key = holder.name + "->" + affectedType.affectedTypeName + "\(affectedType.affectedTypeKind)" + "\(affectedType.numberOfComponent)"
//                                }
//                                
//                                // 現在のx座標とy座標
//                                let x = arrowPoint.currentX
//                                let y = arrowPoint.currentY
//                                
//                                // 座標を登録する
//                                if let _ = arrowPoint.points[key] {
//                                    // 影響を受ける側の型を描画するときに既に登録されているとき
//                                    // 始点の座標を追加する
//                                    arrowPoint.points[key]!.start = CGPoint(x: x, y: y)
//                                } else {
//                                    // まだ登録されていないとき
//                                    // 始点の座標を登録する
//                                    arrowPoint.points[key] = ArrowPoint.Point(start: CGPoint(x: x, y: y))
//                                }
//                            } // for affectedType in dependence.affectedTypes
//                        } // if dependence.affectingTypeName == holder.name
//                    } // for dependence in monitor.dependenceHolders
//                } // onAppear
                
                // DetailComponent
                ProtocolDetailView(holder: holder,
                                 bodyWidth: bodyWidth,
                                 frameWidth: frameWidth)
                
                // extension
                ForEach(holder.extensions, id: \.self) { extensionHolder in
                    let height = extensionHeightCalculater.calculateExtensionFrameHeight(holder: extensionHolder)
                    ExtensionView(superHolderName: holder.name, holder: extensionHolder, outsideFrameWidth: maxTextWidth)
                        .frame(width: bodyWidth + extensionOutsidePadding*2,
                               height: height)
                }
            } // VStack
        } // ZStack
    } // var body
} // struct ProtocolView

//struct ProtocolView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProtocolView()
//    }
//}
