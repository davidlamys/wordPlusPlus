//
//  TextParser.swift
//  wordPlusPlus
//
//  Created by David Lam on 6/10/16.
//  Copyright © 2016 David Lam. All rights reserved.
//

import Foundation

class TextParser: NSObject {
    static func parseText() -> [String] {
        guard let path = Bundle.main.path(forResource: "positive-words", ofType: "txt") else {
            return []
        }
        
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let myStrings = data.components(separatedBy: .newlines)
            return myStrings
        } catch {
            return []
        }
        
    }
}
