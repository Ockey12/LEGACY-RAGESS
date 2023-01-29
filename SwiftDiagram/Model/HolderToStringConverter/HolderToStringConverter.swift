//
//  HolderToStringConverter.swift
//  RUISS
//
//  Created by オナガ・ハルキ on 2023/01/29.
//

import Foundation

protocol HolderToStringConverter {
    associatedtype BeforeConvertedHolder
    associatedtype AfterConbertedHolder
    
    func convertToString(holder: BeforeConvertedHolder) -> AfterConbertedHolder
}
