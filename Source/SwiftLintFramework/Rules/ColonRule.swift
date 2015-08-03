//
//  ColonRule.swift
//  SwiftLint
//
//  Created by JP Simard on 2015-05-16.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import SourceKittenFramework

public struct ColonRule: Rule {
    public init() {}

    public let identifier = "colon"

    public func validateFile(file: File) -> [StyleViolation] {
        let pattern1A = file.matchPattern("(?<!\\?)((\\s|\\[|\\()\\w+\\s+:\\s*[\\w\\[\\(\\<]+)",
            withSyntaxKinds: [.Identifier, .Identifier])
        let pattern1B = file.matchPattern("(?<!\\?)((\\s|\\[|\\()\\w+\\s+:\\s*[\\w\\[\\(\\<]+)",
            withSyntaxKinds: [.Identifier, .Typeidentifier])
        let pattern1C = file.matchPattern("(?<!\\?)((\\s|\\[|\\()\\w+\\s+:\\s*[\\w\\[\\(\\<]+)",
            withSyntaxKinds: [.Typeidentifier, .Typeidentifier])
        let pattern2A = file.matchPattern("\\w+:(\\s{0}|[^\\n]\\s{1,})[\\w\\[\\(\\<]+",
            withSyntaxKinds: [.Identifier, .Identifier])
        let pattern2B = file.matchPattern("\\w+:(\\s{0}|[^\\n]\\s{1,})[\\w\\[\\(\\<]+",
            withSyntaxKinds: [.Identifier, .Typeidentifier])
        let pattern2C = file.matchPattern("\\w+:(\\s{0}|[^\\n]\\s{1,})[\\w\\[\\(\\<]+",
            withSyntaxKinds: [.Typeidentifier, .Typeidentifier])
        
        let pattern1 = pattern1A + pattern1B + pattern1C
        let pattern2 = pattern2A + pattern2B + pattern2C
        let pattern = pattern1 + pattern2
        
        return pattern.map { range in
            return StyleViolation(type: .Colon,
                location: Location(file: file, offset: range.location),
                severity: .Low,
                reason: "Should be no space before colon and one space after.")
        }
    }

    public let example = RuleExample(
        ruleName: "Colon Rule",
        ruleDescription: "This rule checks whether you associate the colon with the identifier.",
        nonTriggeringExamples: [
            "let abc: Void\n",
            "let abc: [Void: Void]\n",
            "let abc: (Void, Void)\n",
            "let abc = [Void: Void]()\n",
            "let def = ifTrue ? doSomething : doSomethingElse\n",
            "func abc(def: Void) {}\n",
            "func abc<T: U>(value: T) -> U {}\n",
            "case .Def:\n",
            "var someValueC: [Int: Int]?\n",
            "var semiBoldFontAttr = [NSFontAttributeName: UIFont.leToteFontName(.Semibold, size: 14.0)!]\n"
        ],
        triggeringExamples: [
            "let abc:Void\n",
            "let abc:  Void\n",
            "let abc :Void\n",
            "let abc : Void\n",
            "let abc : [Void: Void]\n",
            "let abc = [Void:Void]()\n",
            "let abc = [Void : Void]()\n",
            "let abc = [Void :Void]()\n",
            "func abc(def:Void) {}\n",
            "func abc(def:  Void) {}\n",
            "func abc(def :Void) {}\n",
            "func abc(def : Void) {}\n",
            "var someValueC: [Int : Int]?\n",
            "var semiBoldFontAttr = [NSFontAttributeName : UIFont.leToteFontName(.Semibold, size: 14.0)!]\n"
        ]
    )
}
