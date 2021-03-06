//
//  BQSTHTMLTextView.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/24/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import CYRTextView

let kBQSTDefaultHTMLFontSize: CGFloat = 12

extension CYRToken {

    convenience init(name: String, expression: String, color: (r: CGFloat, g: CGFloat, b: CGFloat), font: UIFont?) {
        self.init()

        self.name = name
        self.expression = expression

        let f = font ?? UIFont.BQSTRawResponseFont()
        let c = UIColor(red: color.r / 255, green: color.g / 255, blue: color.b / 255, alpha: 1)

        self.attributes = [
            NSFontAttributeName: f,
            NSForegroundColorAttributeName: c
        ]
    }
}

class BQSTHTMLTextView: CYRTextView {

    var defaultFont: UIFont = UIFont.BQSTRawResponseFont() {
        didSet {
            self.font = self.defaultFont
            self.updateTokens()
        }
    }

    private func updateTokens() {
        self.tokens = [
            CYRToken(name: "string", expression: "\".*?(\"|$)", color: (24, 110, 109), font: nil),
            CYRToken(name: "integer", expression: "\\d+", attributes: [NSForegroundColorAttributeName: UIColor.BQSTRedColor()]),
            CYRToken(name: "mod", expression: "\\bmod\\b", color: (245, 0, 110), font: nil),
            CYRToken(name: "hex_1", expression: "\\$[\\d a-f]+", color: (0, 0, 255), font: nil),
            CYRToken(name: "octal_1", expression: "&[0-7]+", color: (0, 0, 255), font: nil),
            CYRToken(name: "binary_1", expression: "%[01]+", color: (0, 0, 255), font: nil),
            CYRToken(name: "hex_2", expression: "0x[0-9 a-f]+", color: (0, 0, 255), font: nil),
            CYRToken(name: "float", expression: "\\d+\\.?\\d+e[\\+\\-]?\\d+|\\d+\\.\\d+|∞", color: (0, 0, 255), font: nil),
            CYRToken(name: "operator", expression: "[/\\*,\\;:=<>\\+\\-\\^!·≤≥]", color: (245, 0, 110), font: nil),
            CYRToken(name: "round_brackets", expression: "[\\(\\)]", color: (161, 75, 0), font: nil),
            CYRToken(name: "square_brackets", expression: "[\\[\\]]", color: (105, 0, 0), font: nil),
            CYRToken(name: "absolute_brackets", expression: "[|]", color: (104, 0, 111), font: nil),
            CYRToken(name: "comment", expression: "\\b//.*", color: (31, 131, 0), font: UIFont.BQSTItalicFont(kBQSTDefaultHTMLFontSize)),
        ]
    }
}
