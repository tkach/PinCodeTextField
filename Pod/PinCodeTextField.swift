//
//  PinCodeTextField.swift
//  PinCodeTextField
//
//  Created by Alexander Tkachenko on 3/15/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class PinCodeTextField: UIView {
    
    @IBInspectable public var underlineWidth: CGFloat = 40
    @IBInspectable public var underlineHSpacing: CGFloat = 10
    @IBInspectable public var underlineVMargin: CGFloat = 0
    @IBInspectable public var characterLimit: Int = 5
    @IBInspectable public var underlineHeight: CGFloat = 3
    @IBInspectable public var placeholderText: String?
    @IBInspectable public var text: String?
    
    @IBInspectable public var fontSize: CGFloat = 14 {
        didSet {
            font = font.withSize(fontSize)
        }
    }
    @IBInspectable public var textColor: UIColor = UIColor.clear 
    @IBInspectable public var placeholderColor: UIColor = UIColor.lightGray
    @IBInspectable public var underlineColor: UIColor = UIColor.darkGray
    
    public var keyboardType: UIKeyboardType = .decimalPad
    public var font: UIFont = UIFont.systemFont(ofSize: 14)
    
    @IBInspectable public var secureText: Bool = false
    public var isSecureTextEntry: Bool {
        get {
            return secureText
        }
        @objc(setSecureTextEntry:) set {
            secureText = newValue
        }
    }
    
    fileprivate var labels: [UILabel] = []
    fileprivate var underlines: [UIView] = []
    
    
    //MARK: Awake
    override public func awakeFromNib() {
        super.awakeFromNib()
        updateSubviewsWithXibLoadedProperties()
    }
    
    override public func prepareForInterfaceBuilder() {
        updateSubviewsWithXibLoadedProperties()
    }
    
    private func updateSubviewsWithXibLoadedProperties() {
        updateView()
    }
    
    ///MARK: Overrides
    override public func layoutSubviews() {
        layoutCharactersAndPlaceholders()
        super.layoutSubviews()
    }
    
    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    ///MARK: Private
    fileprivate func updateView() {
        if (needToRecreateUnderlines()) {
            recreateUnderlines()
        }
        if (needToRecreateLabels()) {
            recreateLabels()
        }
        updateLabels()
        setNeedsLayout()
    }
    
    private func needToRecreateUnderlines() -> Bool {
        return characterLimit != underlines.count
    }
    
    private func needToRecreateLabels() -> Bool {
        return characterLimit != labels.count
    }
    
    private func recreateUnderlines() {
        underlines.forEach{ $0.removeFromSuperview() }
        
        for _ in 1...characterLimit {
            let underline = createUnderline()
            underlines.append(underline)
            addSubview(underline)
        }
    }
    
    private func recreateLabels() {
        labels.forEach{ $0.removeFromSuperview() }
        labels = []
        for _ in 1...characterLimit {
            let label = createLabel()
            labels.append(label)
            addSubview(label)
        }
    }
    
    private func updateLabels() {
        for label in labels {
            let i = labels.index(of: label) ?? 0
            let char = textOrPlaceholderChar(atIndex: i)
            label.text = char.map { String($0) }
            label.font = font
            let isplaceholder = isPlaceholder(index: i)
            updateLabelStyle(label, isPlaceholder: isplaceholder)
        }
    }
    
    private func updateLabelStyle(_ label: UILabel, isPlaceholder: Bool) {
        label.textColor = isPlaceholder ? placeholderColor : textColor
    }
    
    private func isPlaceholder(index i: Int) -> Bool {
        let inputTextCount = text?.characters.count ?? 0
        return i >= inputTextCount
    }
    
    private func textOrPlaceholderChar(atIndex i: Int) -> Character? {
        let inputTextCount = text?.characters.count ?? 0
        let placeholderTextLength = placeholderText?.characters.count ?? 0
        let character: Character?
        if i < inputTextCount {
            let string = text ?? ""
            character = isSecureTextEntry ? "•" : string[string.characters.index(string.startIndex, offsetBy: i)]
        }
        else if i < placeholderTextLength {
            let string = placeholderText ?? ""
            character = string[string.characters.index(string.startIndex, offsetBy: i)]
        }
        else {
            character = nil
        }
        return character
    }
    
    fileprivate func createLabel() -> UILabel {
        let label = UILabel(frame: CGRect())
        label.font = font
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        return label
    }
    
    private func createUnderline() -> UIView {
        let underline = UIView()
        underline.backgroundColor = underlineColor
        return underline
    }
    
    private func layoutCharactersAndPlaceholders() {
        let marginsCount = characterLimit - 1
        let totalMarginsWidth = underlineHSpacing * CGFloat(marginsCount)
        let totalUnderlinesWidth = underlineWidth * CGFloat(characterLimit)
        
        var currentLabelX: CGFloat = bounds.width / 2 - (totalUnderlinesWidth + totalMarginsWidth) / 2
        var currentUnderlineX = currentLabelX
        let totalLabelHeight = font.ascender + font.descender
        let underlineY = bounds.height / 2 + totalLabelHeight / 2 + underlineVMargin
        
        
        underlines.forEach{
            $0.frame = CGRect(x: currentUnderlineX, y: underlineY, width: underlineWidth, height: underlineHeight)
            currentUnderlineX += underlineWidth + underlineHSpacing
        }
        
        labels.forEach {
            $0.frame = CGRect(x: currentLabelX, y: 0, width: underlineWidth, height: bounds.height)
            currentLabelX += underlineWidth + underlineHSpacing
        }
        
    }
    
    ///MARK: Touches
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        if (bounds.contains(location)) {
            becomeFirstResponder()
        }
    }
}


extension PinCodeTextField: UIKeyInput {
    public var hasText: Bool {
        return text.map{ !$0.isEmpty } ?? false
    }
    
    public func insertText(_ charToInsert: String) {
        let isNewLine = charToInsert.trimmingCharacters(in: CharacterSet.newlines).isEmpty
        if isNewLine {
            resignFirstResponder()
        }
        else {
            let newText = text.map { $0 + charToInsert } ?? charToInsert
            guard newText.characters.count <= characterLimit else { return }
            text = newText
            updateView()
            if (newText.characters.count == characterLimit) {
                resignFirstResponder()
            }
        }
    }
    
    public func deleteBackward() {
        guard hasText else { return }
        text?.characters.removeLast()
        updateView()
    }
}


