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
        
        describe("#setTransform") {
            let custom = [
                "uppercase" : ViewCSSTextConfig.Transform.uppercase,
                "lowercase" : ViewCSSTextConfig.Transform.lowercase,
                "capitalize" : ViewCSSTextConfig.Transform.capitalize,
            ]
            ViewCSSTypeHelper.test(name: "transform", types: [.custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSTextConfig()
                config.setTransform(dict: ["text-transform": value])
                return config.transform
            }, custom: custom)
        }
        
        describe("#setOverflow") {
            let custom = [
                "clip" : NSLineBreakMode.byClipping,
                "ellipsis" : NSLineBreakMode.byTruncatingTail,
                ]
            ViewCSSTypeHelper.test(name: "overflow", types: [.custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSTextConfig()
                config.setOverflow(dict: ["text-overflow": value])
                return config.overflow
            }, custom: custom)
        }
        
        describe("#setDecorationLine") {
            let custom = [
                "overline" : ViewCSSTextConfig.DecorationLine.overline,
                "underline" : ViewCSSTextConfig.DecorationLine.underline,
                "line-through" : ViewCSSTextConfig.DecorationLine.line_through,
                ]
            ViewCSSTypeHelper.test(name: "decoration line", types: [.custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSTextConfig()
                config.setDecorationLine(dict: ["text-decoration-line": value])
                return config.decorationLine
            }, custom: custom)
        }
        
        describe("#setDecorationStyle") {
            let custom = [
                "solid" : NSUnderlineStyle.patternSolid,
                "double" : NSUnderlineStyle.styleDouble,
                "dotted" : NSUnderlineStyle.patternDot,
                "dashed" : NSUnderlineStyle.patternDash,
                ]
            ViewCSSTypeHelper.test(name: "decoration style", types: [.custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSTextConfig()
                config.setDecorationLine(dict: ["text-decoration-style": value])
                return config.decorationStyle
            }, custom: custom)
        }
        
        describe("#setDecorationColor") {
            ViewCSSTypeHelper.test(name: "decoration color", types: [.color], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSTextConfig()
                config.setDecorationColor(dict: ["text-decoration-color": value])
                return config.decorationColor
            })
        }
        
        describe("#fromCSS") {
            it("parses the text-align and the text-shadow") {
                let css = ["text-align" : "right", "text-shadow" : "5px 6px 10px " + color.toCSS,
                           "text-transform": "uppercase", "text-decoration-color" : "blue",
                           "text-decoration-style" : "dotted", "text-overflow" : "ellipsis"]
                let config = ViewCSSTextConfig.fromCSS(dict: css)
                expect(config.align).to(equal(NSTextAlignment.right))
                expect(config.overflow).to(equal(NSLineBreakMode.byTruncatingTail))
                expect(config.shadow!.hShadow).to(equal(5))
                expect(config.shadow!.vShadow).to(equal(6))
                expect(config.shadow!.radius).to(equal(10))
                expect(config.shadow!.color!.toCSS).to(equal(color.toCSS))
                expect(config.shadow!.opacity).to(equal(1.0))
                expect(config.transform).to(equal(ViewCSSTextConfig.Transform.uppercase))
                expect(config.decorationColor!.toCSS).to(equal("#0000FFFF"))
                expect(config.decorationStyle).to(equal(NSUnderlineStyle.patternDot))
            }
            
            it("parses the text-align, text-shadow, and the text-shadow-opacity") {
                let css = ["text-align" : "right", "text-shadow" : "5px 6px 10px " + color.toCSS,
                           "text-shadow-opacity" : "0.4", "text-decoration-line" : "underline"]
                let config = ViewCSSTextConfig.fromCSS(dict: css)
                expect(config.align).to(equal(NSTextAlignment.right))
                expect(config.shadow!.hShadow).to(equal(5))
                expect(config.shadow!.vShadow).to(equal(6))
                expect(config.shadow!.radius).to(equal(10))
                expect(config.shadow!.color!.toCSS).to(equal(color.toCSS))
                expect(config.shadow!.opacity).to(equal(0.4))
                expect(config.decorationLine).to(equal(ViewCSSTextConfig.DecorationLine.underline))
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
