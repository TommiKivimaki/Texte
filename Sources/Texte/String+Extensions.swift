// Copyright © 10.11.2021 Tommi Kivimäki.

import Foundation

extension String {

    /// Adds a prefix to a string if it's missing
    /// - Parameter prefix: Prefix to be added
    /// - Returns: String with a prefix
    public func pathPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        } else {
            return "\(prefix)\(self)"
        }
    }

    /// Uses regex pattern to search sub-strings from a string
    /// - Parameter pattern: RegEx pattern
    /// - Returns: Array of strings matching the pattern
    public func findWith(_ pattern: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: self.utf16.count)
        let found = regex.matches(in: self, options: [], range: range)

        let nsRanges = found.map { $0.range }
        let swiftRanges = nsRanges.compactMap { Range($0, in: self) }
        let result = swiftRanges.map { String(self[$0]) }

        return result
    }
}
