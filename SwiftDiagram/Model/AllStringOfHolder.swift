//
//  AllStringOfHolder.swift
//  SwiftDiagram
//
//  Created by オナガ・ハルキ on 2022/12/28.
//

import Foundation

struct AllStringOfHolder {
    func ofProtocol(_ holder: ConvertedToStringProtocolHolder) -> [String] {
        var strings = [holder.name]
        strings += holder.conformingProtocolNames
        strings += holder.associatedTypes
        strings += holder.typealiases
        strings += holder.initializers
        strings += holder.variables
        strings += holder.functions
        
        let extensions = holder.extensions
        for extensionHolder in extensions {
            strings += extensionHolder.conformingProtocolNames
            strings += extensionHolder.typealiases
            strings += extensionHolder.initializers
            strings += extensionHolder.variables
            strings += extensionHolder.functions

            let nestedStructs = extensionHolder.nestingConvertedToStringStructHolders
            for nestedStruct in nestedStructs {
                strings += nestedStruct.generics
                strings += nestedStruct.conformingProtocolNames
                strings += nestedStruct.typealiases
                strings += nestedStruct.initializers
                strings += nestedStruct.variables
                strings += nestedStruct.functions
            }

            let nestedClasses = extensionHolder.nestingConvertedToStringClassHolders
            for nestedClass in nestedClasses {
                strings += nestedClass.generics
                if let superClass = nestedClass.superClassName {
                    strings.append(superClass)
                }
                strings += nestedClass.conformingProtocolNames
                strings += nestedClass.typealiases
                strings += nestedClass.initializers
                strings += nestedClass.variables
                strings += nestedClass.functions
            }

            let nestedEnums = extensionHolder.nestingConvertedToStringEnumHolders
            for nestedEnum in nestedEnums {
                strings += nestedEnum.generics
                if let rawvalueType = nestedEnum.rawvalueType {
                    strings.append(rawvalueType)
                }
                strings += nestedEnum.conformingProtocolNames
                strings += nestedEnum.typealiases
                strings += nestedEnum.initializers
                strings += nestedEnum.cases
                strings += nestedEnum.variables
                strings += nestedEnum.functions
            }
        } // for extensionHolder in extensions
        
        return strings
    } // func ofProtocol(_ holder: ConvertedToStringProtocolHolder) -> [String]
    
