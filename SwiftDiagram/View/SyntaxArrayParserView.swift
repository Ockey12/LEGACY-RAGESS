//
//  SyntaxArrayParserView.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/06.
//

import SwiftUI
import SwiftSyntax
import SwiftSyntaxParser

struct SyntaxArrayParserView: View {
    @State private var importerPresented = false
    @State private var sourceCode: String = ""
    @State private var leftContent: String = ""
    @State private var rightContent: String = ""
    
    @State private var url: URL?
    @State private var numberOfIndent = 1
    private let indentSpace = "  "
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("TokenVisitor.resultArray")
                    Divider()
                    CodeScrollView(displayedText: $leftContent)
                }
                Divider()
                VStack {
                    Text("SyntaxArrayParser")
                    Divider()
                    CodeScrollView(displayedText: $rightContent)
                }
            }
            Divider()
            Button {
                importerPresented = true
            } label: {
                Text("Open")
            }
            .padding()
        }// VStack
        .frame(minWidth: 1200, maxWidth: .infinity, minHeight: 700, maxHeight: .infinity)
        // 指定したSwiftファイル内のソースコードをcode変数に格納する
        .fileImporter(isPresented: $importerPresented, allowedContentTypes: [.swiftSource]) { result in
            switch result {
            // urlは指定したファイルのURL
            case .success(let url):
                print("URL: \(url)")
                self.url = url
                // URL先のファイルからソースコードを取得する
                guard let fileContent = try? String(contentsOf: url) else {
                    fatalError("failed to load contents")
                }
                sourceCode = fileContent
                
                // leftContent
                let parsedContent = try! SyntaxParser.parse(url)
                let visitor = TokenVisitor()
                _ = visitor.visit(parsedContent)

                for text in visitor.getResultArray() {
                    if text.hasPrefix("End") {
                        numberOfIndent -= 1
                    }
                    
                    let space = Array(repeating: indentSpace, count: numberOfIndent).joined(separator: "|")
                    leftContent += space + text + "\n"
                    
                    if text.hasPrefix("Start") {
                        numberOfIndent += 1
                    }
                }
                
                // rightContent
                var syntaxArrayParser = SyntaxArrayParser()
                syntaxArrayParser.parseResultArray(resultArray: visitor.getResultArray())
                for structHolder in syntaxArrayParser.getResultStructHolders() {
                    rightContent += "Struct\n"
//                    rightContent += "ID: \(structHolder.ID!)"
                    rightContent += "name: \(structHolder.name)\n"
                    rightContent += "accessLevel: \(structHolder.accessLevel)\n"
                    
                    if 0 < structHolder.conformingProtocolNames.count {
                        for name in structHolder.conformingProtocolNames {
                            rightContent += "conformingProtocolName: \(name)\n"
                        }
                    }
                }
            case .failure:
                print("failure")
            }
        }// .fileImporter
    }
}

struct SyntaxArrayParserView_Previews: PreviewProvider {
    static var previews: some View {
        SyntaxArrayParserView()
    }
}