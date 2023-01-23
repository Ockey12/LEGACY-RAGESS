//
//  ConvertedExtensionable.swift
//  RUISS
//
//  Created by オナガ・ハルキ on 2023/01/24.
//

import Foundation

protocol ConvertedExtensionable {
    var extensions: [ConvertedToStringExtensionHolder] { get set }
}
