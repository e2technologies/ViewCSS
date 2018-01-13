import Quick
import Nimble
@testable import ViewCSS

class ViewCSSBorderConfigSpec: QuickSpec {
    override func spec() {

        describe("#border-width") {
            let custom = [
                "medium" : CGFloat(2),
                "thin" : CGFloat(1),
                "thick" : CGFloat(3),
            ]
            ViewCSSTypeHelper.test(name: "border width", types: [.length, .custom], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSBorderConfig(css: ["border-width": value])
                return config.width
            }, custom: custom)
        }

        describe("#border-radius") {
            ViewCSSTypeHelper.test(name: "radius", types: [.length], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSBorderConfig(css: ["border-radius": value])
                return config.radius
            })
        }
        
        describe("#border-color") {
            ViewCSSTypeHelper.test(name: "color", types: [.color], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSBorderConfig(css: ["border-color": value])
                return config.color
            })
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