    func ofStruct(_ holder: ConvertedToStringStructHolder) -> [String] {
        var strings = [holder.name]
        strings += holder.generics
        strings += holder.conformingProtocolNames
        strings += holder.typealiases
        strings += holder.initializers
        strings += holder.variables
        strings += holder.functions
        
        let nestedStructs = holder.nestingConvertedToStringStructHolders
        for nestedStruct in nestedStructs {
            strings += nestedStruct.generics
            strings += nestedStruct.conformingProtocolNames
            strings += nestedStruct.typealiases
            strings += nestedStruct.initializers
            strings += nestedStruct.variables
            strings += nestedStruct.functions
        }
        
        let nestedClasses = holder.nestingConvertedToStringClassHolders
        for nestedClass in nestedClasses {
            strings += nestedClass.generics
            if let superClass = nestedClass.superClassName {
                strings.append(superClass)
            }
            strings += nestedClass.conformingProtocolNames
            strings += nestedClass.typealiases
            strings += nestedClass.initializers
            strings += nestedClass.variables
            strings += nestedClass.functions
        }
        
        let nestedEnums = holder.nestingConvertedToStringEnumHolders
        for nestedEnum in nestedEnums {
            strings += nestedEnum.generics
            if let rawvalueType = nestedEnum.rawvalueType {
                strings.append(rawvalueType)
            }
            strings += nestedEnum.conformingProtocolNames
            strings += nestedEnum.typealiases
            strings += nestedEnum.initializers
            strings += nestedEnum.cases
            strings += nestedEnum.variables
            strings += nestedEnum.functions
        }
        
        let extensions = holder.extensions
        for extensionHolder in extensions {
            strings += extensionHolder.conformingProtocolNames
            strings += extensionHolder.typealiases
            strings += extensionHolder.initializers
            strings += extensionHolder.variables
            strings += extensionHolder.functions

            let nestedStructs = extensionHolder.nestingConvertedToStringStructHolders
            for nestedStruct in nestedStructs {
                strings += nestedStruct.generics
                strings += nestedStruct.conformingProtocolNames
                strings += nestedStruct.typealiases
                strings += nestedStruct.initializers
                strings += nestedStruct.variables
                strings += nestedStruct.functions
            }

            let nestedClasses = extensionHolder.nestingConvertedToStringClassHolders
            for nestedClass in nestedClasses {
                strings += nestedClass.generics
                if let superClass = nestedClass.superClassName {
                    strings.append(superClass)
                }
                strings += nestedClass.conformingProtocolNames
                strings += nestedClass.typealiases
                strings += nestedClass.initializers
                strings += nestedClass.variables
                strings += nestedClass.functions
            }

            let nestedEnums = extensionHolder.nestingConvertedToStringEnumHolders
            for nestedEnum in nestedEnums {
                strings += nestedEnum.generics
                if let rawvalueType = nestedEnum.rawvalueType {
                    strings.append(rawvalueType)
                }
                strings += nestedEnum.conformingProtocolNames
                strings += nestedEnum.typealiases
                strings += nestedEnum.initializers
                strings += nestedEnum.cases
                strings += nestedEnum.variables
                strings += nestedEnum.functions
            }
        } // for extensionHolder in extensions
        
        return strings
    } // func ofStruct(_ holder: ConvertedToStringStructHolder) -> [String]
    
    func ofClass(_ holder: ConvertedToStringClassHolder) -> [String] {
        var strings = [holder.name]
        strings += holder.generics
        if let superClass = holder.superClassName {
            strings.append(superClass)
        }
        strings += holder.conformingProtocolNames
        strings += holder.typealiases
        strings += holder.initializers
        strings += holder.variables
        strings += holder.functions
        
        let nestedStructs = holder.nestingConvertedToStringStructHolders
        for nestedStruct in nestedStructs {
            strings += nestedStruct.generics
            strings += nestedStruct.conformingProtocolNames
            strings += nestedStruct.typealiases
            strings += nestedStruct.initializers
            strings += nestedStruct.variables
            strings += nestedStruct.functions
        }
        
        let nestedClasses = holder.nestingConvertedToStringClassHolders
        for nestedClass in nestedClasses {
            strings += nestedClass.generics
            if let superClass = nestedClass.superClassName {
                strings.append(superClass)
            }
            strings += nestedClass.conformingProtocolNames
            strings += nestedClass.typealiases
            strings += nestedClass.initializers
            strings += nestedClass.variables
            strings += nestedClass.functions
        }
        
        let nestedEnums = holder.nestingConvertedToStringEnumHolders
        for nestedEnum in nestedEnums {
            strings += nestedEnum.generics
            if let rawvalueType = nestedEnum.rawvalueType {
                strings.append(rawvalueType)
            }
            strings += nestedEnum.conformingProtocolNames
            strings += nestedEnum.typealiases
            strings += nestedEnum.initializers
            strings += nestedEnum.cases
            strings += nestedEnum.variables
            strings += nestedEnum.functions
        }
        
        let extensions = holder.extensions
        for extensionHolder in extensions {
            strings += extensionHolder.conformingProtocolNames
            strings += extensionHolder.typealiases
            strings += extensionHolder.initializers
            strings += extensionHolder.variables
            strings += extensionHolder.functions

            let nestedStructs = extensionHolder.nestingConvertedToStringStructHolders
            for nestedStruct in nestedStructs {
                strings += nestedStruct.generics
                strings += nestedStruct.conformingProtocolNames
                strings += nestedStruct.typealiases
                strings += nestedStruct.initializers
                strings += nestedStruct.variables
                strings += nestedStruct.functions
            }

            let nestedClasses = extensionHolder.nestingConvertedToStringClassHolders
            for nestedClass in nestedClasses {
                strings += nestedClass.generics
                if let superClass = nestedClass.superClassName {
                    strings.append(superClass)
                }
                strings += nestedClass.conformingProtocolNames
                strings += nestedClass.typealiases
                strings += nestedClass.initializers
                strings += nestedClass.variables
                strings += nestedClass.functions
            }

            let nestedEnums = extensionHolder.nestingConvertedToStringEnumHolders
            for nestedEnum in nestedEnums {
                strings += nestedEnum.generics
                if let rawvalueType = nestedEnum.rawvalueType {
                    strings.append(rawvalueType)
                }
                strings += nestedEnum.conformingProtocolNames
                strings += nestedEnum.typealiases
                strings += nestedEnum.initializers
                strings += nestedEnum.cases
                strings += nestedEnum.variables
                strings += nestedEnum.functions
            }
        } // for extensionHolder in extensions
        
        return strings
    } // func ofClass(_ holder: ConvertedToStringClassHolder) -> [String]
    
