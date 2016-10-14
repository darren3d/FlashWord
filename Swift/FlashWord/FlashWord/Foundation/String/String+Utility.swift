//
//  DYStringUtility.swift
//  FlashWord
//
//  Created by darren on 16/6/21.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation

public extension String {
    
    ///  Finds the string between two bookend strings if it can be found.
    ///
    ///  - parameter left:  The left bookend
    ///  - parameter right: The right bookend
    ///
    ///  - returns: The string between the two bookends, or nil if the bookends cannot be found, the bookends are the same or appear contiguously.
    func between(left: String, _ right: String) -> String? {
        guard
            let leftRange = rangeOfString(left), rightRange = rangeOfString(right, options: .BackwardsSearch)
            where left != right && leftRange.endIndex != rightRange.startIndex
            else { return nil }
        
        return self[leftRange.endIndex...rightRange.startIndex.predecessor()]
        
    }
    
    // https://gist.github.com/stevenschobert/540dd33e828461916c11
    func camelize() -> String {
        let source = clean(with: " ", allOf: "-", "_")
        if source.characters.contains(" ") {
            let first = source.substringToIndex(source.startIndex.advancedBy(1))
            let cammel = NSString(format: "%@", (source as NSString).capitalizedString.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)) as String
            let rest = String(cammel.characters.dropFirst())
            return "\(first)\(rest)"
        } else {
            let first = (source as NSString).lowercaseString.substringToIndex(source.startIndex.advancedBy(1))
            let rest = String(source.characters.dropFirst())
            return "\(first)\(rest)"
        }
    }
    
    func capitalize() -> String {
        return capitalizedString
    }
    
    func contains(substring: String) -> Bool {
        return rangeOfString(substring) != nil
    }
    
    func chompLeft(prefix: String) -> String {
        if let prefixRange = rangeOfString(prefix) {
            if prefixRange.endIndex >= endIndex {
                return self[startIndex..<prefixRange.startIndex]
            } else {
                return self[prefixRange.endIndex..<endIndex]
            }
        }
        return self
    }
    
    func chompRight(suffix: String) -> String {
        if let suffixRange = rangeOfString(suffix, options: .BackwardsSearch) {
            if suffixRange.endIndex >= endIndex {
                return self[startIndex..<suffixRange.startIndex]
            } else {
                return self[suffixRange.endIndex..<endIndex]
            }
        }
        return self
    }
    
    func collapseWhitespace() -> String {
        let components = componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter { !$0.isEmpty }
        return components.joinWithSeparator(" ")
    }
    
    func clean(with with: String, allOf: String...) -> String {
        var string = self
        for target in allOf {
            string = string.stringByReplacingOccurrencesOfString(target, withString: with)
        }
        return string
    }
    
    func count(substring: String) -> Int {
        return componentsSeparatedByString(substring).count-1
    }
    
    func endsWith(suffix: String) -> Bool {
        return hasSuffix(suffix)
    }
    
    func ensureLeft(prefix: String) -> String {
        if startsWith(prefix) {
            return self
        } else {
            return "\(prefix)\(self)"
        }
    }
    
    func ensureRight(suffix: String) -> String {
        if endsWith(suffix) {
            return self
        } else {
            return "\(self)\(suffix)"
        }
    }
    
    func indexOf(substring: String) -> Int? {
        if let range = rangeOfString(substring) {
            return startIndex.distanceTo(range.startIndex)
        }
        return nil
    }
    
    func initials() -> String {
        let words = self.componentsSeparatedByString(" ")
        return words.reduce(""){$0 + $1[0...0]}
    }
    
    func initialsFirstAndLast() -> String {
        let words = self.componentsSeparatedByString(" ")
        return words.reduce("") { ($0 == "" ? "" : $0[0...0]) + $1[0...0]}
    }
    
    func isAlpha() -> Bool {
        for chr in characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    func isAlphaNumeric() -> Bool {
        let alphaNumeric = NSCharacterSet.alphanumericCharacterSet()
        return componentsSeparatedByCharactersInSet(alphaNumeric).joinWithSeparator("").length == 0
    }
    
    func isEmpty() -> Bool {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).length == 0
    }
    
    func isNumeric() -> Bool {
        if let _ = defaultNumberFormatter().numberFromString(self) {
            return true
        }
        return false
    }
    
    func join<S: SequenceType>(elements: S) -> String {
        return elements.map{String($0)}.joinWithSeparator(self)
    }
    
    func latinize() -> String {
        return self.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
    }
    
    func lines() -> [String] {
        return self.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    }
    
    var length: Int {
        get {
            return self.characters.count
        }
    }
    
    func pad(n: Int, _ string: String = " ") -> String {
        return "".join([string.times(n), self, string.times(n)])
    }
    
    func padLeft(n: Int, _ string: String = " ") -> String {
        return "".join([string.times(n), self])
    }
    
    func padRight(n: Int, _ string: String = " ") -> String {
        return "".join([self, string.times(n)])
    }
    
    func slugify(withSeparator separator: Character = "-") -> String {
        let slugCharacterSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\(separator)")
        return latinize()
            .lowercaseString
            .componentsSeparatedByCharactersInSet(slugCharacterSet.invertedSet)
            .filter { $0 != "" }
            .joinWithSeparator(String(separator))
    }
    
    func split(separator: Character) -> [String] {
        return characters.split{$0 == separator}.map(String.init)
    }
    
    func startsWith(prefix: String) -> Bool {
        return hasPrefix(prefix)
    }
    
    func stripPunctuation() -> String {
        return componentsSeparatedByCharactersInSet(.punctuationCharacterSet())
            .joinWithSeparator("")
            .componentsSeparatedByString(" ")
            .filter { $0 != "" }
            .joinWithSeparator(" ")
    }
    
    func times(n: Int) -> String {
        return (0..<n).reduce("") { $0.0 + self }
    }
    
    func toFloat() -> Float? {
        if let number = defaultNumberFormatter().numberFromString(self) {
            return number.floatValue
        }
        return nil
    }
    
    func toInt() -> Int? {
        if let number = defaultNumberFormatter().numberFromString(self) {
            return number.integerValue
        }
        return nil
    }
    
    func toDouble(locale: NSLocale = NSLocale.systemLocale()) -> Double? {
        let nf = localeNumberFormatter(locale)
        
        if let number = nf.numberFromString(self) {
            return number.doubleValue
        }
        return nil
    }
    
    func toBool() -> Bool? {
        let trimmed = self.trimmed().lowercaseString
        if trimmed == "true" || trimmed == "false" {
            return (trimmed as NSString).boolValue
        }
        return nil
    }
    
    func toDate(format: String = "yyyy-MM-dd") -> NSDate? {
        return dateFormatter(format).dateFromString(self)
    }
    
    func toDateTime(format: String = "yyyy-MM-dd HH:mm:ss") -> NSDate? {
        return toDate(format)
    }
    
    func trimmedLeft() -> String {
        if let range = rangeOfCharacterFromSet(NSCharacterSet.whitespaceAndNewlineCharacterSet().invertedSet) {
            return self[range.startIndex..<endIndex]
        }
        return self
    }
    
    func trimmedRight() -> String {
        if let range = rangeOfCharacterFromSet(NSCharacterSet.whitespaceAndNewlineCharacterSet().invertedSet, options: NSStringCompareOptions.BackwardsSearch) {
            return self[startIndex..<range.endIndex]
        }
        return self
    }
    
    func trimmed() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    subscript(r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex - r.startIndex)
            return self[startIndex..<endIndex]
        }
    }
    
    func substring(startIndex: Int, length: Int) -> String {
        let start = self.startIndex.advancedBy(startIndex)
        let end = self.startIndex.advancedBy(startIndex + length)
        return self[start..<end]
    }
    
    subscript(i: Int) -> Character {
        get {
            let index = self.startIndex.advancedBy(i)
            return self[index]
        }
    }
}

