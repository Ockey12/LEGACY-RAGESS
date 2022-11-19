//
//  TokenVisitorPrinter.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/11/19.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxParser

struct TokenVisitorPrinter {
//    let url = URL(filePath: "/Users/onaga/Research/SwiftDiagram/SwiftDiagram/Sample/SampleCode.swift")
    var url: URL
    
    // TokenVisitor.resultArrayをprintする
    func printResultArray() {
//        print(url)
//        let fileContent = getFileContents(contentsOf: url)
        let parsedContent = try! SyntaxParser.parse(url)
        let visitor = TokenVisitor()
        _ = visitor.visit(parsedContent)
        print("-----TokenVisitor.resultArray-----")
        for text in visitor.getResultArray() {
            print(text)
        }
        print("----------------------------------\n")
    }
    
    // TokenVisitor.syntaxNodeTypeStackをprintする
//    func printSyntaxNodeTypeStack() {
//        let parsedContent = try! SyntaxParser.parse(url)
//        let visitor = TokenVisitor()
//        _ = visitor.visit(parsedContent)
//        print("-----TokenVisitor.syntaxNodeTypeStack-----")
//        for text in visitor.getSyntaxNodeTypeStack() {
//            print(text)
//        }
//        print("")
//    }
    
    // 指定されたURLにあるファイル内のソースコードを返す
//    private func getFileContents(contentsOf url: URL) -> String {
//        do {
//            _ = try String(contentsOf: url)
//        } catch {
//            print(error)
//        }
//
//        guard let fileContent = try? String(contentsOf: url) else {
//            fatalError("ERROR: failed to load contents (TokenVisitorPrinter)")
//        }
//        return fileContent
//    }
}
