import XCTest
@testable import Texte

final class TexteTests: XCTestCase {

    var texte: Texte!

    override func setUpWithError() throws {
        texte = Texte()
    }

    override func tearDownWithError() throws {
        texte = nil
    }

    func testPathPrefix() {
        let initialPath = "example.fi/page"
        let prefix = "https://"
        let expectedPath = "https://example.fi/page"

        XCTAssertEqual(initialPath.pathPrefix(prefix), expectedPath)
    }

    func testFindWith() {
        let text = "This is an example text with a link to example.fi/page web page."
        let pattern = "example.fi/[a-z]*"
        let expectedResult = "example.fi/page"

        let results = text.findWith(pattern)

        XCTAssertEqual(results, [expectedResult])
    }

    func testTitlePathMaking() {
        let array = ["example.fi/page", "example.fi/", "example.fi"]
        let prefix = "https://"
        let expectedResult = [
            Texte.TitleWithPath(title: "example.fi/page", path: "https://example.fi/page"),
            Texte.TitleWithPath(title: "example.fi/", path: "https://example.fi/"),
            Texte.TitleWithPath(title: "example.fi", path: "https://example.fi")
        ]

        let result = texte.makeTitlesWithPaths(array, withPrefix: prefix)

        XCTAssertEqual(result, expectedResult)

    }

    func testAttributedTextWithURLsMatching() {
        let reference = NSMutableAttributedString(string: "Link ")

        let url = URL(string: "https://example.fi/page")!
        let attributes = [NSMutableAttributedString.Key.link: url]
        let link = NSMutableAttributedString(string: "example.fi/page", attributes: attributes)
        let end = NSMutableAttributedString(string: ". End.")

        reference.append(link)
        reference.append(end)

        let pattern = "example.fi/[a-z]*"
        let prefix = "https://"
        let string = "Link example.fi/page. End."
        let result = texte.attributedTextWithURLsMatching([pattern],
                                                           from: string,
                                                           urlPrefix: prefix)

        XCTAssertEqual(result, reference)
    }
}
