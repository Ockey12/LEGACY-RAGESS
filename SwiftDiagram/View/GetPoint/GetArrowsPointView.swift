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
                    var affecteder = affectedType.affectedTypeName
                    if let numOfExtension = affectedType.numberOfExtension {
                        // extension内で宣言されている要素のとき
                        affecteder += ".\(numOfExtension)"
                    }
                    affecteder += ".\(affectedType.componentKind)"
                    affecteder += ".\(affectedType.numberOfComponent)"
                    
                    // Pointインスタンスに、影響を与える側と影響を受ける側の名前だけを登録する
                    let point = ArrowPoint.Point(affecter: affectingTypeName, affecteder: affecteder)
                    
                    arrowPoint.points.append(point)
                } // for affectedType in dependence.affectedTypes
            } // for dependence in dependences
            
            // debug
            print("============ GetArrowsPointView.onChange =============")
            for point in arrowPoint.points {
                print("affecter: " + point.affecter)
                print("affecteder: " + point.affecteder)
                print("-------------------------")
            }
        } // onAppear
    } // var body
} // struct GetArrowsPointView

struct GetArrowsPointView_Previews: PreviewProvider {
    static var previews: some View {
        GetArrowsPointView()
    }
}