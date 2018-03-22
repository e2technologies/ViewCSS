import Quick
import Nimble
@testable import ViewCSS

class ViewCSSViewProtocolHelper {
    static func iterate(callback: (UIView.Type)->()) {
        let klasses: [UIView.Type] = [UIView.self, UILabel.self, UITextField.self, UITextView.self, UIButton.self]
        for klass in klasses {
            callback(klass)
        }
    }
}

class ViewCSSShadowProtocolHelper {
    static func iterate(callback: (UIView.Type)->()) {
        let klasses: [UIView.Type] = [UILabel.self, UITextField.self, UITextView.self, UIButton.self]
        for klass in klasses {
            callback(klass)
        }
    }
}

class ViewCSSTextProtocolHelper {
    static func iterate(callback: (UIView.Type)->()) {
        let klasses: [UIView.Type] = [UILabel.self, UITextField.self, UITextView.self, UIButton.self]
        for klass in klasses {
            callback(klass)
        }
    }
}

class ViewCSSGenerateCSSTextProtocolHelper {
    static func iterate(callback: (UIView.Type)->()) {
        let klasses: [UIView.Type] = [UILabel.self, UITextView.self, UIButton.self]
        for klass in klasses {
            callback(klass)
        }
    }
}

class ViewCSSTypeHelper {
    
