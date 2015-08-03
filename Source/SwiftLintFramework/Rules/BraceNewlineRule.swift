//
//  BraceNewlineRule.swift
//  SwiftLint
//
//  Created by Ryan Taylor on 8/2/15.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import SourceKittenFramework

extension NSRange: Equatable {}
public func ==(lhs: NSRange, rhs: NSRange) -> Bool {
    return lhs.location == rhs.location
}

public struct BraceNewlineRule: Rule {
    public init() {}
    
    public let identifier = "braceNewline"
    
    public func validateFile(file: File) -> [StyleViolation] {
        let openingBraceCommentMatches = file.matchPattern(".*\\{(\\s*\\t*\\n\\s*\\t*){2,}", withSyntaxKinds: [.Comment])
        let closingBraceCommentMatches = file.matchPattern(".*\\}(\\s*\\t*\\n\\s*\\t*){3,}", withSyntaxKinds: [.Comment])
        let isComment = openingBraceCommentMatches.count + closingBraceCommentMatches.count > 0
        
        if isComment {
            return []
        }

        let openingBraceMatches = file.matchPattern("\\{(\\s*\\t*\\n\\s*\\t*){2,}(?!\\s*\\t*\\})", withSyntaxKinds: [])
        let closingBraceMatches1 = file.matchPattern("\\}(\\s*\\t*\\n\\s*\\t*){3,}", withSyntaxKinds: [])
        var closingBraceMatches2 = file.matchPattern("(?<!\\{)(\\s*\\n\\s*){2,}\\}", withSyntaxKinds: [])
        
        return (openingBraceMatches + closingBraceMatches1 + closingBraceMatches2).map { range in
            return StyleViolation(type: .BraceNewline,
                location: Location(file: file, offset: range.location + 1),
                severity: .Low,
                reason: "Too many newlines before/after brace.")
        }
    }
    
    public let example = RuleExample(
        ruleName: "Brace Newline Rule",
        ruleDescription: "Checks for too many newlines after a declaration.",
        nonTriggeringExamples: [
            "class SomeClass: SomeBaseClass, SomeProtocol {}\n",
            "class SomeClass: SomeBaseClass, SomeProtocol {\n}\n",
            "func someMethod(value: Int) -> Int {\nreturn value\n}\n",
            "func someMethod(value: Int) -> Int {\n\treturn value\n}\n",
            "class SomeClass: SomeProtocol {\n\tfunc request(value: Int) -> Int {\nt\treturn value\n}\n}\n",
            "}\n}\n",
            "// Some message.\n\nclass SomeClass: SomeProtocol {\n    func request(value: Int) -> Int {\n        return value\n    }\n}\n",
            "init() {\n    \n}\n"
        ],
        triggeringExamples: [
            "class SomeClass: SomeBaseClass, SomeProtocol {\n\n\n\n}\n",
            "func someMethod(value: Int) -> Int {\n\nreturn value\n}\n",
            "func someMethod(value: Int) -> Int {\n\t\n\treturn value\n}\n",
            "}\n\n}\n",
            "// Some message.\n\nclass SomeClass: SomeProtocol {\n    \n    func request(value: Int) -> Int {\n        return value\n    }\n}\n"
        ]
    )
}
