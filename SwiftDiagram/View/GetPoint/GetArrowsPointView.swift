//
//  GetArrowsPointView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/28.
//

import SwiftUI

struct GetArrowsPointView: View {
    @EnvironmentObject var monitor: BuildFileMonitor
    @EnvironmentObject var arrowPoint: ArrowPoint
    
    var body: some View {
        ZStack {
            GetProtocolPointView()
            GetStructPointView()
        }
        .onChange(of: monitor.getChangeDate()) { _ in
            // 座標を保持している配列を空にする
            arrowPoint.points.removeAll()
            
            // 依存関係を取得する
            let dependences = monitor.getDependence()
            for dependence in dependences {
                // 影響を与える側の名前
                let affectingTypeName = dependence.affectingTypeName
                
                for affectedType in dependence.affectedTypes {
                    // 影響を受ける側の名前
                    let affecteder = affectedType.affectedTypeName
                    let componentKind = affectedType.componentKind
                    let numOfComponent = affectedType.numberOfComponent
                    
                    // Pointインスタンスに、影響を与える側と影響を受ける側の名前だけを登録する
                    var point = ArrowPoint.Point(affecterName: affectingTypeName,
                                                 affectedName: affecteder,
                                                 affectedComponentKind: componentKind,
                                                 numberOfAffectedComponent: numOfComponent)
                    if let numOfExtension = affectedType.numberOfExtension {
                        // extension内で宣言されている要素のとき
                        point.numberOfAffectedExtension = numOfExtension
                    }
                    arrowPoint.points.append(point)
                } // for affectedType in dependence.affectedTypes
            } // for dependence in dependences
            
            // debug
            print("============ GetArrowsPointView.onChange =============")
            for point in arrowPoint.points {
                print("affecter: " + point.affecterName)
                print("affecteder: " + point.affectedName)
                print("-------------------------")
            }
        } // onAppear
    } // var body
} // struct GetArrowsPointView

//struct GetArrowsPointView_Previews: PreviewProvider {
//    static var previews: some View {
//        GetArrowsPointView()
//    }
//}
