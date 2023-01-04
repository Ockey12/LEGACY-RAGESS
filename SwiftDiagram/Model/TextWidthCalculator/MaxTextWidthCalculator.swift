//
//  MaxTextWidthCalculator.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2023/01/04.
//

import Foundation

struct MaxTextWidthCalculator {
    func getMaxWidth(_ strings: [String]) -> Double {
        var maxWidth: Double = 0
        let characterWidth = CharacterWidth()
        
        for string in strings {
            var width: Double = 0
            for char in string {
                width += characterWidth.getWidth(char)
            }
            if maxWidth < width {
                maxWidth = width
            }
        } // for string in strings
        return maxWidth
    } // func getMaxWidth(_ strings: [String]) -> Double
} // struct MaxTextWidthCalculator