    static func test(
        name: String,
        types: [ViewCSSBaseConfig.PropertyType],
        routine: @escaping (String, ViewCSSBaseConfig.PropertyType) -> (Any?),
        custom: Dictionary<String, Any>?=nil) {
        
        for type in types {
            
            // *color* type
            if type == .color {
                
                it(name + " parses the color by name") {
                    let result = routine("red", type)
                    expect(result).to(beAKindOf(UIColor.self))
                    expect((result as! UIColor).toCSS).to(equal("#FF0000FF"))
                }
                
                it(name + " supports variabled color") {
                    let css = [":root" : ["--color": "red"]]
                    ViewCSSManager.shared.setCSS(dict: css)
                    let result = routine("var(--color)", type)
                    expect(result).to(beAKindOf(UIColor.self))
                    expect((result as! UIColor).toCSS).to(equal("#FF0000FF"))
                }
                
                it(name + " parses the color by rgb function") {
                    let result = routine("rgb(255, 0, 255)", type)
                    expect(result).to(beAKindOf(UIColor.self))
                    expect((result as! UIColor).toCSS).to(equal("#FF00FFFF"))
                }
                
                it(name + " parses the color by rgb function with alpha") {
                    let result = routine("rgb(255, 255, 0, 127)", type)
                    expect(result).to(beAKindOf(UIColor.self))
                    expect((result as! UIColor).toCSS).to(equal("#FFFF007F"))
                }
                
                it(name + " parses the color by value") {
                    let result = routine("#00FF00FF", type)
                    expect(result).to(beAKindOf(UIColor.self))
                    expect((result as! UIColor).toCSS).to(equal("#00FF00FF"))
                }
                
                it(name + " parses the color by name (transparent)") {
                    let result = routine("transparent", type)
                    expect(result).to(beAKindOf(UIColor.self))
                    expect((result as! UIColor).toCSS).to(equal("#00000000"))
                }
            }
            else if type == .number {
                it(name + " parses the number") {
                    let result = routine("0.5", type)
                    expect(result).to(beAKindOf(CGFloat.self))
                    expect((result as? CGFloat)).to(equal(CGFloat(0.5)))
                }
                
                it(name + " supports variabled number") {
                    let css = [":root" : ["--number": "0.5"]]
                    ViewCSSManager.shared.setCSS(dict: css)
                    let result = routine("var(--number)", type)
                    expect(result).to(beAKindOf(CGFloat.self))
                    expect((result as? CGFloat)).to(equal(CGFloat(0.5)))
                }
                
                if !types.contains(.percentage) {
                    it(name + " ignores the number if it has a %") {
                        let result = routine("50%", type)
                        expect(result).to(beNil())
                    }
                }
                
                if !types.contains(.length) {
                    it(name + " ignores the number if it has a px") {
                        let result = routine("5px", type)
                        expect(result).to(beNil())
                    }
                }
            }
            else if type == .length {
                it(name + " parses the length") {
                    let result = routine("5px", type)
                    expect(result).to(beAKindOf(CGFloat.self))
                    expect((result as? CGFloat)).to(equal(CGFloat(5)))
                }
                
                it(name + " supports variabled length") {
                    let css = [":root" : ["--length": "5px"]]
                    ViewCSSManager.shared.setCSS(dict: css)
                    let result = routine("var(--length)", type)
                    expect(result).to(beAKindOf(CGFloat.self))
                    expect((result as? CGFloat)).to(equal(CGFloat(5)))
                }
                
                if !types.contains(.number) {
                    it(name + " ignores the number if it has no px") {
                        let result = routine("5", type)
                        expect(result).to(beNil())
                    }
                }
                
                if !types.contains(.percentage) {
                    it(name + " ignores the number if it has a %") {
                        let result = routine("5%", type)
                        expect((result)).to(beNil())
                    }
                }
            }
            else if type == .percentage {
                it(name + " parses the percentage") {
                    let result = routine("50%", type)
                    expect(result).to(beAKindOf(CGFloat.self))
                    expect((result as? CGFloat)).to(equal(CGFloat(0.5)))
                }
                
                it(name + " supports variabled percentage") {
                    let css = [":root" : ["--percentage": "50%"]]
                    ViewCSSManager.shared.setCSS(dict: css)
                    let result = routine("var(--percentage)", type)
                    expect(result).to(beAKindOf(CGFloat.self))
                    expect((result as? CGFloat)).to(equal(CGFloat(0.5)))
                }
                
                if !types.contains(.number) {
                    it(name + " ignores the number if it has no %") {
                        let result = routine("5", type)
                        expect(result).to(beNil())
                    }
                }
                
                if !types.contains(.length) {
                    it(name + " ignores the number if it has a px") {
                        let result = routine("5px", type)
                        expect(result).to(beNil())
                    }
                }
            }
            else if type == .custom {
                if custom != nil {
                    for (string, expected) in custom! {
                        it(name + " handles custom value " + string) {
                            let result = routine(string, type)
                            
                            if result == nil {
                                expect(result).notTo(beNil())
                            }
                            
                            if let newResult = result as? CGFloat {
                                expect(newResult).to(equal(expected as? CGFloat))
                            }
                            else if let newResult = result as? String {
                                expect(newResult).to(equal(expected as? String))
                            }
                            else if let newResult = result as? UIColor {
                                expect(newResult.toCSS).to(equal((expected as? UIColor)?.toCSS))
                            }
                            else if let newResult = result as? UIFont.Weight {
                                expect(newResult).to(equal(expected as? UIFont.Weight))
                            }
                            else if let newResult = result as? CGSize {
                                expect(newResult).to(equal(expected as? CGSize))
                            }
                            else if let newResult = result as? NSTextAlignment {
                                expect(newResult).to(equal(expected as? NSTextAlignment))
                            }
                            else if let newResult = result as? NSLineBreakMode {
                                expect(newResult).to(equal(expected as? NSLineBreakMode))
                            }
                            else if let newResult = result as? ViewCSSTextConfig.Transform {
                                expect(newResult).to(equal(expected as? ViewCSSTextConfig.Transform))
                            }
                            else if let newResult = result as? ViewCSSTextConfig.DecorationLine {
                                expect(newResult).to(equal(expected as? ViewCSSTextConfig.DecorationLine))
                            }
                            else if let newResult = result as? NSUnderlineStyle {
                                expect(newResult).to(equal(expected as? NSUnderlineStyle))
                            }
                            else {
                                // Trigger an error for unexpected values
                                expect(false).to(equal(true))
                            }
                        }
                    }
                }
                else {
                    // TODO: Some Error.  They said custom was supported
                }
            }
        }
    }
}
