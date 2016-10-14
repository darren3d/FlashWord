//
//  DYStringUtility.swift
//  FlashWord
//
//  Created by darren on 16/6/21.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

extension NSAttributedString {
    /**
     Returns an NSAttributedString object initialized with a given string and attributes.
     
     - parameter string:     The string for the new attributed string.
     - parameter attributes: The attributes for the new attributed string.
     
     - returns: The newly created NSAttributedString.
     */
    public convenience init(string: NSString, attributes: TextAttributes) {
        self.init(string: string as String, attributes: attributes)
    }
    
    /**
     Returns an NSAttributedString object initialized with a given string and attributes.
     
     - parameter string:     The string for the new attributed string.
     - parameter attributes: The attributes for the new attributed string.
     
     - returns: The newly created NSAttributedString.
     */
    public convenience init(string: String, attributes: TextAttributes) {
        self.init(string: string, attributes: attributes.dictionary)
    }
}

extension NSMutableAttributedString {
    /**
     Sets the attributes to the specified attributes.
     
     - parameter attributes: The attributes to set.
     */
    public func setAttributes(attributes: TextAttributes) {
        setAttributes(attributes, range: NSRange(mutableString))
    }
    
    /**
     Sets the attributes for the characters in the specified range to the specified attributes.
     
     - parameter attributes: The attributes to set.
     - parameter range:      The range of characters whose attributes are set.
     */
    public func setAttributes(attributes: TextAttributes, range: Range<Int>) {
        setAttributes(attributes, range: NSRange(range))
    }
    
    /**
     Sets the attributes for the characters in the specified range to the specified attributes.
     
     - parameter attributes: The attributes to set.
     - parameter range:      The range of characters whose attributes are set.
     */
    public func setAttributes(attributes: TextAttributes, range: NSRange) {
        setAttributes(attributes.dictionary, range: range)
    }
    
    /**
     Adds the given attributes.
     
     - parameter attributes: The attributes to add.
     */
    public func addAttributes(attributes: TextAttributes) {
        addAttributes(attributes, range: NSRange(mutableString))
    }
    
    /**
     Adds the given collection of attributes to the characters in the specified range.
     
     - parameter attributes: The attributes to add.
     - parameter range:      he range of characters to which the specified attributes apply.
     */
    public func addAttributes(attributes: TextAttributes, range: Range<Int>) {
        addAttributes(attributes, range: NSRange(range))
    }
    
    /**
     Adds the given collection of attributes to the characters in the specified range.
     
     - parameter attributes: The attributes to add.
     - parameter range:      he range of characters to which the specified attributes apply.
     */
    public func addAttributes(attributes: TextAttributes, range: NSRange) {
        addAttributes(attributes.dictionary, range: range)
    }
}
