import Quick
import Nimble
@testable import ViewCSS

class ViewCSSTextConfigSpec: QuickSpec {
    override func spec() {

        describe("#setAlign") {
            var config: ViewCSSTextConfig?
            beforeEach {
                config = ViewCSSTextConfig()
            }
            
            it("parses center") {
                let css = ["text-align" : "center"]
                config!.setAlign(dict: css)
                expect(config!.align).to(equal(NSTextAlignment.center))
            }
            it("parses left") {
                let css = ["text-align" : "left"]
                config!.setAlign(dict: css)
                expect(config!.align).to(equal(NSTextAlignment.left))
            }
            it("parses right") {
                let css = ["text-align" : "right"]
                config!.setAlign(dict: css)
                expect(config!.align).to(equal(NSTextAlignment.right))
            }
            it("parses justify") {
                let css = ["text-align" : "justify"]
                config!.setAlign(dict: css)
                expect(config!.align).to(equal(NSTextAlignment.justified))
            }
        }
        
        describe("#fromCSS") {
            it("parses the text-align and the text-shadow") {
                let css = ["text-align" : "right", "text-shadow" : "5px 6px 10px black"]
                let config = ViewCSSTextConfig.fromCSS(dict: css)
                expect(config.align).to(equal(NSTextAlignment.right))
                expect(config.shadow!.hShadow).to(equal(5))
                expect(config.shadow!.vShadow).to(equal(6))
                expect(config.shadow!.radius).to(equal(10))
                expect(config.shadow!.color!.toCSS).to(equal("#000000FF"))
                expect(config.shadow!.opacity).to(equal(1.0))
            }
            
            it("parses the text-align, text-shadow, and the text-shadow-opacity") {
                let css = ["text-align" : "right", "text-shadow" : "5px 6px 10px black", "text-shadow-opacity" : "0.4"]
                let config = ViewCSSTextConfig.fromCSS(dict: css)
                expect(config.align).to(equal(NSTextAlignment.right))
                expect(config.shadow!.hShadow).to(equal(5))
                expect(config.shadow!.vShadow).to(equal(6))
                expect(config.shadow!.radius).to(equal(10))
                expect(config.shadow!.color!.toCSS).to(equal("#000000FF"))
                expect(config.shadow!.opacity).to(equal(0.4))
            }
        }
        
        describe("#toCSS") {
            
            // Iterate through the different supported class type
            let klasses: [UIView.Type] = [UILabel.self, UITextField.self, UITextView.self, UIButton.self]
            for klass in klasses {
                let view = klass.init()
                let targetView: UIView
                if let button = view as? UIButton { targetView = button.titleLabel! }
                else { targetView = view }
                
                beforeEach {
                    /*targetView.layer.shadowOffset = CGSize(width: 2.0, height: 3.0)
                    targetView.layer.shadowColor = color.cgColor
                    targetView.layer.shadowRadius = 5.0
                    targetView.layer.shadowOpacity = 0.6*/
                }
                
            }
        }
    }
}