private enum ThreadLocalIdentifier {
    case DateFormatter(String)
    
    case DefaultNumberFormatter
    case LocaleNumberFormatter(NSLocale)
    
    var objcDictKey: String {
        switch self {
        case .DateFormatter(let format):
            return "SS\(self)\(format)"
        case .LocaleNumberFormatter(let l):
            return "SS\(self)\(l.localeIdentifier)"
        default:
            return "SS\(self)"
        }
    }
}

private func threadLocalInstance<T: AnyObject>(identifier: ThreadLocalIdentifier, @autoclosure initialValue: () -> T) -> T {
    let storage = NSThread.currentThread().threadDictionary
    let k = identifier.objcDictKey
    
    let instance: T = storage[k] as? T ?? initialValue()
    if storage[k] == nil {
        storage[k] = instance
    }
    
    return instance
}

private func dateFormatter(format: String) -> NSDateFormatter {
    return threadLocalInstance(.DateFormatter(format), initialValue: {
        let df = NSDateFormatter()
        df.dateFormat = format
        return df
        }())
}

private func defaultNumberFormatter() -> NSNumberFormatter {
    return threadLocalInstance(.DefaultNumberFormatter, initialValue: NSNumberFormatter())
}

private func localeNumberFormatter(locale: NSLocale) -> NSNumberFormatter {
    return threadLocalInstance(.LocaleNumberFormatter(locale), initialValue: {
        let nf = NSNumberFormatter()
        nf.locale = locale
        return nf
        }())
}

