import Quick
import Nimble
@testable import ViewCSS

class ViewCSSGenerateCSSTextProtocolSpec: QuickSpec {
    let manager = ViewCSSManager.shared

    override func spec() {
        ViewCSSGenerateCSSTextProtocolHelper.iterate { (klass:  UIView.Type) in
            let object = NSObject()
            var view = klass.init() as! ViewCSSGenerateCSSTextProtocol
            let spanText = "some <span class=\"color\">stuff</span>"
            let linkText = "some <a class=\"color\" href=\"https://www.example.com\">stuff</a>"
            let expectedText = "some stuff"
            
            beforeEach {
                let css = [
                    "ns_object.view" : ["background-color" : "red", "color" : "#00FF00FF"],
                    ".color" : ["color" : "#0000FFFF"],
                    ]
                self.manager.setCSS(dict: css)
                object.css(object: view, class: "view")
            }
            
            describe("#cssText") {
                it("sets span text") {
                    view.cssText = spanText
                    expect(view.cssText).to(equal(expectedText))
                }
                
                it("sets link text") {
                    view.cssText = linkText
                    expect(view.cssText).to(equal(expectedText))
                }
            }
            
            describe("#generateCSSText") {
                it("returns the attributed span text from the object") {
                    let generatedText = view.generateCSSText(text: spanText)
                    expect(generatedText!.string).to(equal(expectedText))
                    
                    let attributes = generatedText!.attributes(at: 0, effectiveRange: nil)
                    expect(attributes.count).to(equal(2))
                    expect((attributes[NSAttributedStringKey.backgroundColor] as! UIColor).toCSS).to(equal("#FF0000FF"))
                    expect((attributes[NSAttributedStringKey.foregroundColor] as! UIColor).toCSS).to(equal("#00FF00FF"))
                    
                    let tagttributes = generatedText!.attributes(at: 5, effectiveRange: nil)
                    expect(tagttributes.count).to(equal(2))
                    expect((tagttributes[NSAttributedStringKey.backgroundColor] as! UIColor).toCSS).to(equal("#FF0000FF"))
                    expect((tagttributes[NSAttributedStringKey.foregroundColor] as! UIColor).toCSS).to(equal("#0000FFFF"))
                }
                
                it("returns the attributed link text from the object") {
                    let generatedText = view.generateCSSText(text: linkText)
                    expect(generatedText!.string).to(equal(expectedText))
                    
                    let attributes = generatedText!.attributes(at: 0, effectiveRange: nil)
                    expect(attributes.count).to(equal(2))
                    expect((attributes[NSAttributedStringKey.backgroundColor] as! UIColor).toCSS).to(equal("#FF0000FF"))
                    expect((attributes[NSAttributedStringKey.foregroundColor] as! UIColor).toCSS).to(equal("#00FF00FF"))
                    
                    let tagttributes = generatedText!.attributes(at: 5, effectiveRange: nil)
                    expect(tagttributes.count).to(equal(3))
                    expect((tagttributes[NSAttributedStringKey.backgroundColor] as! UIColor).toCSS).to(equal("#FF0000FF"))
                    expect((tagttributes[NSAttributedStringKey.foregroundColor] as! UIColor).toCSS).to(equal("#0000FFFF"))
                    expect((tagttributes[NSAttributedStringKey.link] as! String)).to(equal("https://www.example.com"))
                }
            }
        }
    }
}
