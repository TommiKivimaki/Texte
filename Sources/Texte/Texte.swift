import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct Texte {
    public struct TitleWithPath: Equatable {
        let title: String
        let path: String
        var url: URL? {
            URL(string: path)
        }
    }

    public init() {}

    public func makeTitlesWithPaths(_ stringArray: [String], withPrefix prefix: String) -> [TitleWithPath] {
        return stringArray.map {
            TitleWithPath(title: $0, path: $0.pathPrefix(prefix))
        }
    }

    public func attributedTextWithURLsMatching(_ pattern: String, from text: String, urlPrefix: String) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: text)
        let linkTexts = text.findWith(pattern)
        let titlesWithPaths = makeTitlesWithPaths(linkTexts, withPrefix: urlPrefix)

        for titleWithPath in titlesWithPaths {
            guard let url = titleWithPath.url else { continue }
            let range = attrString.mutableString.range(of: titleWithPath.title)
            if range.location != NSNotFound {
                let attributes = [NSMutableAttributedString.Key.link: url]
                attrString.addAttributes(attributes, range: range)
            }
        }
        return attrString
    }
}