//MARK - MD5
extension String {
    public func MD5() -> String {
        return hex_md5(self)
    }
    
    // MARK: - Functions
    
    private func hex_md5(input: String) -> String {
        return rstr2hex(rstr_md5(str2rstr_utf8(input)))
    }
    
    private func str2rstr_utf8(input: String) -> [CUnsignedChar] {
        return Array(input.utf8)
    }
    
    private func rstr2tr(input: [CUnsignedChar]) -> String {
        var output: String = ""
        
        input.forEach {
            output.append(UnicodeScalar($0))
        }
        
        return output
    }
    
    /*
     * Convert a raw string to a hex string
     */
    private func rstr2hex(input: [CUnsignedChar]) -> String {
        let hexTab: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
        var output: [Character] = []
        
        for i in 0..<input.count {
            let x = input[i]
            let value1 = hexTab[Int((x >> 4) & 0x0F)]
            let value2 = hexTab[Int(Int32(x) & 0x0F)]
            
            output.append(value1)
            output.append(value2)
        }
        
        return String(output)
    }
    
    /*
     * Convert a raw string to an array of little-endian words
     * Characters >255 have their high-byte silently ignored.
     */
    private func rstr2binl(input: [CUnsignedChar]) -> [Int32] {
        var output: [Int: Int32] = [:]
        
        for i in 0.stride(to: input.count * 8, by: 8) {
            let value: Int32 = (Int32(input[i/8]) & 0xFF) << (Int32(i) % 32)
            
            output[i >> 5] = unwrap(output[i >> 5]) | value
        }
        
        return dictionary2array(output)
    }
    
    /*
     * Convert an array of little-endian words to a string
     */
    private func binl2rstr(input: [Int32]) -> [CUnsignedChar] {
        var output: [CUnsignedChar] = []
        
        for i in 0.stride(to: input.count * 32, by: 8) {
            // [i>>5] >>>
            let value: Int32 = zeroFillRightShift(input[i>>5], Int32(i % 32)) & 0xFF
            output.append(CUnsignedChar(value))
        }
        
        return output
    }
    
    /*
     * Calculate the MD5 of a raw string
     */
    private func rstr_md5(input: [CUnsignedChar]) -> [CUnsignedChar] {
        return binl2rstr(binl_md5(rstr2binl(input), input.count * 8))
    }
    
    /*
     * Add integers, wrapping at 2^32. This uses 16-bit operations internally
     * to work around bugs in some JS interpreters.
     */
    private func safe_add(x: Int32, _ y: Int32) -> Int32 {
        let lsw = (x & 0xFFFF) + (y & 0xFFFF)
        let msw = (x >> 16) + (y >> 16) + (lsw >> 16)
        return (msw << 16) | (lsw & 0xFFFF)
    }
    
