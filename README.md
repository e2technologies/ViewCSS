# ViewCSS

[![CI Status](http://img.shields.io/travis/ericchapman/ViewCSS.svg?style=flat)](https://travis-ci.org/ericchapman/ViewCSS)
[![Version](https://img.shields.io/cocoapods/v/ViewCSS.svg?style=flat)](http://cocoapods.org/pods/ViewCSS)
[![License](https://img.shields.io/cocoapods/l/ViewCSS.svg?style=flat)](http://cocoapods.org/pods/ViewCSS)
[![Platform](https://img.shields.io/cocoapods/p/ViewCSS.svg?style=flat)](http://cocoapods.org/pods/ViewCSS)

ViewCSS is a CSS like plugin for iOS Applications.  It provides a simple
interface to define different attributes for UIView elements.  It is intended
to allow application developers/designers a simple interface to enable CSS
reuse methodologies as well as overriding the values at run-time.  **It is NOT
intended to replace auto layout, NIBs, etc.**

## Versions

  - v0.1.0 
    - initial revision
  - v0.2.0
    - added the "font-size-scale" property to support auto scaling of font size
      based on the user's OS settings
  - v0.3.0
    - added the "text-shadow"
    - added "text-shadow-opacity"
  - v0.4.0
    - implemented unit tests
    - code cleanup (no change to the API)
    - small bug fixes, etc
  - v0.5.0
    - added ".cssText" property to support HTML/CSS based text string (wraps NSAttributedString)
  - v0.6.0
    - added "text-transform"
    - added "text-decoration-line"
    - added "text-decoration-color"
    - added "text-decoration-style"
  - v0.7.0
    - moved documentation to the Wiki
    - changed auto scale to "0.15" per tick
    - added ".cssScale" property
    - added "text-overflow"
  - v0.8.0
    - added "font-size-scale-min"
    - added "font-size-scale-max"

## Examples

The documentation is located [here](https://github.com/ericchapman/ViewCSS/wiki) on
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
IOS 8.0 and greater, SWIFT 4.0

## Installation

ViewCSS is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ViewCSS'
```

## License

ViewCSS is available under the MIT license. See the LICENSE file for more info.
