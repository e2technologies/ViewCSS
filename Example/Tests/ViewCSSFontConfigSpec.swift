import Quick
import Nimble
@testable import ViewCSS

class ViewCSSFontConfigSpec: QuickSpec {
    override func spec() {

        describe("#setSize") {
            let custom = [
                "xx-small" : CGFloat(9),
                "x-small" : CGFloat(11),
                "small" : CGFloat(13),
                "medium" : CGFloat(15),
                "large" : CGFloat(17),
                "x-large" : CGFloat(19),
                "xx-large" : CGFloat(21),
            ]
            ViewCSSTypeHelper.test(name: "font size", types: [.percentage, .length, .custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSFontConfig()
                config.setSize(dict: ["font-size": value])
                if type == .percentage && config.size != nil {
                    return config.size!/15.0
                }
                else {
                    return config.size
                }
            }, custom: custom)
        }
        
        describe("#setScaleSizeMin") {
            ViewCSSTypeHelper.test(name: "font size scale min", types: [.percentage, .length, .number], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSFontConfig()
                config.setSizeScaleMin(dict: ["font-size-scale-min": value])
                if (type == .percentage || type == .number) && config.sizeScaleMin != nil {
                    return config.sizeScaleMin!/15.0
                }
                else {
                    return config.sizeScaleMin
                }
            })
        }
        
        describe("#setScaleSizeMax") {
            ViewCSSTypeHelper.test(name: "font size scale max", types: [.percentage, .length, .number], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSFontConfig()
                config.setSizeScaleMax(dict: ["font-size-scale-max": value])
                if (type == .percentage || type == .number) && config.sizeScaleMax != nil {
                    return config.sizeScaleMax!/15.0
                }
                else {
                    return config.sizeScaleMax
                }
            })
        }
        
        describe("#setWeight") {
            let custom = [
                "normal" : UIFont.Weight.regular,
                "bold" : UIFont.Weight.bold,
                "bolder" : UIFont.Weight.black,
                "lighter" : UIFont.Weight.thin,
                "100" : UIFont.Weight.ultraLight,
                "200" : UIFont.Weight.thin,
                "300" : UIFont.Weight.light,
                "400" : UIFont.Weight.regular,
                "500" : UIFont.Weight.medium,
                "600" : UIFont.Weight.semibold,
                "700" : UIFont.Weight.bold,
                "800" : UIFont.Weight.heavy,
                "900" : UIFont.Weight.black,
                ]
            ViewCSSTypeHelper.test(name: "font weight", types: [.custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSFontConfig()
                config.setWeight(dict: ["font-weight": value])
                return config.weight
            }, custom: custom)
        }
        
        describe("#setSizeScale") {
            let custom = [
                "auto" : CGFloat(-1.0), // -1 signals auto
                ]
            ViewCSSTypeHelper.test(name: "font size scale", types: [.number, .custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSFontConfig()
                config.setSizeScale(dict: ["font-size-scale": value])
                return config.sizeScale
            }, custom: custom)
        }
        
        describe("#scaledSize") {
            it("returns the normal size") {
                let css = ["font-size" : "10px"]
                let config = ViewCSSFontConfig.fromCSS(dict: css)
                expect(config.scaledSize).to(equal(CGFloat(10.0)))
            }
            it("handles the explicit scaled size") {
                let css = ["font-size" : "10px", "font-size-scale" : "0.75"]
                let config = ViewCSSFontConfig.fromCSS(dict: css)
                expect(config.scaledSize).to(equal(CGFloat(8.0)))
            }
            it("handles the auto scaled size") {
                let css = ["font-size" : "10px", "font-size-scale" : "auto"]
                ViewCSSAutoScaleCache.shared.scale = 1.25
                let config = ViewCSSFontConfig.fromCSS(dict: css)
                expect(config.scaledSize).to(equal(CGFloat(13.0)))
            }
            it("handles the scaled size min") {
                let css = ["font-size" : "10px", "font-size-scale" : "0.5", "font-size-scale-min" : "8px"]
                let config = ViewCSSFontConfig.fromCSS(dict: css)
                expect(config.scaledSize).to(equal(CGFloat(8.0)))
            }
            it("handles the scaled size max") {
                let css = ["font-size" : "10px", "font-size-scale" : "2.0", "font-size-scale-max" : "16px"]
                let config = ViewCSSFontConfig.fromCSS(dict: css)
                expect(config.scaledSize).to(equal(CGFloat(16.0)))
            }
        }
        
        describe("#getFont") {
            it("returns the normal size") {
                let css = ["font-size" : "10px"]
                let config = ViewCSSFontConfig.fromCSS(dict: css)
                let font = config.getFont()
                expect(font?.pointSize).to(equal(CGFloat(10.0)))
            }
            it("handles the explicit scaled size") {
                let css = ["font-size" : "10px", "font-size-scale" : "0.75"]
                let config = ViewCSSFontConfig.fromCSS(dict: css)
                let font = config.getFont()
                expect(font?.pointSize).to(equal(CGFloat(8.0)))
            }
            it("handles the auto scaled size") {
                let css = ["font-size" : "10px", "font-size-scale" : "auto"]
                ViewCSSAutoScaleCache.shared.scale = 1.25
                let config = ViewCSSFontConfig.fromCSS(dict: css)
                let font = config.getFont()
                expect(font?.pointSize).to(equal(CGFloat(13.0)))
            }
            it("handles the weight") {
                let css = ["font-size" : "10px", "font-size-scale" : "auto", "font-weight" : "bold"]
                ViewCSSAutoScaleCache.shared.scale = 1.25
                let config = ViewCSSFontConfig.fromCSS(dict: css)
                let font = config.getFont()
                expect(font?.pointSize).to(equal(CGFloat(13.0)))
                // TODO: There is currently no good way to figure out what the weight is
            }
        }
       
        describe("#fromCSS") {
            it("sets the size, weight, and scale") {
                let css = ["font-size" : "20px", "font-size-scale" : "0.75", "font-weight" : "bold"]
                let config = ViewCSSFontConfig.fromCSS(dict: css)
                expect(config.size).to(equal(20))
                expect(config.sizeScale).to(equal(CGFloat(0.75)))
                expect(config.scaledSize).to(equal(CGFloat(15.0)))
                expect(config.weight).to(equal(UIFont.Weight.bold))
            }
        }
        
        describe("#toCSS") {
            
            ViewCSSTextProtocolHelper.iterate(callback: { (klass: UIView.Type) in
                let view = klass.init()
                
                beforeEach {
                    if let button = view as? UIButton {
                        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
                    }
                    else if let label = view as? UILabel {
                        label.font = UIFont.systemFont(ofSize: 22)
                    }
                    else if let textView = view as? UITextView {
                        textView.font = UIFont.systemFont(ofSize: 22)
                    }
                    else if let textField = view as? UITextField {
                        textField.font = UIFont.systemFont(ofSize: 22)
                    }
                }
                
                it("prints the CSS for " + String(describing: klass)) {
                    let css = ViewCSSFontConfig.toCSS(object: view)
                    expect(css["font-size"]).to(equal("22px"))
                }
            })
        }
    }
}
