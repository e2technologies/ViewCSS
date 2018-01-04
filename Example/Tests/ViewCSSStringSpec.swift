import Quick
import Nimble
@testable import ViewCSS

class ViewCSSStringSpec: QuickSpec {
    override func spec() {
        describe("#camelToSnake") {
            it("converts camel to snake") {
                expect("thisIsSomeString".camelToSnake).to(equal("this_is_some_string"))
            }
            it("handles 2 capitals in a row") {
                expect("thisIsAString".camelToSnake).to(equal("this_is_a_string"))
            }
            it("handles multiple capitals in a row") {
                expect("thisIsCSSString".camelToSnake).to(equal("this_is_css_string"))
            }
            it("handles multiple capitals at the beginning") {
                expect("CSSThisIsString".camelToSnake).to(equal("css_this_is_string"))
            }
            it("handles multiple capitals at the end") {
                expect("thisIsStringCSS".camelToSnake).to(equal("this_is_string_css"))
            }
        }
        
        describe("#hexToFloat") {
            it("converts hex to a float") {
                expect("15".hexToFloat).to(equal(CGFloat(21)))
            }
            it("ignores a non-hex number") {
                expect("anm".hexToFloat).to(beNil())
            }
        }
        
        describe("#percentageToFloat") {
            it("converts % to a float") {
                expect("15%".percentageToFloat).to(equal(CGFloat(0.15)))
            }
            it("ignores a non-% number") {
                expect("20".percentageToFloat).to(beNil())
                expect("20px".percentageToFloat).to(beNil())
            }
        }
        
        describe("#lengthToFloat") {
            it("converts px to a float") {
                expect("15px".lengthToFloat).to(equal(CGFloat(15)))
            }
            it("ignores a non-px number") {
                expect("20".lengthToFloat).to(beNil())
                expect("20%".lengthToFloat).to(beNil())
            }
        }
        
        describe("#numberToFloat") {
            it("converts number to a float") {
                expect("15".numberToFloat).to(equal(CGFloat(15)))
            }
            it("ignores a non number") {
                expect("20px".numberToFloat).to(beNil())
                expect("20%".numberToFloat).to(beNil())
            }
        }
        
        describe("#valueOfHex") {
            it("returns a hex substring and converts it") {
                expect("1513".valueOfHex(start: 0, length: 2)).to(equal(CGFloat(21)))
                expect("1513".valueOfHex(start: 2, length: 2)).to(equal(CGFloat(19)))
                expect("1513".valueOfHex(start: 0, length: 3)).to(equal(CGFloat(337)))
            }
            it("ignores a non hex number") {
                expect("15k3".valueOfHex(start: 0, length: 3)).to(beNil())
            }
            it("ignores a start + length value that is greater than the bounds") {
                expect("1513".valueOfHex(start: 2, length: 3)).to(beNil())
            }
            it("ignores a start value that is below 0") {
                expect("1513".valueOfHex(start: -2, length: 3)).to(beNil())
            }
            it("ignores a start value value that is greater than the bounds") {
                expect("1513".valueOfHex(start: 5, length: 3)).to(beNil())
            }
        }
    }

}
