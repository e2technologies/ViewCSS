# ViewCSS

[![CI Status](http://img.shields.io/travis/e2technologies/ViewCSS.svg?style=flat)](https://travis-ci.org/e2technologies/ViewCSS)
[![Codecov](https://codecov.io/gh/e2technologies/ViewCSS/branch/master/graph/badge.svg)](https://codecov.io/gh/e2technologies/ViewCSS)
[![Version](https://img.shields.io/cocoapods/v/ViewCSS.svg?style=flat)](http://cocoapods.org/pods/ViewCSS)
[![License](https://img.shields.io/cocoapods/l/ViewCSS.svg?style=flat)](http://cocoapods.org/pods/ViewCSS)
[![Platform](https://img.shields.io/cocoapods/p/ViewCSS.svg?style=flat)](http://cocoapods.org/pods/ViewCSS)

ViewCSS is a CSS like plugin for iOS Applications.  It provides a simple
interface to define different attributes for UIView elements.  It is intended
to allow application developers/designers a simple interface to enable CSS
reuse methodologies as well as overriding the values at run-time.  **It is NOT
intended to replace auto layout, NIBs, etc.**

## Versions

  - v1.0.6
    - Defined swift_version = 4.0
  - v1.0.5
    - Fixed issue with emojis in "cssText"
  - v1.0.4
    - Updated "generateCSSText" method to allow NSAttributedText to be returned in class methods for text height predictions
  - v1.0.3
    - Fixed issue where "cssText" is applying the background color to the UIButton title label
  - v1.0.2
    - Added "cssText" support to UIButton
  - v1.0.1
    - Fixed bug with "cssText" improperly pulling the cached settings
  - v1.0.0
    - First full release

## Examples

The documentation is located [here](https://github.com/e2technologies/ViewCSS/wiki) on
the Wiki page.

```swift
import UIKit
import ViewCSS

class MyCustomViewController: UIViewController {
    @IBOutlet weak var label1: UILabel?
    @IBOutlet weak var label2: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the global CSS dictionary (see later section on this)
        let css: [String:Any] = [
            ".bold" : [
                "font-weight" : "bold"
            ],
            "my_custom_view_controller.label1" : [
                "font-size" : "16px",
                "text-align": "left",
                "color" : "red",
            ],
            "my_custom_view_controller.label2" : [
                "font-size" : "12px",
                "text-align": "right",
                "color" : "white",
            ],
        ]
        ViewCSSManager.shared.setCSS(dict: css)
        
        // ...
        
        self.css(object: self.label1, class: "label1")
        self.css(object: self.label2, class: "bold label2")
    }
    
    var setText(firstName: String, lastName: String) {
        self.label1?.cssText = "\(firstName)<span class=\"bold\">\(lastName)</span>"
    }
    
}
```

## Requirements
IOS 8.0 and greater

## Installation

ViewCSS is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ViewCSS'
```

## License

ViewCSS is available under the MIT license. See the LICENSE file for more info.
