import Quick
import Nimble
@testable import ViewCSS

class ViewCSSNSObjectSpec: QuickSpec {
    let manager = ViewCSSManager.shared
    
    override func spec() {
        
        describe("#getConfig") {
            it("returns the config for the instance") {
                let css = [".label": ["background-color" : "red"]]
                self.manager.setCSS(dict: css)
                let object = UIView()
                let config = object.cssConfig(class: "label")
                expect(config.background!.color!.toCSS).to(equal("#FF0000FF"))
            }
            it("returns the config for the class") {
                let css = [".label": ["background-color" : "red"]]
                self.manager.setCSS(dict: css)
                let config = UIView.cssConfig(class: "label")
                expect(config.background!.color!.toCSS).to(equal("#FF0000FF"))
            }
        }
        
        describe("#callback") {
            
            context("NSObject") {
                class CallbackClass: NSObject, ViewCSSCustomizableProtocol {
                    var count = 0
                    func cssCustomize(object: Any?, class klass: String?, style: String?, config: ViewCSSConfig) {
                        self.count += 1
                    }
                }
                
                it("calls the delegate") {
                    let caller = CallbackClass()
                    let object = UIView()
                    caller.count = 0
                    caller.css(object: object, class: "class")
                    expect(caller.count).to(equal(1))
                }
                
                it("doesn't call the delegate if no object and caller is not UIView") {
                    let caller = CallbackClass()
                    caller.count = 0
                    caller.css(class: "class")
                    expect(caller.count).to(equal(0))
                }
            }
            
            context("UIView") {
                class CallbackClass: UIView, ViewCSSCustomizableProtocol {
                    var count = 0
                    func cssCustomize(object: Any?, class klass: String?, style: String?, config: ViewCSSConfig) {
                        self.count += 1
                    }
                }
                
                it("calls the delegate") {
                    let caller = CallbackClass()
                    let object = UIView()
                    caller.count = 0
                    caller.css(object: object, class: "class")
                    expect(caller.count).to(equal(1))
                }
                
                it("does call the delegate") {
                    let caller = CallbackClass()
                    caller.count = 0
                    caller.css(class: "class")
                    expect(caller.count).to(equal(1))
                }
            }
        }
    }
}
