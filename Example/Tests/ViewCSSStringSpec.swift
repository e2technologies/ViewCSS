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
        
        describe("#parseStyle") {
            it("parses the parameters from a string") {
                let parsed = "background-color : red; text-align : right ;   ;;;  border-radius: 2px".parseStyle()
                expect(parsed["background-color"]).to(equal("red"))
                expect(parsed["text-align"]).to(equal("right"))
                expect(parsed["border-radius"]).to(equal("2px"))
            }
        }
        
        describe("#extractAttributes") {
            it("extracts the tag") {
                var count = 0
                "span".extractAttributes(tagCallback: { (tag: String) in
                    expect(tag).to(equal("span"))
                    count += 1
                }, attributeCallback: { (name: String, attribute: String) in
                    count += 1
                })
                expect(count).to(equal(1))
            }
            
            it("extracts the tag with a leading/trailing space") {
                var count = 0
                " span ".extractAttributes(tagCallback: { (tag: String) in
                    expect(tag).to(equal("span"))
                    count += 1
                }, attributeCallback: { (name: String, attribute: String) in
                    count += 1
                })
                expect(count).to(equal(1))
            }
            
            it("extracts the tag with an attribute") {
                var count = 0
                " span class=\"temp1 temp2\"".extractAttributes(tagCallback: { (tag: String) in
                    expect(tag).to(equal("span"))
                    count += 1
                }, attributeCallback: { (name: String, attribute: String) in
                    expect(name).to(equal("class"))
                    expect(attribute).to(equal("temp1 temp2"))
                    count += 1
                })
                expect(count).to(equal(2))
            }
            
            it("extracts the tag with 2 attributes") {
                var count = 0
                " span class=\"temp1 temp2\" style=\"background-color:red;\"".extractAttributes(tagCallback: { (tag: String) in
                    expect(tag).to(equal("span"))
                    count += 1
                }, attributeCallback: { (name: String, attribute: String) in
                    if count == 1 {
                        expect(name).to(equal("class"))
                        expect(attribute).to(equal("temp1 temp2"))
                    }
                    if count == 2 {
                        expect(name).to(equal("style"))
                        expect(attribute).to(equal("background-color:red;"))
                    }
                    count += 1
                })
                expect(count).to(equal(3))
            }
        }
        
        describe("#extractTags") {
            it("reads out a string with no tags") {
                var count = 0
                "This is some text".extractTags() { (text: String?, tag: String?, attributes: Dictionary<String, String>) in
                    if count == 0 {
                        expect(text).to(equal("This is some text"))
                        expect(tag).to(beNil())
                        expect(attributes).to(beEmpty())
                    }
                    count += 1
                }
                expect(count).to(equal(1))
            }
            
            it("reads out a string with a single terminated tag") {
                var count = 0
                "This is <br/>some text".extractTags() { (text: String?, tag: String?, attributes: Dictionary<String, String>) in
                    if count == 0 {
                        expect(text).to(equal("This is "))
                        expect(tag).to(beNil())
                        expect(attributes).to(beEmpty())
                    }
                    else if count == 1 {
                        expect(text).to(beNil())
                        expect(tag).to(equal("br"))
                        expect(attributes).to(beEmpty())
                    }
                    else if count == 2 {
                        expect(text).to(equal("some text"))
                        expect(tag).to(beNil())
                        expect(attributes).to(beEmpty())
                    }
                    count += 1
                }
                expect(count).to(equal(3))
            }
            
            it("reads out a single span") {
                var count = 0
                "This is <span>some</span> text".extractTags() { (text: String?, tag: String?, attributes: Dictionary<String, String>) in
                    if count == 0 {
                        expect(text).to(equal("This is "))
                        expect(tag).to(beNil())
                        expect(attributes).to(beEmpty())
                    }
                    else if count == 1 {
                        expect(text).to(equal("some"))
                        expect(tag).to(equal("span"))
                        expect(attributes).to(beEmpty())
                    }
                    else if count == 2 {
                        expect(text).to(equal(" text"))
                        expect(tag).to(beNil())
                        expect(attributes).to(beEmpty())
                    }
                    count += 1
                }
                expect(count).to(equal(3))
            }
            
            it("reads out a single span with attributes") {
                var count = 0
                "This is <span class=\"label\">some</span> text".extractTags() { (text: String?, tag: String?, attributes: Dictionary<String, String>) in
                    if count == 0 {
                        expect(text).to(equal("This is "))
                        expect(tag).to(beNil())
                        expect(attributes).to(beEmpty())
                    }
                    else if count == 1 {
                        expect(text).to(equal("some"))
                        expect(tag).to(equal("span"))
                        expect(attributes).to(equal(["class":"label"]))
                    }
                    else if count == 2 {
                        expect(text).to(equal(" text"))
                        expect(tag).to(beNil())
                        expect(attributes).to(beEmpty())
                    }
                    count += 1
                }
                expect(count).to(equal(3))
            }
            
            it("reads out a miltiple tags with multiple attributes") {
                var count = 0
                "This is <span class=\"label\">some</span> <a href=\"http://www.example.com\">text</a>".extractTags() { (text: String?, tag: String?, attributes: Dictionary<String, String>) in
                    if count == 0 {
                        expect(text).to(equal("This is "))
                        expect(tag).to(beNil())
                        expect(attributes).to(beEmpty())
                    }
                    else if count == 1 {
                        expect(text).to(equal("some"))
                        expect(tag).to(equal("span"))
                        expect(attributes).to(equal(["class":"label"]))
                    }
                    else if count == 2 {
                        expect(text).to(equal(" "))
                        expect(tag).to(beNil())
                        expect(attributes).to(beEmpty())
                    }
                    else if count == 3 {
                        expect(text).to(equal("text"))
                        expect(tag).to(equal("a"))
                        expect(attributes).to(equal(["href":"http://www.example.com"]))
                    }
                    count += 1
                }
                expect(count).to(equal(4))
            }
        }
    }

}
