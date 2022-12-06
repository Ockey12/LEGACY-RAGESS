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
                    
                    for variableHolder in structHolder.variables {
                        rightContent += "Variable\n"
                        rightContent += "name: \(variableHolder.name)\n"
                        rightContent += "accessLevel: \(variableHolder.accessLevel)\n"
                        rightContent += "kind: \(variableHolder.kind)\n"
                        if let customAttribute = variableHolder.customAttribute {
                            rightContent += "customAttribute: \(customAttribute)\n"
                        }
                        if variableHolder.isStatic {
                            rightContent += "isStatic\n"
                        }
                        if variableHolder.isLazy {
                            rightContent += "isLazy\n"
                        }
                        if variableHolder.isConstant {
                            rightContent += "isConstant\n"
                        }
                        if let literalType = variableHolder.literalType {
                            rightContent += "literalType: \(literalType)\n"
                        }
                        if let arrayType = variableHolder.arrayType {
                            rightContent += "arrayType: \(arrayType)\n"
                        }
                        if let key = variableHolder.dictionaryKeyType {
                            rightContent += "dictionaryKeyType: \(key)\n"
                        }
                        if let value = variableHolder.dictionaryValueType {
                            rightContent += "dictionaryValueType: \(value)\n"
                        }
                        if 0 < variableHolder.tupleTypes.count {
                            for element in variableHolder.tupleTypes {
                                rightContent += "tupleType: \(element)\n"
                            }
                        }
                        if let conformedProtocolByOpaqueResultType = variableHolder.conformedProtocolByOpaqueResultType {
                            rightContent += "conformedProtocolByOpaqueResultType: \(conformedProtocolByOpaqueResultType)\n"
                        }
                        if variableHolder.isOptionalType {
                            rightContent += "isOptional\n"
                        }
                        if let initialValue = variableHolder.initialValue {
                            rightContent += "initialValue: \(initialValue)\n"
                        }
                        if variableHolder.haveWillSet {
                            rightContent += "haveWillSet\n"
                        }
                        if variableHolder.haveDidSet {
                            rightContent += "haveDidSet\n"
                        }
                        if variableHolder.haveGetter {
                            rightContent += "haveGetter\n"
                        }
                        if variableHolder.haveSetter {
                            rightContent += "haveSetter\n"
                        }
                    }
                    
                    rightContent += "\n"
                }
                
                rightContent += "===== Dependencies =====\n"
                for element in syntaxArrayParser.getWhomThisTypeAffectArray() {
                    let affectingTypeName = element.affectingTypeName
                    for affectedTypeName in element.affectedTypesName {
                        rightContent += "\(affectingTypeName) -> \(affectedTypeName)\n"
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
