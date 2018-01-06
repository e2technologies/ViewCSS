import Quick
import Nimble
@testable import ViewCSS

class ViewCSSUIViewSpec: QuickSpec {
    let manager = ViewCSSManager.shared
    
    override func spec() {
        
        describe("custom") {
            it("calls the custom callback") {
                self.manager.setCSS(dict: [".view" : ["background-color" : "red"]])
                let view = UIView()
                var count = 0
                view.css(class: "view") { (config: ViewCSSConfig) in
                    expect(config.background?.color?.toCSS).to(equal("#FF0000FF"))
                    count += 1
                }
                expect(count).to(equal(1))
            }
        }
        
        describe("view protocol") {
            context("UIView") {
                it("background-color") {
                    self.manager.setCSS(dict: [".view" : ["background-color" : "red"]])
                    let view = UIView()
                    view.css(class: "view")
                    expect(view.backgroundColor?.toCSS).to(equal("#FF0000FF"))
                }
                it("tint-color") {
                    self.manager.setCSS(dict: [".view" : ["tint-color" : "blue"]])
                    let view = UIView()
                    view.css(class: "view")
                    expect(view.tintColor?.toCSS).to(equal("#0000FFFF"))
                }
                it("opacity") {
                    self.manager.setCSS(dict: [".view" : ["opacity" : "0.4"]])
                    let view = UIView()
                    view.css(class: "view")
                    expect(view.alpha).to(beCloseTo(0.4))
                }
                it("border-radius") {
                    self.manager.setCSS(dict: [".view" : ["border-radius" : "2px"]])
                    let view = UIView()
                    view.css(class: "view")
                    expect(view.layer.cornerRadius).to(equal(CGFloat(2)))
                    expect(view.layer.masksToBounds).to(equal(true))
                }
                it("border-color border-width") {
                    self.manager.setCSS(dict: [".view" : ["border-color" : "red", "border-width" : "5px"]])
                    let view = UIView()
                    view.css(class: "view")
                    expect(view.layer.borderWidth).to(equal(CGFloat(5.0)))
                    expect(UIColor(cgColor: view.layer.borderColor!).toCSS).to(equal("#FF0000FF"))
                }
            }
        }
       
        describe("text protocol") {
            context("UILabel") {
                it("text-shadow") {
                    self.manager.setCSS(dict: [".view" : ["text-shadow" : "3px 4px 2px red"]])
                    let view = UILabel()
                    view.css(class: "view")
                    expect(view.layer.shadowOffset).to(equal(CGSize(width: 3, height: 4)))
                    expect(view.layer.shadowRadius).to(equal(CGFloat(2)))
                    expect(UIColor(cgColor: view.layer.shadowColor!).toCSS).to(equal("#FF0000FF"))
                    expect(CGFloat(view.layer.shadowOpacity)).to(equal(CGFloat(1.0)))
                }
                it("text-shadow-opacity") {
                    self.manager.setCSS(dict: [".view" : ["text-shadow" : "3px 4px 2px red", "text-shadow-opacity" : "0.5"]])
                    let view = UILabel()
                    view.css(class: "view")
                    expect(view.layer.shadowOffset).to(equal(CGSize(width: 3, height: 4)))
                    expect(view.layer.shadowRadius).to(equal(CGFloat(2)))
                    expect(UIColor(cgColor: view.layer.shadowColor!).toCSS).to(equal("#FF0000FF"))
                    expect(CGFloat(view.layer.shadowOpacity)).to(equal(CGFloat(0.5)))
                }
                it("text-align") {
                    self.manager.setCSS(dict: [".view" : ["text-align" : "right"]])
                    let view = UILabel()
                    view.css(class: "view")
                    expect(view.textAlignment).to(equal(NSTextAlignment.right))
                }
                it("text-overflow") {
                    self.manager.setCSS(dict: [".view" : ["text-overflow" : "clip"]])
                    let view = UILabel()
                    view.css(class: "view")
                    expect(view.lineBreakMode).to(equal(NSLineBreakMode.byClipping))
                    expect(view.adjustsFontSizeToFitWidth).to(equal(false))
                }
                it("font-size font-weight font-scale") {
                    self.manager.setCSS(dict: [".view" : ["font-size" : "20px", "font-weight" : "bold", "font-size-scale" : "0.75"]])
                    let view = UILabel()
                    view.css(class: "view")
                    expect(view.font.pointSize).to(equal(15.0))
                }
            }
            context("UITextView") {
                it("text-shadow") {
                    self.manager.setCSS(dict: [".view" : ["text-shadow" : "3px 4px 2px red"]])
                    let view = UITextView()
                    view.css(class: "view")
                    expect(view.layer.shadowOffset).to(equal(CGSize(width: 3, height: 4)))
                    expect(view.layer.shadowRadius).to(equal(CGFloat(2)))
                    expect(UIColor(cgColor: view.layer.shadowColor!).toCSS).to(equal("#FF0000FF"))
                    expect(CGFloat(view.layer.shadowOpacity)).to(equal(CGFloat(1.0)))
                }
                it("text-shadow-opacity") {
                    self.manager.setCSS(dict: [".view" : ["text-shadow" : "3px 4px 2px red", "text-shadow-opacity" : "0.5"]])
                    let view = UITextView()
                    view.css(class: "view")
                    expect(view.layer.shadowOffset).to(equal(CGSize(width: 3, height: 4)))
                    expect(view.layer.shadowRadius).to(equal(CGFloat(2)))
                    expect(UIColor(cgColor: view.layer.shadowColor!).toCSS).to(equal("#FF0000FF"))
                    expect(CGFloat(view.layer.shadowOpacity)).to(equal(CGFloat(0.5)))
                }
                it("text-align") {
                    self.manager.setCSS(dict: [".view" : ["text-align" : "right"]])
                    let view = UITextView()
                    view.css(class: "view")
                    expect(view.textAlignment).to(equal(NSTextAlignment.right))
                }
                it("text-overflow") {
                    self.manager.setCSS(dict: [".view" : ["text-overflow" : "clip"]])
                    let view = UITextView()
                    view.css(class: "view")
                    // Not supported
                }
                it("font-size font-weight font-scale") {
                    self.manager.setCSS(dict: [".view" : ["font-size" : "20px", "font-weight" : "bold", "font-size-scale" : "0.75"]])
                    let view = UITextView()
                    view.css(class: "view")
                    expect(view.font!.pointSize).to(equal(15.0))
                }
            }
            context("UITextField") {
                it("text-shadow") {
                    self.manager.setCSS(dict: [".view" : ["text-shadow" : "3px 4px 2px red"]])
                    let view = UITextField()
                    view.css(class: "view")
                    expect(view.layer.shadowOffset).to(equal(CGSize(width: 3, height: 4)))
                    expect(view.layer.shadowRadius).to(equal(CGFloat(2)))
                    expect(UIColor(cgColor: view.layer.shadowColor!).toCSS).to(equal("#FF0000FF"))
                    expect(CGFloat(view.layer.shadowOpacity)).to(equal(CGFloat(1.0)))
                }
                it("text-shadow-opacity") {
                    self.manager.setCSS(dict: [".view" : ["text-shadow" : "3px 4px 2px red", "text-shadow-opacity" : "0.5"]])
                    let view = UITextField()
                    view.css(class: "view")
                    expect(view.layer.shadowOffset).to(equal(CGSize(width: 3, height: 4)))
                    expect(view.layer.shadowRadius).to(equal(CGFloat(2)))
                    expect(UIColor(cgColor: view.layer.shadowColor!).toCSS).to(equal("#FF0000FF"))
                    expect(CGFloat(view.layer.shadowOpacity)).to(equal(CGFloat(0.5)))
                }
                it("text-align") {
                    self.manager.setCSS(dict: [".view" : ["text-align" : "right"]])
                    let view = UITextField()
                    view.css(class: "view")
                    expect(view.textAlignment).to(equal(NSTextAlignment.right))
                }
                it("text-overflow") {
                    self.manager.setCSS(dict: [".view" : ["text-overflow" : "clip"]])
                    let view = UITextField()
                    view.css(class: "view")
                    // Not supported
                }
                it("font-size font-weight font-scale") {
                    self.manager.setCSS(dict: [".view" : ["font-size" : "20px", "font-weight" : "bold", "font-size-scale" : "0.75"]])
                    let view = UITextField()
                    view.css(class: "view")
                    expect(view.font!.pointSize).to(equal(15.0))
                }
            }
            context("UIButton") {
                it("text-shadow") {
                    self.manager.setCSS(dict: [".view" : ["text-shadow" : "3px 4px 2px red"]])
                    let view = UIButton()
                    view.css(class: "view")
                    expect(view.titleLabel?.layer.shadowOffset).to(equal(CGSize(width: 3, height: 4)))
                    expect(view.titleLabel?.layer.shadowRadius).to(equal(CGFloat(2)))
                    expect(UIColor(cgColor: view.titleLabel!.layer.shadowColor!).toCSS).to(equal("#FF0000FF"))
                    expect(CGFloat(view.titleLabel!.layer.shadowOpacity)).to(equal(CGFloat(1.0)))
                }
                it("text-shadow-opacity") {
                    self.manager.setCSS(dict: [".view" : ["text-shadow" : "3px 4px 2px red", "text-shadow-opacity" : "0.5"]])
                    let view = UIButton()
                    view.css(class: "view")
                    expect(view.titleLabel?.layer.shadowOffset).to(equal(CGSize(width: 3, height: 4)))
                    expect(view.titleLabel?.layer.shadowRadius).to(equal(CGFloat(2)))
                    expect(UIColor(cgColor: view.titleLabel!.layer.shadowColor!).toCSS).to(equal("#FF0000FF"))
                    expect(CGFloat(view.titleLabel!.layer.shadowOpacity)).to(equal(CGFloat(0.5)))
                }
                it("text-align") {
                    self.manager.setCSS(dict: [".view" : ["text-align" : "right"]])
                    let view = UIButton()
                    view.css(class: "view")
                    expect(view.contentHorizontalAlignment).to(equal(UIControlContentHorizontalAlignment.right))
                }
                it("text-overflow") {
                    self.manager.setCSS(dict: [".view" : ["text-overflow" : "clip"]])
                    let view = UIButton()
                    view.css(class: "view")
                    expect(view.titleLabel?.lineBreakMode).to(equal(NSLineBreakMode.byClipping))
                    expect(view.titleLabel?.adjustsFontSizeToFitWidth).to(equal(false))
                }
                it("font-size font-weight font-scale") {
                    self.manager.setCSS(dict: [".view" : ["font-size" : "20px", "font-weight" : "bold", "font-size-scale" : "0.75"]])
                    let view = UIButton()
                    view.css(class: "view")
                    expect(view.titleLabel!.font.pointSize).to(equal(15.0))
                }
            }
        }
        
        describe("stores attributes") {
            it("stores the class name") {
                let view = UIView()
                view.css()
                expect(view.cssClassName).to(equal("ui_view"))
                expect(view.cssClass).to(beNil())
                expect(view.cssStyle).to(beNil())
            }
            it("stores the class") {
                let view = UIView()
                view.css(class: "button")
                expect(view.cssClassName).to(equal("ui_view"))
                expect(view.cssClass).to(equal("button"))
                expect(view.cssStyle).to(beNil())
            }
            it("stores the style") {
                let view = UIView()
                view.css(style: "background-color:red;")
                expect(view.cssClassName).to(equal("ui_view"))
                expect(view.cssStyle).to(equal("background-color:red;"))
                expect(view.cssClass).to(beNil())
            }
            it("stores the class and the style") {
                let view = UIView()
                view.css(class: "button", style: "background-color:red;")
                expect(view.cssClassName).to(equal("ui_view"))
                expect(view.cssStyle).to(equal("background-color:red;"))
                expect(view.cssClass).to(equal("button"))
            }
        }
        
    }
}
