//
//  URLsAndAST.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/08.
//

import Foundation

class URLsAndAST: ObservableObject {
    @Published var buildFileURL: URL = FileManager.default.temporaryDirectory
    @Published var projectDirectoryURL: URL = FileManager.default.temporaryDirectory
    @Published var swiftFilesURL = [URL]()
    @Published var parsedContent = ""
    @Published var counter = 1
}
