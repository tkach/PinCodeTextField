//
//  PinCodeTextField.swift
//  PinCodeTextField
//
//  Created by Alexander Tkachenko on 3/15/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable open class PinCodeTextField: UIView {
    public weak var delegate: PinCodeTextFieldDelegate?
    
    //MARK: Customizable from Interface Builder
    @IBInspectable public var underlineWidth: CGFloat = 40
    @IBInspectable public var underlineHSpacing: CGFloat = 10
    @IBInspectable public var underlineVMargin: CGFloat = 0
    @IBInspectable public var characterLimit: Int = 4 {
        willSet {
            if characterLimit != newValue {
                updateView()
            }
        }
    }
    @IBInspectable public var underlineHeight: CGFloat = 3
    @IBInspectable public var placeholderText: String?
    @IBInspectable public var text: String? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable public var fontSize: CGFloat = 14 {
        didSet {
            font = font.withSize(fontSize)
        }
    }
    @IBInspectable public var textColor: UIColor = UIColor.clear 
    @IBInspectable public var placeholderColor: UIColor = UIColor.lightGray
    @IBInspectable public var underlineColor: UIColor = UIColor.darkGray
    @IBInspectable public var updatedUnderlineColor: UIColor = UIColor.clear
    @IBInspectable public var secureText: Bool = false
	@IBInspectable public var secureCharacter: String = "•"
    @IBInspectable public var needToUpdateUnderlines: Bool = true
    @IBInspectable public var characterBackgroundColor: UIColor = UIColor.clear
    @IBInspectable public var characterBackgroundCornerRadius: CGFloat = 0
    @IBInspectable public var highlightInputUnderline: Bool = false
    
    //MARK: Customizable from code
    public var keyboardType: UIKeyboardType = UIKeyboardType.alphabet
    public var keyboardAppearance: UIKeyboardAppearance = UIKeyboardAppearance.default
    public var autocorrectionType: UITextAutocorrectionType = UITextAutocorrectionType.no
    public var font: UIFont = UIFont.systemFont(ofSize: 14)
    public var allowedCharacterSet: CharacterSet = CharacterSet.alphanumerics
    public var textContentType: UITextContentType! = nil
    
    private var _inputView: UIView?
    open override var inputView: UIView? {
        get {
            return _inputView
        }
        set {
            _inputView = newValue
        }
    }
    
    // UIResponder
    private var _inputAccessoryView: UIView?
    @IBOutlet open override var inputAccessoryView: UIView? {
        get {
            return _inputAccessoryView
        }
        set {
            _inputAccessoryView = newValue
        }
    }
    
    public var isSecureTextEntry: Bool {
        get {
            return secureText
        }
        @objc(setSecureTextEntry:) set {
            secureText = newValue
        }
    }
    
    //MARK: Private
    private var labels: [UILabel] = []
    private var underlines: [UIView] = []
    private var backgrounds: [UIView] = []
    
    
    //MARK: Init and awake
    override public init(frame: CGRect) {
        super.init(frame: frame)
        postInitialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        postInitialize()
    }
    
    override open func prepareForInterfaceBuilder() {
        postInitialize()
    }
    
    private func postInitialize() {
        updateView()
    }
    
    //MARK: Overrides
    override open func layoutSubviews() {
        layoutCharactersAndPlaceholders()
        super.layoutSubviews()
    }
    
    override open var canBecomeFirstResponder: Bool {
        return true
    }
    
    @discardableResult override open func becomeFirstResponder() -> Bool {
        delegate?.textFieldDidBeginEditing(self)
        return super.becomeFirstResponder()
    }
    
    @discardableResult override open func resignFirstResponder() -> Bool {
        delegate?.textFieldDidEndEditing(self)
        return super.resignFirstResponder()
    }
    
    //MARK: Private
    private func updateView() {
        if needToRecreateBackgrounds() {
            recreateBackgrounds()
        }
        if needToRecreateUnderlines() {
            recreateUnderlines()
        }
        if needToRecreateLabels() {
            recreateLabels()
        }
        updateLabels()

        if needToUpdateUnderlines {
            updateUnderlines()
        }
        updateBackgrounds()
        setNeedsLayout()
    }
    
    private func needToRecreateUnderlines() -> Bool {
        return characterLimit != underlines.count
    }
    
    private func needToRecreateLabels() -> Bool {
        return characterLimit != labels.count
    }
    
    private func needToRecreateBackgrounds() -> Bool {
        return characterLimit != backgrounds.count
    }
    
    private func recreateUnderlines() {
        underlines.forEach{ $0.removeFromSuperview() }
        underlines.removeAll()
        characterLimit.times {
            let underline = createUnderline()
            underlines.append(underline)
            addSubview(underline)
        }
    }
    
    private func recreateLabels() {
        labels.forEach{ $0.removeFromSuperview() }
        labels.removeAll()
        characterLimit.times {
            let label = createLabel()
            labels.append(label)
            addSubview(label)
        }
    }
    
    private func recreateBackgrounds() {
        backgrounds.forEach{ $0.removeFromSuperview() }
        backgrounds.removeAll()
        characterLimit.times {
            let background = createBackground()
            backgrounds.append(background)
            addSubview(background)
        }
    }
    
    private func updateLabels() {
		let textHelper = TextHelper(text: text, placeholder: placeholderText, isSecure: isSecureTextEntry, charSubstitute: Character(secureCharacter))
        for label in labels {
            let index = labels.firstIndex(of: label) ?? 0
            let currentCharacter = textHelper.character(atIndex: index)
            label.text = currentCharacter.map { String($0) }
            label.font = font
            let isplaceholder = isPlaceholder(index)
            label.textColor = labelColor(isPlaceholder: isplaceholder)
        }
    }

    private func updateUnderlines() {
        for label in labels {
            let index = labels.firstIndex(of: label) ?? 0
            if (!highlightInputUnderline || !isInput(index)) && isPlaceholder(index) {
                   underlines[index].backgroundColor = underlineColor
            }
            else{
                underlines[index].backgroundColor = updatedUnderlineColor
            }
        }
    }
    
    private func updateBackgrounds() {
        for background in backgrounds {
            background.backgroundColor = characterBackgroundColor
            background.layer.cornerRadius = characterBackgroundCornerRadius
        }
    }
    
    private func labelColor(isPlaceholder placeholder: Bool) -> UIColor {
        return placeholder ? placeholderColor : textColor
    }
    
    private func isPlaceholder(_ i: Int) -> Bool {
        let inputTextCount = text?.count ?? 0
        return i >= inputTextCount
    }
    
    private func isInput(_ i: Int) -> Bool {
        let inputTextCount = text?.count ?? 0
        return i == inputTextCount
    }
    
    private func createLabel() -> UILabel {
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
    
    private func createBackground() -> UIView {
        let background = UIView()
        background.backgroundColor = characterBackgroundColor
        background.layer.cornerRadius = characterBackgroundCornerRadius
        background.clipsToBounds = true
        return background
    }
    
    private func layoutCharactersAndPlaceholders() {
        let marginsCount = characterLimit - 1
        let totalMarginsWidth = underlineHSpacing * CGFloat(marginsCount)
        let totalUnderlinesWidth = underlineWidth * CGFloat(characterLimit)
        
        var currentUnderlineX: CGFloat = bounds.width / 2 - (totalUnderlinesWidth + totalMarginsWidth) / 2
        var currentLabelCenterX = currentUnderlineX + underlineWidth / 2
        
        let totalLabelHeight = font.ascender + font.descender
        let underlineY = bounds.height / 2 + totalLabelHeight / 2 + underlineVMargin
        
        for i in 0..<underlines.count {
            let underline = underlines[i]
            let background = backgrounds[i]
            underline.frame = CGRect(x: currentUnderlineX, y: underlineY, width: underlineWidth, height: underlineHeight)
            background.frame = CGRect(x: currentUnderlineX, y: 0, width: underlineWidth, height: bounds.height)
            currentUnderlineX += underlineWidth + underlineHSpacing
        }
        
        labels.forEach {
            $0.sizeToFit()
            let labelWidth = $0.bounds.width
            let labelX = (currentLabelCenterX - labelWidth / 2).rounded(.down)
            $0.frame = CGRect(x: labelX, y: 0, width: labelWidth, height: bounds.height)
            currentLabelCenterX += underlineWidth + underlineHSpacing
        }
        
    }
    
    //MARK: Touches
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        if (bounds.contains(location)) {
            if (delegate?.textFieldShouldBeginEditing(self) ?? true) {
                let _ = becomeFirstResponder()
            }
        }
    }
    
    
    //MARK: Text processing
    func canInsertCharacter(_ character: String) -> Bool {
        let newText = text.map { $0 + character } ?? character
        let isNewline = character.hasOnlyNewlineSymbols
        let isCharacterMatchingCharacterSet = character.trimmingCharacters(in: allowedCharacterSet).isEmpty
        let isLengthWithinLimit = newText.count <= characterLimit
        return !isNewline && isCharacterMatchingCharacterSet && isLengthWithinLimit
    }
}


//MARK: UIKeyInput
extension PinCodeTextField: UIKeyInput {
    public var hasText: Bool {
        if let text = text {
            return !text.isEmpty
        }
        else {
            return false
        }
    }
    
    public func insertText(_ charToInsert: String) {
        if charToInsert.hasOnlyNewlineSymbols {
            if (delegate?.textFieldShouldReturn(self) ?? true) {
                let _ = resignFirstResponder()
            }
        }
        else if canInsertCharacter(charToInsert) {
            let newText = text.map { $0 + charToInsert } ?? charToInsert
            text = newText
            delegate?.textFieldValueChanged(self)
            if (newText.count == characterLimit) {
                if (delegate?.textFieldShouldEndEditing(self) ?? true) {
                    let _ = resignFirstResponder()
                }
            }
        }
    }
    
    public func deleteBackward() {
        guard hasText else { return }
        text?.removeLast()
        delegate?.textFieldValueChanged(self)
    }
}

