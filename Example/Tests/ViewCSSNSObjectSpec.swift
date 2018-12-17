import Quick
import Nimble
@testable import ViewCSS

class ViewCSSNSObjectSpec: QuickSpec {
    let manager = ViewCSSManager.shared
    
    override func spec() {
        
        describe("#cssScale") {
            it("returns the current scale factor from a class") {
                expect(NSObject.cssScale).to(equal(ViewCSSAutoScaleCache.shared.scale))
            }
            it("returns the current scale factor from an instance") {
                expect(NSObject().cssScale).to(equal(ViewCSSAutoScaleCache.shared.scale))
            }
        }
        
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
        
        describe("#delegate callback") {
            
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
        
        describe("#customize callback") {
            
            context("NSObject") {
                it("calls the callback") {
                    let object = NSObject()
                    let view = UIView()
                    var count = 0
                    object.css(object: view, class: "class") { (config: ViewCSSConfig) in
                        count += 1
                    }
                    expect(count).to(equal(1))
                }
            }
            
            context("UIView") {
                it("calls the callback") {
                    let view = UIView()
                    var count = 0
                    view.css(class: "class") { (config: ViewCSSConfig) in
                        count += 1
                    }
                    expect(count).to(equal(1))
                }
            }
        }
    }
}
