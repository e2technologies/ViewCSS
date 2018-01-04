import Quick
import Nimble
@testable import ViewCSS

class ViewCSSTypeHelper {

    enum PropertyType {
        case color
        case number
        case length
        case percentage
    }
    
    static func test(name: String, types: [PropertyType], routine: @escaping (String) -> (Any?)) {
        for type in types {
            
            // *color* type
            if type == .color {
                
                it(name + " parses the color by name") {
                    let result = routine("red")
                    expect(result).to(beAnInstanceOf(UIColor.self))
                    expect((result as! UIColor).toCSS).to(equal("#FF0000FF"))
                }
                
                it(name + " supports variabled color") {
                    let css = [":root" : ["--color": "red"]]
                    ViewCSSManager.shared.setCSS(dict: css)
                    let result = routine("var(--color)")
                    expect(result).to(beAnInstanceOf(UIColor.self))
                    expect((result as! UIColor).toCSS).to(equal("#FF0000FF"))
                }
                
                it(name + " parses the color by rgb function") {
                    let result = routine("rgb(255, 255, 255")
                    expect(result).to(beAnInstanceOf(UIColor.self))
                    expect((result as! UIColor).toCSS).to(equal("#FF0000FF"))
                }
                
                it(name + " parses the color by rgb function with alpha") {
                    let result = routine("rgb(255, 255, 255, 127")
                    expect(result).to(beAnInstanceOf(UIColor.self))
                    expect((result as! UIColor).toCSS).to(equal("#FF00007F"))
                }
                
                it(name + " parses the color by value") {
                    let result = routine("#00FF00FF")
                    expect(result).to(beAnInstanceOf(UIColor.self))
                    expect((result as! UIColor).toCSS).to(equal("#00FF00FF"))
                }
                
                it(name + " parses the color by name (transparent)") {
                    let result = routine("transparent")
                    expect(result).to(beAnInstanceOf(UIColor.self))
                    expect((result as! UIColor).toCSS).to(equal("#00000000"))
                }
            }
            else if type == .number {
                it(name + " parses the number") {
                    let result = routine("0.5")
                    expect(result).to(beAnInstanceOf(CGFloat.self))
                    expect((result as! CGFloat)).to(equal(CGFloat(0.5)))
                }
                
                it(name + " supports variabled number") {
                    let css = [":root" : ["--number": "0.5"]]
                    ViewCSSManager.shared.setCSS(dict: css)
                    let result = routine("var(--number)")
                    expect(result).to(beAnInstanceOf(CGFloat.self))
                    expect((result as! CGFloat)).to(equal(CGFloat(0.5)))
                }
                
                it(name + " ignores the number if it has a %") {
                    let result = routine("50%")
                    expect(result).to(beNil())
                }
                
                it(name + " ignores the number if it has a px") {
                    let result = routine("5px")
                    expect(result).to(beNil())
                }
            }
            else if type == .length {
                it(name + " parses the length") {
                    let result = routine("5px")
                    expect(result).to(beAnInstanceOf(CGFloat.self))
                    expect((result as! CGFloat)).to(equal(CGFloat(5)))
                }
                
                it(name + " supports variabled length") {
                    let css = [":root" : ["--length": "5px"]]
                    ViewCSSManager.shared.setCSS(dict: css)
                    let result = routine("var(--length)")
                    expect(result).to(beAnInstanceOf(CGFloat.self))
                    expect((result as! CGFloat)).to(equal(CGFloat(5)))
                }
                
                it(name + " ignores the number if it has no px") {
                    let result = routine("5")
                    expect(result).to(beNil())
                }
                
                it(name + " ignores the number if it has a %") {
                    let result = routine("5%")
                    expect((result as! CGFloat)).to(beNil())
                }
            }
            else if type == .percentage {
                it(name + " parses the percentage") {
                    let result = routine("50%")
                    expect(result).to(beAnInstanceOf(CGFloat.self))
                    expect((result as! CGFloat)).to(equal(CGFloat(0.5)))
                }
                
                it(name + " supports variabled percentage") {
                    let css = [":root" : ["--percentage": "50%"]]
                    ViewCSSManager.shared.setCSS(dict: css)
                    let result = routine("var(--percentage)")
                    expect(result).to(beAnInstanceOf(CGFloat.self))
                    expect((result as! CGFloat)).to(equal(CGFloat(0.5)))
                }
                
                it(name + " ignores the number if it has no %") {
                    let result = routine("5")
                    expect(result).to(beNil())
                }
                
                it(name + " ignores the number if it has a px") {
                    let result = routine("5px")
                    expect(result).to(beNil())
                }
            }
        }
    }
}
