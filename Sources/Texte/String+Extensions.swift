// Copyright © 10.11.2021 Tommi Kivimäki.

import Foundation

extension String {

    public func pathPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        } else {
            return "\(prefix)\(self)"
        }
    }

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