    func ofEnum(_ holder: ConvertedToStringEnumHolder) -> [String] {
        var strings = [holder.name]
        strings += holder.generics
        if let rawvalueType = holder.rawvalueType {
            strings.append(rawvalueType)
        }
        strings += holder.conformingProtocolNames
        strings += holder.typealiases
        strings += holder.initializers
        strings += holder.cases
        strings += holder.variables
        strings += holder.functions
        
        let nestedStructs = holder.nestingConvertedToStringStructHolders
        for nestedStruct in nestedStructs {
            strings += nestedStruct.generics
            strings += nestedStruct.conformingProtocolNames
            strings += nestedStruct.typealiases
            strings += nestedStruct.initializers
            strings += nestedStruct.variables
            strings += nestedStruct.functions
        }
        
        let nestedClasses = holder.nestingConvertedToStringClassHolders
        for nestedClass in nestedClasses {
            strings += nestedClass.generics
            if let superClass = nestedClass.superClassName {
                strings.append(superClass)
            }
            strings += nestedClass.conformingProtocolNames
            strings += nestedClass.typealiases
            strings += nestedClass.initializers
            strings += nestedClass.variables
            strings += nestedClass.functions
        }
        
        let nestedEnums = holder.nestingConvertedToStringEnumHolders
        for nestedEnum in nestedEnums {
            strings += nestedEnum.generics
            if let rawvalueType = nestedEnum.rawvalueType {
                strings.append(rawvalueType)
            }
            strings += nestedEnum.conformingProtocolNames
            strings += nestedEnum.typealiases
            strings += nestedEnum.initializers
            strings += nestedEnum.cases
            strings += nestedEnum.variables
            strings += nestedEnum.functions
        }
        
        let extensions = holder.extensions
        for extensionHolder in extensions {
            strings += extensionHolder.conformingProtocolNames
            strings += extensionHolder.typealiases
            strings += extensionHolder.initializers
            strings += extensionHolder.variables
            strings += extensionHolder.functions

            let nestedStructs = extensionHolder.nestingConvertedToStringStructHolders
            for nestedStruct in nestedStructs {
                strings += nestedStruct.generics
                strings += nestedStruct.conformingProtocolNames
                strings += nestedStruct.typealiases
                strings += nestedStruct.initializers
                strings += nestedStruct.variables
                strings += nestedStruct.functions
            }

            let nestedClasses = extensionHolder.nestingConvertedToStringClassHolders
            for nestedClass in nestedClasses {
                strings += nestedClass.generics
                if let superClass = nestedClass.superClassName {
                    strings.append(superClass)
                }
                strings += nestedClass.conformingProtocolNames
                strings += nestedClass.typealiases
                strings += nestedClass.initializers
                strings += nestedClass.variables
                strings += nestedClass.functions
            }

            let nestedEnums = extensionHolder.nestingConvertedToStringEnumHolders
            for nestedEnum in nestedEnums {
                strings += nestedEnum.generics
                if let rawvalueType = nestedEnum.rawvalueType {
                    strings.append(rawvalueType)
                }
                strings += nestedEnum.conformingProtocolNames
                strings += nestedEnum.typealiases
                strings += nestedEnum.initializers
                strings += nestedEnum.cases
                strings += nestedEnum.variables
                strings += nestedEnum.functions
            }
        } // for extensionHolder in extensions
        
        return strings
    } // func ofEnum(_ holder: ConvertedToStringEnumHolder) -> [String]
    
