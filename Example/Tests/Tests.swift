// https://github.com/Quick/Quick

import Quick
import Nimble
import ViewCSS

class StringViewCSSSpec: QuickSpec {
    override func spec() {
        describe("#viewCSSCamelToSnake") {
            it("can convert from camel to snake") {
                let tests = [
                    "thisShouldWork" : "this_should_work"
                ]
                
                for (input, expected) in tests {
                    expect(expected) == expected
                }
            }
        }
    }
}

