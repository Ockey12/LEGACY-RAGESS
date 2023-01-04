////
////  TokenVisitorPrinter.swift
////  SwiftDiagram
////
////  Created by オナガ・ハルキ on 2022/11/19.
////
//
//import Foundation
//import SwiftUI
//import SwiftSyntax
//import SwiftSyntaxParser
//
//// TokenVisitorクラスのresultArrayの要素を表示するView
//struct TokenVisitorView: View {
//    @State private var importerPresented = false
//    @State private var sourceCode: String = ""
//    @State private var rightContent: String = ""
//    
//    @State private var url: URL?
////    let printer = TokenVisitorPrinter()
//    @State private var numberOfIndent = 1
//    private let indentSpace = "  "
//    
//    var body: some View {
//        VStack {
//            HStack {
//                CodeScrollView(displayedText: $sourceCode)
//                
//                CodeScrollView(displayedText: $rightContent)
//            }
//            
//            Button {
//                importerPresented = true
//            } label: {
//                Text("Open")
//            }
//            .padding()
//            
//            Button {
//                if let url = url {
//                    let printer = TokenVisitorPrinter(url: url)
//                    printer.printResultArray()
//                }
//            } label: {
//                Text("TokenVisitorPrinter.printResultArray")
//            }
//            
//        }// VStack
//        .frame(minWidth: 1200, maxWidth: .infinity, minHeight: 700, maxHeight: .infinity)
//        // 指定したSwiftファイル内のソースコードをcode変数に格納する
//        .fileImporter(isPresented: $importerPresented, allowedContentTypes: [.swiftSource]) { result in
//            switch result {
//            // urlは指定したファイルのURL
//            case .success(let url):
//                print("URL: \(url)")
//                self.url = url
//                // URL先のファイルからソースコードを取得する
//                guard let fileContent = try? String(contentsOf: url) else {
//                    fatalError("failed to load contents")
//                }
//                sourceCode = fileContent
//                
//                let parsedContent = try! SyntaxParser.parse(url)
//                let visitor = TokenVisitor()
//                _ = visitor.visit(parsedContent)
//
////                print("---TokenVisitorView")
//                for text in visitor.getResultArray() {
////                    print(text)
//                    if text.hasPrefix("End") {
//                        numberOfIndent -= 1
//                    }
//                    
//                    let space = Array(repeating: indentSpace, count: numberOfIndent).joined(separator: "|")
//                    rightContent += space + text + "\n"
//                    
//                    if text.hasPrefix("Start") {
//                        numberOfIndent += 1
//                    }
//                }
//            case .failure:
//                print("failure")
//            }
//        }// .fileImporter
//    }
//}
//
//struct TokenVisitorView_Previews: PreviewProvider {
//    static var previews: some View {
//        TokenVisitorView()
//    }
//}