    func ofNestStruct(_ holder: ConvertedToStringStructHolder) -> [String] {
        var strings = [holder.name]
        strings += holder.generics
        strings += holder.conformingProtocolNames
        strings += holder.typealiases
        strings += holder.initializers
        strings += holder.variables
        strings += holder.functions
        return strings
    } // func ofNestStruct(_ holder: ConvertedToStringStructHolder) -> [String]
    
    func ofNestClass(_ holder: ConvertedToStringClassHolder) -> [String] {
        var strings = [holder.name]
        strings += holder.generics
        if let superClass = holder.superClassName {
            strings.append(superClass)
        }
        strings += holder.conformingProtocolNames
        strings += holder.typealiases
        strings += holder.initializers
        strings += holder.variables
        strings += holder.functions
        return strings
    } // func ofNestClass(_ holder: ConvertedToStringClassHolder) -> [String]
    
    func ofNestEnum(_ holder: ConvertedToStringEnumHolder) -> [String] {
        var strings = [holder.name]
        strings += holder.generics
        if let rawvalueType = holder.rawvalueType {
            strings.append(rawvalueType)
        }
        strings += holder.conformingProtocolNames
        strings += holder.typealiases
        strings += holder.initializers
        strings += holder.cases
        strings += holder.variables
        strings += holder.functions
        return strings
    } // func ofNestEnum(_ holder: ConvertedToStringEnumHolder) -> [String]
    
    func ofExtension(_ holder: ConvertedToStringExtensionHolder) -> [String] {
        var strings = holder.conformingProtocolNames
        strings += holder.typealiases
        strings += holder.initializers
        strings += holder.variables
        strings += holder.functions
        
        let nestedStructs = holder.nestingConvertedToStringStructHolders
        for nestedStruct in nestedStructs {
            strings += nestedStruct.generics
            strings += nestedStruct.conformingProtocolNames
            strings += nestedStruct.typealiases
            strings += nestedStruct.initializers
            strings += nestedStruct.variables
            strings += nestedStruct.functions
        }
        
        let nestedClasses = holder.nestingConvertedToStringClassHolders
        for nestedClass in nestedClasses {
            strings += nestedClass.generics
            if let superClass = nestedClass.superClassName {
                strings.append(superClass)
            }
            strings += nestedClass.conformingProtocolNames
            strings += nestedClass.typealiases
            strings += nestedClass.initializers
            strings += nestedClass.variables
            strings += nestedClass.functions
        }
        
        let nestedEnums = holder.nestingConvertedToStringEnumHolders
        for nestedEnum in nestedEnums {
            strings += nestedEnum.generics
            if let rawvalueType = nestedEnum.rawvalueType {
                strings.append(rawvalueType)
            }
            strings += nestedEnum.conformingProtocolNames
            strings += nestedEnum.typealiases
            strings += nestedEnum.initializers
            strings += nestedEnum.cases
            strings += nestedEnum.variables
            strings += nestedEnum.functions
        }
        
        return strings
    } // func ofExtension(_ holder: ConvertedToStringExtensionHolder) -> [String]
} // struct AllStringOfHolder
