//
//  DiagramViewScaler.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/19.
//

import Foundation

class DiagramViewScaler: ObservableObject {
    @Published var viewSize: CGSize = CGSize(width: 1000, height: 1000)
    var didGetInitialViewSizeFlag = false {
        didSet {
            print("viewSize.width: \(viewSize.width)")
            print("viewSize.height: \(viewSize.height)")
        }
    }
    
    func scaleViewSize(_ scale: CGFloat) {
        let newViewSize = CGSize(width: self.viewSize.width*scale,
                                 height: self.viewSize.height*scale)
        
        self.viewSize = newViewSize
    }
}
