import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// A library with helper functions to work with strings.
public struct Texte {

    /// TitleWithPath is a model for a link.
    ///
    /// It is constructed from two stored properties. A `title` and a `path` to a location of a resource.
    /// It also provides a URL to the location of a resouce.
    public struct TitleWithPath: Equatable {
        let title: String
        let path: String
        var url: URL? {
            URL(string: path)
        }
    }

    /// Initializer to make an instance of Texte. Texte does not need any configuration. 
    public init() {}

    /// Makes an array of link models from a string array. Makes sure that all the paths have prefix.
    ///
    /// - Parameters:
    ///   - stringArray: Array of strings that are converted to link models
    ///   - prefix: Prefix for link paths
    /// - Returns: An array of link models
    public func makeTitlesWithPaths(_ stringArray: [String], withPrefix prefix: String = "https://") -> [TitleWithPath] {
        return stringArray.map {
            TitleWithPath(title: $0, path: $0.pathPrefix(prefix))
        }
    }

    /// Converts a string to an `NSMutableAttributedString`. Creates clickable links from a URL like texts, e.g. example.fi/page.
    ///
    /// - Parameters:
    ///   - pattern: RegEx pattern that is used to search URL like ranges from the string
    ///   - text: A text that is converted
    ///   - urlPrefix: A prefix that's used for all the URLs
    ///   - attributes: Attributes for the `NSMutableAttributedString`
    ///   - linkAttributes: Attributes for styling the links
    /// - Returns: `NSMutableAttributedString` with clickable links
    public func attributedTextWithURLsMatching(_ pattern: String,
                                               from text: String,
                                               urlPrefix: String = "https://",
                                               attributes: [NSMutableAttributedString.Key: Any]? = nil,
                                               linkAttributes: [NSMutableAttributedString.Key: Any]? = nil) -> NSMutableAttributedString {

        let attrString = NSMutableAttributedString(string: text, attributes: attributes)

        let linkTexts = text.findWith(pattern)

        let titlesWithPaths = makeTitlesWithPaths(linkTexts, withPrefix: urlPrefix)

        for titleWithPath in titlesWithPaths {
            guard let url = titleWithPath.url else { continue }
            let range = attrString.mutableString.range(of: titleWithPath.title)
            if range.location != NSNotFound {
                var attr: [NSMutableAttributedString.Key: Any] = [
                    .link: url]

                if let linkAttributes = linkAttributes {
                    for (key, value) in linkAttributes {
                        attr[key] = value
                    }
                }

                attrString.addAttributes(attr, range: range)
            }
        }
        return attrString
    }
}

