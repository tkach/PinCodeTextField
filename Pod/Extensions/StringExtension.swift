//
//  StringExtension.swift
//  PinCodeTextField
//
//  Created by Alexander Tkachenko on 3/20/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation

internal extension String {
    var hasOnlyNewlineSymbols: Bool {
        return trimmingCharacters(in: CharacterSet.newlines).isEmpty
    }
    
    var length: Int {
        #if swift(>=3.2)
            return count
        #else
            return characters.count
        #endif
    }
    
    @available(swift 3.0)
    @discardableResult mutating func removeLastCharacter() -> String  {
        #if swift(>=3.2)
            return String(removeLast())
        #else
            return String(characters.removeLast())
        #endif
    }
}