    /*
     * Bitwise rotate a 32-bit number to the left.
     */
    private func bit_rol(num: Int32, _ cnt: Int32) -> Int32 {
        // num >>>
        return (num << cnt) | zeroFillRightShift(num, (32 - cnt))
    }
    
    
    /*
     * These funcs implement the four basic operations the algorithm uses.
     */
    private func md5_cmn(q: Int32, _ a: Int32, _ b: Int32, _ x: Int32, _ s: Int32, _ t: Int32) -> Int32 {
        return safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s), b)
    }
    
    private func md5_ff(a: Int32, _ b: Int32, _ c: Int32, _ d: Int32, _ x: Int32, _ s: Int32, _ t: Int32) -> Int32 {
        return md5_cmn((b & c) | ((~b) & d), a, b, x, s, t)
    }
    
    private func md5_gg(a: Int32, _ b: Int32, _ c: Int32, _ d: Int32, _ x: Int32, _ s: Int32, _ t: Int32) -> Int32 {
        return md5_cmn((b & d) | (c & (~d)), a, b, x, s, t)
    }
    
    private func md5_hh(a: Int32, _ b: Int32, _ c: Int32, _ d: Int32, _ x: Int32, _ s: Int32, _ t: Int32) -> Int32 {
        return md5_cmn(b ^ c ^ d, a, b, x, s, t)
    }
    
    private func md5_ii(a: Int32, _ b: Int32, _ c: Int32, _ d: Int32, _ x: Int32, _ s: Int32, _ t: Int32) -> Int32 {
        return md5_cmn(c ^ (b | (~d)), a, b, x, s, t)
    }
    
    
    /*
     * Calculate the MD5 of an array of little-endian words, and a bit length.
     */
    private func binl_md5(input: [Int32], _ len: Int) -> [Int32] {
        /* append padding */
        
        var x: [Int: Int32] = [:]
        for (index, value) in input.enumerate() {
            x[index] = value
        }
        
        let value: Int32 = 0x80 << Int32((len) % 32)
        x[len >> 5] = unwrap(x[len >> 5]) | value
        
        // >>> 9
        let index = (((len + 64) >> 9) << 4) + 14
        x[index] = unwrap(x[index]) | Int32(len)
        
        var a: Int32 =  1732584193
        var b: Int32 = -271733879
        var c: Int32 = -1732584194
        var d: Int32 =  271733878
        
        for i in 0.stride(to: length(x), by: 16) {
            let olda: Int32 = a
            let oldb: Int32 = b
            let oldc: Int32 = c
            let oldd: Int32 = d
            
            a = md5_ff(a, b, c, d, unwrap(x[i + 0]), 7 , -680876936)
            d = md5_ff(d, a, b, c, unwrap(x[i + 1]), 12, -389564586)
            c = md5_ff(c, d, a, b, unwrap(x[i + 2]), 17,  606105819)
            b = md5_ff(b, c, d, a, unwrap(x[i + 3]), 22, -1044525330)
            a = md5_ff(a, b, c, d, unwrap(x[i + 4]), 7 , -176418897)
            d = md5_ff(d, a, b, c, unwrap(x[i + 5]), 12,  1200080426)
            c = md5_ff(c, d, a, b, unwrap(x[i + 6]), 17, -1473231341)
            b = md5_ff(b, c, d, a, unwrap(x[i + 7]), 22, -45705983)
            a = md5_ff(a, b, c, d, unwrap(x[i + 8]), 7 ,  1770035416)
            d = md5_ff(d, a, b, c, unwrap(x[i + 9]), 12, -1958414417)
            c = md5_ff(c, d, a, b, unwrap(x[i + 10]), 17, -42063)
            b = md5_ff(b, c, d, a, unwrap(x[i + 11]), 22, -1990404162)
            a = md5_ff(a, b, c, d, unwrap(x[i + 12]), 7 ,  1804603682)
            d = md5_ff(d, a, b, c, unwrap(x[i + 13]), 12, -40341101)
            c = md5_ff(c, d, a, b, unwrap(x[i + 14]), 17, -1502002290)
            b = md5_ff(b, c, d, a, unwrap(x[i + 15]), 22,  1236535329)
            
            a = md5_gg(a, b, c, d, unwrap(x[i + 1]), 5 , -165796510)
            d = md5_gg(d, a, b, c, unwrap(x[i + 6]), 9 , -1069501632)
            c = md5_gg(c, d, a, b, unwrap(x[i + 11]), 14,  643717713)
            b = md5_gg(b, c, d, a, unwrap(x[i + 0]), 20, -373897302)
            a = md5_gg(a, b, c, d, unwrap(x[i + 5]), 5 , -701558691)
            d = md5_gg(d, a, b, c, unwrap(x[i + 10]), 9 ,  38016083)
            c = md5_gg(c, d, a, b, unwrap(x[i + 15]), 14, -660478335)
            b = md5_gg(b, c, d, a, unwrap(x[i + 4]), 20, -405537848)
            a = md5_gg(a, b, c, d, unwrap(x[i + 9]), 5 ,  568446438)
            d = md5_gg(d, a, b, c, unwrap(x[i + 14]), 9 , -1019803690)
            c = md5_gg(c, d, a, b, unwrap(x[i + 3]), 14, -187363961)
            b = md5_gg(b, c, d, a, unwrap(x[i + 8]), 20,  1163531501)
            a = md5_gg(a, b, c, d, unwrap(x[i + 13]), 5 , -1444681467)
            d = md5_gg(d, a, b, c, unwrap(x[i + 2]), 9 , -51403784)
            c = md5_gg(c, d, a, b, unwrap(x[i + 7]), 14,  1735328473)
            b = md5_gg(b, c, d, a, unwrap(x[i + 12]), 20, -1926607734)
            
            a = md5_hh(a, b, c, d, unwrap(x[i + 5]), 4 , -378558)
            d = md5_hh(d, a, b, c, unwrap(x[i + 8]), 11, -2022574463)
            c = md5_hh(c, d, a, b, unwrap(x[i + 11]), 16,  1839030562)
            b = md5_hh(b, c, d, a, unwrap(x[i + 14]), 23, -35309556)
            a = md5_hh(a, b, c, d, unwrap(x[i + 1]), 4 , -1530992060)
            d = md5_hh(d, a, b, c, unwrap(x[i + 4]), 11,  1272893353)
            c = md5_hh(c, d, a, b, unwrap(x[i + 7]), 16, -155497632)
            b = md5_hh(b, c, d, a, unwrap(x[i + 10]), 23, -1094730640)
            a = md5_hh(a, b, c, d, unwrap(x[i + 13]), 4 ,  681279174)
            d = md5_hh(d, a, b, c, unwrap(x[i + 0]), 11, -358537222)
            c = md5_hh(c, d, a, b, unwrap(x[i + 3]), 16, -722521979)
            b = md5_hh(b, c, d, a, unwrap(x[i + 6]), 23,  76029189)
            a = md5_hh(a, b, c, d, unwrap(x[i + 9]), 4 , -640364487)
            d = md5_hh(d, a, b, c, unwrap(x[i + 12]), 11, -421815835)
            c = md5_hh(c, d, a, b, unwrap(x[i + 15]), 16,  530742520)
            b = md5_hh(b, c, d, a, unwrap(x[i + 2]), 23, -995338651)
            
            a = md5_ii(a, b, c, d, unwrap(x[i + 0]), 6 , -198630844)
            d = md5_ii(d, a, b, c, unwrap(x[i + 7]), 10,  1126891415)
            c = md5_ii(c, d, a, b, unwrap(x[i + 14]), 15, -1416354905)
            b = md5_ii(b, c, d, a, unwrap(x[i + 5]), 21, -57434055)
            a = md5_ii(a, b, c, d, unwrap(x[i + 12]), 6 ,  1700485571)
            d = md5_ii(d, a, b, c, unwrap(x[i + 3]), 10, -1894986606)
            c = md5_ii(c, d, a, b, unwrap(x[i + 10]), 15, -1051523)
            b = md5_ii(b, c, d, a, unwrap(x[i + 1]), 21, -2054922799)
            a = md5_ii(a, b, c, d, unwrap(x[i + 8]), 6 ,  1873313359)
            d = md5_ii(d, a, b, c, unwrap(x[i + 15]), 10, -30611744)
            c = md5_ii(c, d, a, b, unwrap(x[i + 6]), 15, -1560198380)
            b = md5_ii(b, c, d, a, unwrap(x[i + 13]), 21,  1309151649)
            a = md5_ii(a, b, c, d, unwrap(x[i + 4]), 6 , -145523070)
            d = md5_ii(d, a, b, c, unwrap(x[i + 11]), 10, -1120210379)
            c = md5_ii(c, d, a, b, unwrap(x[i + 2]), 15,  718787259)
            b = md5_ii(b, c, d, a, unwrap(x[i + 9]), 21, -343485551)
            
            a = safe_add(a, olda)
            b = safe_add(b, oldb)
            c = safe_add(c, oldc)
            d = safe_add(d, oldd)
        }
        
        return [a, b, c, d]
    }
    
    // MARK: - Helper
    
    private func length(dictionary: [Int: Int32]) -> Int {
        return (dictionary.keys.maxElement() ?? 0) + 1
    }
    
    private func dictionary2array(dictionary: [Int: Int32]) -> [Int32] {
        var array = Array<Int32>(count: dictionary.keys.count, repeatedValue: 0)
        
        for i in Array(dictionary.keys).sort() {
            array[i] = unwrap(dictionary[i])
        }
        
        return array
    }
    
    private func unwrap(value: Int32?, _ fallback: Int32 = 0) -> Int32 {
        if let value = value {
            return value
        }
        
        return fallback
    }
    
    private func zeroFillRightShift(num: Int32, _ count: Int32) -> Int32 {
        let value = UInt32(bitPattern: num) >> UInt32(bitPattern: count)
        return Int32(bitPattern: value)
    }
}
