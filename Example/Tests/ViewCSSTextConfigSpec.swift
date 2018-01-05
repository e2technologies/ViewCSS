import Quick
import Nimble
@testable import ViewCSS

class ViewCSSTextConfigSpec: QuickSpec {
    override func spec() {
        
        let color = UIColor(css: "black")!

        describe("#setAlign") {
            let custom = [
                "center" : NSTextAlignment.center,
                "left" : NSTextAlignment.left,
                "right" : NSTextAlignment.right,
                "justify" : NSTextAlignment.justified
            ]
            ViewCSSTypeHelper.test(name: "align", types: [.custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSTextConfig()
                config.setAlign(dict: ["text-align": value])
                return config.align
            }, custom: custom)
        }
        
        describe("#fromCSS") {
            it("parses the text-align and the text-shadow") {
                let css = ["text-align" : "right", "text-shadow" : "5px 6px 10px " + color.toCSS]
                let config = ViewCSSTextConfig.fromCSS(dict: css)
                expect(config.align).to(equal(NSTextAlignment.right))
                expect(config.shadow!.hShadow).to(equal(5))
                expect(config.shadow!.vShadow).to(equal(6))
                expect(config.shadow!.radius).to(equal(10))
                expect(config.shadow!.color!.toCSS).to(equal(color.toCSS))
                expect(config.shadow!.opacity).to(equal(1.0))
            }
            
            it("parses the text-align, text-shadow, and the text-shadow-opacity") {
                let css = ["text-align" : "right", "text-shadow" : "5px 6px 10px " + color.toCSS, "text-shadow-opacity" : "0.4"]
                let config = ViewCSSTextConfig.fromCSS(dict: css)
                expect(config.align).to(equal(NSTextAlignment.right))
                expect(config.shadow!.hShadow).to(equal(5))
                expect(config.shadow!.vShadow).to(equal(6))
                expect(config.shadow!.radius).to(equal(10))
                expect(config.shadow!.color!.toCSS).to(equal(color.toCSS))
                expect(config.shadow!.opacity).to(equal(0.4))
            }
        }
        
        describe("#toCSS") {
            
            ViewCSSTextProtocolHelper.iterate(callback: { (klass: UIView.Type) in
                let view = klass.init()
                let targetView: UIView
                if let button = view as? UIButton { targetView = button.titleLabel! }
                else { targetView = view }
                
                beforeEach {
                    targetView.layer.shadowOffset = CGSize(width: 2.0, height: 3.0)
                    targetView.layer.shadowColor = color.cgColor
                    targetView.layer.shadowRadius = 5.0
                    targetView.layer.shadowOpacity = 0.6
                    if let button = view as? UIButton {
                        button.contentHorizontalAlignment = .right
                    }
                    else if let label = view as? UILabel {
                        label.textAlignment = .right
                    }
                    else if let textView = view as? UITextView {
                        textView.textAlignment = .right
                    }
                    else if let textField = view as? UITextField {
                        textField.textAlignment = .right
                    }
                }
                
                it("prints the CSS for " + String(describing: klass)) {
                    let css = ViewCSSTextConfig.toCSS(object: targetView)
                    expect(css["text-shadow"]).to(equal("2px 3px 5px " + color.toCSS))
                    expect(css["text-shadow-opacity"]).to(equal("0.6"))
                    expect(css["text-align"]).to(equal("right"))
                }
            })
        }
    }
}
