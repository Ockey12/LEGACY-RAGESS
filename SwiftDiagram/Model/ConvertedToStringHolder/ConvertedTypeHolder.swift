//
//  ConvertedTypeHolder.swift
//  RUISS
//
//  Created by オナガ・ハルキ on 2023/01/24.
//

import Foundation

protocol ConvertedTypeHolder: ConvertedToStringHolder {
    var conformingProtocolNames: [String] { get set }
    var typealiases: [String] { get set }
    var initializers: [String] { get set }
    var variables: [String] { get set }
    var functions: [String] { get set }
}
