import Quick
import Nimble
@testable import ViewCSS

class ViewCSSBackgroundConfigSpec: QuickSpec {
    override func spec() {
        let color = UIColor(css: "red")!
        
        describe("#setColor") {
            ViewCSSTypeHelper.test(name: "color", types: [.color], routine: {
                (value: String, type: ViewCSSBaseConfig.PropertyType) -> (Any?) in
                let config = ViewCSSBackgroundConfig()
                config.setColor(dict: ["background-color": value])
                return config.color
            })
        }
        
        describe("#fromCSS") {
            it("does nothing") {
                let css = [String:String]()
                let config = ViewCSSBackgroundConfig.fromCSS(dict: css)
                expect(config.color).to(beNil())
            }
            
            it("sets the background color") {
                let css = [ "background-color" : color.toCSS]
                let config = ViewCSSBackgroundConfig.fromCSS(dict: css)
                expect(config.color!.toCSS).to(equal("#FF0000FF"))
            }
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
