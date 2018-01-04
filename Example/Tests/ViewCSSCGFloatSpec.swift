import Quick
import Nimble
@testable import ViewCSS

class ViewCSSCGFloatSpec: QuickSpec {
    override func spec() {
        describe("#toCSS") {
            it("converts to a CSS string") {
                expect(CGFloat(5.50400).toCSS).to(equal("5.504"))
            }
        }
        
        describe("#toPX") {
            it("converts value to px") {
                expect(CGFloat(5).toPX).to(equal("5px"))
            }
            it("rounds the converted value") {
                expect(CGFloat(5.50400).toPX).to(equal("6px"))
            }
        }
    }
}
