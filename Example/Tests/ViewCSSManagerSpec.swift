import Quick
import Nimble
@testable import ViewCSS

class ViewCSSManagerSpec: QuickSpec {
    override func spec() {
        var manager: ViewCSSManager? = nil
        
        beforeEach {
            manager = ViewCSSManager()
        }
        
        describe("#checkForVariable") {
            it("ignores because of misspelled var") {
                let css = [":root" : ["--primary": "red"]]
                manager!.setCSS(dict: css)
                let replace = manager!.checkForVariable(string: "va(--primary)")
                expect(replace).to(equal("va(--primary)"))
            }
            
            it("ignores because of missing )") {
                let css = [":root" : ["--primary": "red"]]
                manager!.setCSS(dict: css)
                let replace = manager!.checkForVariable(string: "var(--primary")
                expect(replace).to(equal("var(--primary"))
            }
            
            it("retrieves a variable") {
                let css = [":root" : ["--primary": "red"]]
                manager!.setCSS(dict: css)
                let replace = manager!.checkForVariable(string: "var(--primary)")
                expect(replace).to(equal("red"))
            }
            
            it("retrieves a nessted variable") {
                let css = [":root" : ["--primary": "var(--secondary)", "--secondary" : "red"]]
                manager!.setCSS(dict: css)
                let replace = manager!.checkForVariable(string: "red")
                expect(replace).to(equal("red"))
            }
        }
        
        describe("#cacheKey") {
            it("creates the cache key with no class or style") {
                let cacheKey = manager!.getCacheKey(className: "my_string", style: nil, class: nil)
                expect(cacheKey).to(equal("my_string"))
            }
            
            it("creates the cache key with no class") {
                let cacheKey = manager!.getCacheKey(className: "my_string", style: "style", class: nil)
                expect(cacheKey).to(equal("my_string style"))
            }
            
            it("creates the cache key with no style") {
                let cacheKey = manager!.getCacheKey(className: "my_string", style: nil, class: "class")
                expect(cacheKey).to(equal("my_string class"))
            }
            
            it("creates the cache key") {
                let cacheKey = manager!.getCacheKey(className: "my_string", style: "style", class: "class")
                expect(cacheKey).to(equal("my_string style class"))
            }
        }
        
        describe("#getClassName") {
            it("returns the name of a class by class") {
                let className = manager!.getClassName(class: UILabel.self)
                expect(className).to(equal("ui_label"))
            }
            
            it("returns the name of a class by instance") {
                let className = manager!.getClassName(object: UILabel())
                expect(className).to(equal("ui_label"))
            }
        }
        
        describe("#generateClassList") {
            it("adds the class name to the end") {
                let classList = manager!.generateClassList(className: "ui_label", class: "class1")
                expect(classList).to(equal([
                    "ui_label.class1",
                    ".class1",
                    "ui_label"
                    ]))
            }
            
            it("parses multiple classes") {
                let classList = manager!.generateClassList(className: "ui_label", class: "class1 class2")
                expect(classList).to(equal([
                    "ui_label.class1",
                    ".class1",
                    "ui_label.class2",
                    ".class2",
                    "ui_label"
                    ]))
            }
            
            it("inherits the parent object classes") {
                let classList = manager!.generateClassList(className: "ui_label", class: "class1 class2", parentClass: "parent1 parent2")
                expect(classList).to(equal([
                    "ui_label.class1",
                    ".class1",
                    "ui_label.class2",
                    ".class2",
                    "ui_label.parent1",
                    ".parent1",
                    "ui_label.parent2",
                    ".parent2",
                    "ui_label"
                    ]))
            }
        }
        
        describe("#getConfig") {
            let css = [
                "ui_label" : [
                    "background-color": "red"
                ],
                "ui_label.class" : [
                    "background-color": "black"
                ],
                ".class" : [
                    "background-color": "blue"
                ],
                ".class1" : [
                    "background-color": "white"
                ],
            ]
            
            it("matches the classname") {
                manager!.setCSS(dict: css)
                let config = manager!.getConfig(className: "ui_label", class: nil, style: nil)
                expect(config.background?.color?.toCSS).to(equal("#FF0000FF"))
            }
            
            it("matches the classname and class") {
                manager!.setCSS(dict: css)
                let config = manager!.getConfig(className: "ui_label", class: "class", style: nil)
                expect(config.background?.color?.toCSS).to(equal("#000000FF"))
            }
            
            it("matches the class") {
                manager!.setCSS(dict: css)
                let config = manager!.getConfig(className: "ui_button", class: "class", style: nil)
                expect(config.background?.color?.toCSS).to(equal("#0000FFFF"))
            }
            
            it("uses the first class, option 1") {
                manager!.setCSS(dict: css)
                let config = manager!.getConfig(className: "ui_button", class: "class class1", style: nil)
                expect(config.background?.color?.toCSS).to(equal("#0000FFFF"))
            }
            
            it("uses the first class, option 2") {
                manager!.setCSS(dict: css)
                let config = manager!.getConfig(className: "ui_button", class: "class1 class", style: nil)
                expect(config.background?.color?.toCSS).to(equal("#FFFFFFFF"))
            }
            
            it("style overrides") {
                manager!.setCSS(dict: css)
                let config = manager!.getConfig(className: "ui_button", class: "class", style: "background-color : #00FF00FF;")
                expect(config.background?.color?.toCSS).to(equal("#00FF00FF"))
            }
        }
    }
}
