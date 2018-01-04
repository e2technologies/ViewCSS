import Quick
import Nimble
@testable import ViewCSS

class ViewCSSBackgroundConfigSpec: QuickSpec {
    override func spec() {
        
        describe("#setColor") {
            ViewCSSTypeHelper.test(name: "color", types: [.color], routine: { (value: String) -> (Any?) in
                let config = ViewCSSBackgroundConfig()
                config.setColor(dict: ["background-color": value])
                return config.color
            })
        }
    }
}
