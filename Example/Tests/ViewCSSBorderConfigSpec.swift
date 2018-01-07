import Quick
import Nimble
@testable import ViewCSS

class ViewCSSBorderConfigSpec: QuickSpec {
    override func spec() {

        describe("#setWidth") {
            let custom = [
                "medium" : CGFloat(2),
                "thin" : CGFloat(1),
                "thick" : CGFloat(3),
            ]
            ViewCSSTypeHelper.test(name: "border width", types: [.length, .custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSBorderConfig()
                config.setWidth(dict: ["border-width": value])
                return config.width
            }, custom: custom)
        }

        describe("#setRadius") {
            ViewCSSTypeHelper.test(name: "radius", types: [.length], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSBorderConfig()
                config.setRadius(dict: ["border-radius": value])
                return config.radius
            })
        }
        
        describe("#setColor") {
            ViewCSSTypeHelper.test(name: "color", types: [.color], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSBorderConfig()
                config.setColor(dict: ["border-color": value])
                return config.color
            })
        }
        
        describe("#fromCSS") {
            it("does nothing") {
                let css = [String:String]()
                let config = ViewCSSBorderConfig.fromCSS(dict: css)
                expect(config.width).to(beNil())
                expect(config.radius).to(beNil())
                expect(config.color).to(beNil())
            }
            
            it("imports everything") {
                let css = ["border-width" : "5px", "border-radius" : "7px", "border-color" : "red"]
                let config = ViewCSSBorderConfig.fromCSS(dict: css)
                expect(config.width).to(equal(5))
                expect(config.radius).to(equal(7))
                expect(config.color!.toCSS).to(equal("#FF0000FF"))
            }
        }
        
        describe("#toCSS") {
            
            ViewCSSViewProtocolHelper.iterate(callback: { (klass: UIView.Type) in
                let view = klass.init()
                
                beforeEach {
                    view.layer.borderColor = UIColor(css: "red")!.cgColor
                    view.layer.borderWidth = 12
                    view.layer.cornerRadius = 5
                }
                
                it("prints no border radius for " + String(describing: klass)) {
                    view.layer.cornerRadius = 0
                    let css = ViewCSSBorderConfig.toCSS(object: view)
                    expect(css).to(equal(["border-color" : "#FF0000FF", "border-width" : "12px"]))
                }
                
                it("prints no border color/width when color is nil for " + String(describing: klass)) {
                    view.layer.borderColor = nil
                    let css = ViewCSSBorderConfig.toCSS(object: view)
                    expect(css).to(equal(["border-radius" : "5px"]))
                }
                
                it("prints no border color/width when width is 0 for " + String(describing: klass)) {
                    view.layer.borderWidth = 0
                    let css = ViewCSSBorderConfig.toCSS(object: view)
                    expect(css).to(equal(["border-radius" : "5px"]))
                }
                
                it("prints all for " + String(describing: klass)) {
                    let css = ViewCSSBorderConfig.toCSS(object: view)
                    expect(css).to(equal(["border-color" : "#FF0000FF", "border-width" : "12px", "border-radius" : "5px"]))
                }
            })
        }
    }
}

