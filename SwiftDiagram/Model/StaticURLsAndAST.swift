//
//  StaticURLsAndAST.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/08.
//

import Foundation

class StaticURLsAndAST {
    static let instance = StaticURLsAndAST()
    var buildFileURL: URL = FileManager.default.temporaryDirectory
    var projectDirectoryURL: URL = FileManager.default.temporaryDirectory
//    var swiftFilesURL = [URL]()
    var parsedContent = ""
    var counter = 1
}
