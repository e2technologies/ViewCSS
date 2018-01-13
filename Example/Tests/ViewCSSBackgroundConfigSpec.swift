import Quick
import Nimble
@testable import ViewCSS

class ViewCSSBackgroundConfigSpec: QuickSpec {
    override func spec() {
        let color = UIColor(css: "red")!
        
        describe("#background-color") {
            ViewCSSTypeHelper.test(name: "color", types: [.color], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSBackgroundConfig(css: ["background-color": value])
                return config.color
            })
        }
        
        describe("#toCSS") {
            
            ViewCSSViewProtocolHelper.iterate(callback: { (klass: UIView.Type) in
                let view = klass.init()
                
                beforeEach {
                    view.backgroundColor = color
                }
                
                it("prints nothing for " + String(describing: klass)) {
                    view.backgroundColor = nil
                    let css = ViewCSSBackgroundConfig.toCSS(object: view)
                    expect(css.keys.count).to(equal(0))
                }
                
                it("prints nothing for " + String(describing: klass)) {
                    let css = ViewCSSBackgroundConfig.toCSS(object: view)
                    expect(css["background-color"]).to(equal(color.toCSS))
                }
                
            })
        }
    }
}
