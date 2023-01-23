//
//  ConvertedNestable.swift
//  RUISS
//
//  Created by オナガ・ハルキ on 2023/01/24.
//

import Foundation

protocol ConvertedNestable {
    var nestingConvertedToStringStructHolders: [ConvertedToStringStructHolder] { get set }
    var nestingConvertedToStringClassHolders: [ConvertedToStringClassHolder] { get set }
    var nestingConvertedToStringEnumHolders: [ConvertedToStringEnumHolder] { get set }
}
