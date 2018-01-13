import Quick
import Nimble
@testable import ViewCSS

class ViewCSSTextConfigSpec: QuickSpec {
    override func spec() {
        
        let color = UIColor(css: "black")!

        describe("#text-align") {
            let custom = [
                "center" : NSTextAlignment.center,
                "left" : NSTextAlignment.left,
                "right" : NSTextAlignment.right,
                "justify" : NSTextAlignment.justified
            ]
            ViewCSSTypeHelper.test(name: "align", types: [.custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSTextConfig(css: ["text-align": value])
                return config.align
            }, custom: custom)
        }
        
        describe("#text-transform") {
            let custom = [
                "uppercase" : ViewCSSTextConfig.Transform.uppercase,
                "lowercase" : ViewCSSTextConfig.Transform.lowercase,
                "capitalize" : ViewCSSTextConfig.Transform.capitalize,
            ]
            ViewCSSTypeHelper.test(name: "transform", types: [.custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSTextConfig(css: ["text-transform": value])
                return config.transform
            }, custom: custom)
        }
        
        describe("#text-overflow") {
            let custom = [
                "clip" : NSLineBreakMode.byClipping,
                "ellipsis" : NSLineBreakMode.byTruncatingTail,
                ]
            ViewCSSTypeHelper.test(name: "overflow", types: [.custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSTextConfig(css: ["text-overflow": value])
                return config.overflow
            }, custom: custom)
        }
        
        describe("#text-decoration-line") {
            let custom = [
                "overline" : ViewCSSTextConfig.DecorationLine.overline,
                "underline" : ViewCSSTextConfig.DecorationLine.underline,
                "line-through" : ViewCSSTextConfig.DecorationLine.line_through,
                ]
            ViewCSSTypeHelper.test(name: "decoration line", types: [.custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSTextConfig(css: ["text-decoration-line": value])
                return config.decorationLine
            }, custom: custom)
        }
        
        describe("#text-decoration-style") {
            let custom = [
                "solid" : NSUnderlineStyle.styleSingle,
                "double" : NSUnderlineStyle.styleDouble,
                "dotted" : NSUnderlineStyle.patternDot,
                "dashed" : NSUnderlineStyle.patternDash,
                ]
            ViewCSSTypeHelper.test(name: "decoration style", types: [.custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSTextConfig(css: ["text-decoration-style": value])
                return config.decorationStyle
            }, custom: custom)
        }
        
        describe("#text-decoration-color") {
            ViewCSSTypeHelper.test(name: "decoration color", types: [.color], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSTextConfig(css: ["text-decoration-color": value])
                return config.decorationColor
            })
        }
        
        describe("#text-shadow") {
            it("test shadow") {
                let css = ["text-shadow" : "5px 6px 10px " + color.toCSS]
                let config = ViewCSSTextConfig(css: css)
                expect(config.shadow!.hShadow).to(equal(5))
                expect(config.shadow!.vShadow).to(equal(6))
                expect(config.shadow!.radius).to(equal(10))
                expect(config.shadow!.color!.toCSS).to(equal(color.toCSS))
                expect(config.shadow!.opacity).to(equal(1.0))
            }
            
            it("test shadow opacity override") {
                let css = ["text-shadow-opacity" : "0.5"]
                let config = ViewCSSTextConfig(css: css)
                expect(config.shadow!.opacity).to(equal(0.5))
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
                        button.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
                    }
                    else if let label = view as? UILabel {
                        label.textAlignment = .right
                        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
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
                    if let _ = view as? UIButton {
                        expect(css["text-overflow"]).to(equal("ellipsis"))
                    }
                    else if let _ = view as? UILabel {
                        expect(css["text-overflow"]).to(equal("ellipsis"))
                    }
                    else {
                        expect(css["text-overflow"]).to(beNil())
                    }
                }
            })
        }
    }
}
