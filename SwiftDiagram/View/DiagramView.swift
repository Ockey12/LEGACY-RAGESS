//
//  DiagramView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/19.
//

import SwiftUI

struct DiagramView: View {
    @EnvironmentObject var monitor: BuildFileMonitor
    
    let connectionHeight = ComponentSettingValues.connectionHeight
    
    @State var x: CGFloat = 0
    @State var y: CGFloat = 0
    
    @State var circlePositions = [CirclePosition]()
    
    struct CirclePosition: Hashable {
        var x: CGFloat
        var y: CGFloat
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Protocol
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    ForEach(monitor.convertedProtocolHolders, id: \.self) { holder in
                        ProtocolView(holder: holder)
//                            .padding()
                    }
                } // HStack
                Rectangle()
                    .frame(height: connectionHeight)
                    .foregroundColor(.clear)
//                    .foregroundColor(.pink)
            } // VStack
            
            // Struct
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    ForEach(monitor.convertedStructHolders, id: \.self) { holder in
                        StructView(holder: holder)
                            .padding()
//                            .background() {
//                                GeometryReader { geometry in
//                                    Path { path in
//                                        DispatchQueue.main.async {
//                                            if holder.name == "SomeStruct" {
//                                                x = geometry.frame(in: .global).origin.x
//                                                y = geometry.frame(in: .global).origin.y
//                                                print("[x: \(x), y: \(y)]")
//                                            }
////                                            x = geometry.frame(in: .global).origin.x
////                                            y = geometry.frame(in: .global).origin.y
////                                            let circlePosition = CirclePosition(x: x, y: y)
////                                            circlePositions.append(circlePosition)
//                                        }
//                                    }
//                                }
//                            }
//                        Circle()
//                            .foregroundColor(.red)
//                            .frame(width: 30, height: 30)
//                            .position(x: x, y: y)
//                            .padding()
                    }
//                    ForEach(circlePositions, id: \.self) { position in
//                        Circle()
//                            .foregroundColor(.red)
//                            .frame(width: 30, height: 30)
//                            .position(x: position.x, y: position.y)
//                    }
                } // HStack
//                .background(.cyan)
                Rectangle()
                    .frame(height: connectionHeight)
                    .foregroundColor(.clear)
//                    .foregroundColor(.pink)
            } // VStack
//            .background(.green)
            
//            // ClassとEnumはStructより少ない傾向があると考えられるのでHStackでまとめる
//            HStack(alignment: .top) {
//
//            } // HStack
            
            // Class
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    ForEach(monitor.convertedClassHolders, id: \.self) { holder in
                        ClassView(holder: holder)
//                                .padding()
                    }
                } // HStack
                Rectangle()
                    .frame(height: connectionHeight)
                    .foregroundColor(.clear)
            } // VStack

            // Enum
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    ForEach(monitor.convertedEnumHolders, id: \.self) { holder in
                        EnumView(holder: holder)
//                                .padding()
                    }
                } // HStack
                Rectangle()
                    .frame(height: connectionHeight)
                    .foregroundColor(.clear)
            } // VStack
            
//            ForEach(circlePositions, id: \.self) { position in
//                Circle()
//                    .foregroundColor(.red)
//                    .frame(width: 30, height: 30)
//                    .position(x: position.x, y: position.y)
//            }
        } // VStack
    } // var body
} // struct DiagramView

//struct DiagramView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiagramView()
//    }
//}
