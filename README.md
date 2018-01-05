# ViewCSS

[![CI Status](http://img.shields.io/travis/ericchapman/ViewCSS.svg?style=flat)](https://travis-ci.org/ericchapman/ViewCSS)
[![Version](https://img.shields.io/cocoapods/v/ViewCSS.svg?style=flat)](http://cocoapods.org/pods/ViewCSS)
[![License](https://img.shields.io/cocoapods/l/ViewCSS.svg?style=flat)](http://cocoapods.org/pods/ViewCSS)
[![Platform](https://img.shields.io/cocoapods/p/ViewCSS.svg?style=flat)](http://cocoapods.org/pods/ViewCSS)

ViewCSS is a CSS like plugin for iOS Applications.  It provides a simple
interface to define different attributes for UIView elements.  It is intended
to allow application developers/designers a simple interface to enable CSS
reuse methodologies as well as overriding the values at run-time.  **It is NOT
intended to replace auto layout, attributed text, NIBs, etc.**

## Versions

  - 0.1.0 - Initial Revision
  - 0.2.0 - Added the "font-size-scale" property to support auto scaling of font size
    based on the user's OS settings
  - 0.3.0 - Added the "text-shadow" and "text-shadow-opacity" properties
  - 0.4.0 - Implemented unit tests, some code rework, small bug fixes, etc.  No changes to the API
  - 0.5.0 - Adding ".cssText" method to support text manipulation tags like "text-decoration"

## Examples

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

## Usage

### Overview

ViewCSS is a CSS like plugin for iOS Applications.  It provides a simple 
interface to define different attributes for UIView elements.  It is intended
to allow application developers/designers a simple interface to enable CSS
reuse methodologies as well as overriding the values at run-time.  **It is NOT
intended to replace auto layout, attributed text, NIBs, etc.**

An example of use is shown below

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
    
}
```

This will dynamically configure "label1" and "label2" with the defined
settings in the "css" dictionary.  Note that it only overrides the settings
that were included in the dictionary, so any customizations that were
done in code or a NIB will remain.

This enables common styles to be reused throughout the application.  It
also enables the attributes of UI elements to be changed outside of the 
compiled application.  For example, the CSS dictionary could be a json 
file that is stored on a server somewhere that the application can
periodically check for updates.

Also since only the properties that are in the dictionary are modified,
you can use this library purely as a way to override the default settings.
In other words, you do not need to have every property defined in the
dictionary, just those where you want to override a specific setting.
This makes the use of this library NOT an "all or nothing" exercise.  You
can override the attributes on an "as needed" basis.

### Supported Properties

The ViewCSS library supports the below CSS properties.  Note that I
attempted to stick with the standard CSS properties the best that I could,
but some custom properties had to be created (such as "tint-color")

| Property            | UIView | UILabel | UITextField | UITextView | UIButton | Snoopable |
|:--------------------|:------:|:-------:|:-----------:|:----------:|:--------:|:---------:|
| background-color    |    X   |    -    |      -      |     -      |     -    |     X     |
| border-color        |    X   |    -    |      -      |     -      |     -    |     X     |
| border-radius       |    X   |    -    |      -      |     -      |     -    |     X     |
| border-width        |    X   |    -    |      -      |     -      |     -    |     X     |
| color               |        |    X    |      X      |     X      |     X    |     X     |
| font-family         |        |   SOON  |     SOON    |    SOON    |   SOON   |   SOON    |
| font-size           |        |    X    |      X      |     X      |     X    |     X     |
| font-size-scale     |        |    X    |      X      |     X      |     X    |           |
| font-weight         |        |    X    |      X      |     X      |     X    |           |
| opacity             |    X   |    -    |      -      |     -      |     -    |     X     |
| text-align          |        |    X    |      X      |     X      |     X    |     X     |
| text-shadow         |        |    X    |      X      |     X      |     X    |     X     |
| text-shadow-opacity |        |    X    |      X      |     X      |     X    |     X     |
| tint-color          |    X   |    -    |      -      |     -      |     -    |     X     |

#### Standard Types

##### color
The "color" property provides a few different ways to specify a color.

It supports the following values

  - ```rgb(red, green, blue, [alpha])``` - Value from 0-255 specifying the color value.
    Note that "alpha" is optional and will default to 255.  An example of this for
    the color "red" is ```rgb(255,0,0)```
  - ```<name>``` - The name of the color.  The complete list of supported colors can
    be found [here](https://www.w3schools.com/colors/colors_names.asp).  An example
    of this for the color red is ```red```
  - ```#<hex>``` - The hex value of the color.  If "alpha" is omitted, it will assume
    255 (FF).  An example of this for the color red is ```#FF0000```
  - ```transparent``` - A transparent color

##### percentage
The "percentage" property provides a way to specify a percentage.  It expects the
value to end with a "%".  For example, a value of 150 percent for "font-size" would
be ```"font-size" : "150%"```

##### length
The "length" property provides a way to specify a value in pixels.  It expects the
value to end with a "px".  For example, a value of 20 pixels for "border-radius"
would be ```"border-radius" : "20px"```

##### number
The "number" property provides a way to specify a raw number.  It expects just the
number.  For example, a value of 0.75 for "opacity" would be ```"opacity" : "0.75"```

#### Attributes
##### background-color
The "background-color" property will set the "backgroundColor" attribute
of the UIView.

It supports the following values

  - *color* - Sets the background color to the specified color

##### color
The "color" property will set the "textColor" attribute of the text views.
A UIButton is a special case where it will use "setTitleColor(color, for: .normal)".

It supports the following values

  - *color* - Sets the text color to the specified color

##### border-radius
The "border-radius" property will set the "layer.cornerRadius" attribute of
a view.  It also sets the "layer.masksToBounds" which will not allow
drawing outside of the view.

It supports the following values

  - *length* - Defines the shape of the corners

##### border-width
The "border-width" property will set the "layer.borderWidth" attribute of a
view.  Note that it must be used in conjunction with "border-color".

It supports the following values

  - medium - Specifies a medium border of "2px"
  - thin - Specifies a thin border of "1px"
  - thick	Specifies a thick border of "3px"
  - *length* - Allows you to define the thickness of the border

##### border-color
The "border-color" property will set the "layer.borderColor" attribute of a
view.  Note that it must be used in conjunction with "border-width".

It supports the following values

  - *color* - Sets the border color to the specified color

##### font-family
NOT IMPLEMENTED YET

##### font-size
The "font-size" property will set the size of the font.  This assumes "system"
font if "font-family" is not defined.  The library uses a font size of "15" as
the "default" and then scales that value based on the values.

It supports the following values

  - xx-small - Sets the font-size to an xx-small size (default-6)
  - x-small - Sets the font-size to an extra small size (default-4)
  - small - Sets the font-size to a small size (default-2)
  - medium - Sets the font-size to a medium size. This is default (default)
  - large - Sets the font-size to a large size (default+2)
  - x-large - Sets the font-size to an extra large size (default+4)
  - xx-large - Sets the font-size to an xx-large size (default+6)
  - *length* - Sets the font-size to a fixed size in px
  - *percentage* - Sets the font-size to a percent of the *default*

##### font-size-scale (custom)
The "font-size-scale" property will scale the size of the font based on
the setting.

It supports the following values

  - auto - Font size scales based on the user's OS settings
  - *number* - Font size scales based on the number that is passed in from 0.0 to 1.0

##### font-weight
The "font-weight" property will set the weight of the font.  Note that this
is only available in iOS 8.2 and above (it will just ignore the value if
used on an earlier OS version).

It supports the following values

  - normal - Defines normal characters. This is "regular" in iOS terms
  - bold - Defines thick characters. This is "bold" in iOS terms
  - bolder - Defines thicker characters. This is "black" in iOS terms
  - lighter - Defines lighter characters. This is "thin" in iOS terms
  - 100 - This is "ultraLight" in iOS terms
  - 200 - This is "thin" in iOS terms
  - 300 - This is "light" in iOS terms
  - 400 - This is "regular" in iOS terms
  - 500 - This is "medium" in iOS terms
  - 600 - This is "semibold" in iOS terms
  - 700 - This is "bold" in iOS terms
  - 800 - This is "heavy" in iOS terms
  - 900 - This is "black" in iOS terms

##### opacity
The "opacity" property will set the "alpha" attribute of the view.

It supports the following values

  - *number* - Specifies the opacity. From 0.0 (fully transparent) to 1.0 (fully opaque)

##### text-align
The "text-align" property will set the "textAlignment" attribute of the text
view.  A UIButton is a special case where it will use "contentHorizontalAlignment".

It supports the following values

  - left - Aligns the text to the left
  - right - Aligns the text to the right
  - center - Centers the text
  - justify - Stretches the lines so that each line has equal width (like in
    newspapers and magazines)

##### text-shadow
The "text-shadow" property will set the "layer.shadow*" attributes of the text
views.  It has the format

```
"text-shadow" : "<h-shadow> <v-shadow> <blur-radius> <color>"
```

The values are defined as follow

  - h-shadow - Required.  The position of the horizontal shadow.  Negative values
    are allowed
  - v-shadow - Required.  The position of the vertical shadow.  Negative values are
    allowed
  - blur-radius(*length*) - Optional.  The blur radius.  Default 0.
  - color(*color*) - Optional.  the color of the shadow

##### text-shadow-opacity (custom)
The "text-shadow-opacity" property will set the "opacity" of the shadow.  This is
used to override the default of "1.0"

It supports the following values

  - *number* - Specifies the opacity. From 0.0 (fully transparent) to 1.0 (fully opaque)

##### tint-color (custom)
The "tint-color" property will set the "tinColor" attribute of the view.

It supports the following values

  - *color* - Sets the tint color to the specified color

### Attribute Dictionary

#### Initialization

The attribute dictionary should be set in the app delegate's "init" method.
This will make sure it is loaded before any views are loaded.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

    override init() {
        super.init()

        let css: [String:Any] = [
            // CSS Properties
        ]
        
        ViewCSSManager.shared.setCSS(dict: css)
    }
}
```

The library leaves the generation of the dictionary to the developer.  This
removes any unnecessary dependencies from the library on the format of the
file that is capturing the CSS properties.

Here are some examples of getting the file from other sources

##### JSON File Example
Here is an example of reading the properties from a json file in the bundle
called "css.json"

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

    override init() {
        super.init()

        if let path = Bundle.main.path(forResource: "css", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    ViewCSSManager.shared.setCSS(dict: jsonResult)
                }
            } catch {
                print(error)
            }
        }
    }
}
```

#### Variables

The attribute dictionary allows custom variables to be defined.  To do this,
you must define the variable in a ":root" tag of the dictionary and access
the variable using the ```var(<variable>)``` method.  This is shown below

```swift
    let css: [String:Any] = [
        ":root": [
            "--primary-color": "blue"
        ],
        "my_controller.label": [
            "background-color": "var(--primary-color)"
        ]
    ]
```

Note that the library also supports nested variables.  For example

```swift
    let css: [String:Any] = [
        ":root": [
            "--main-color": "blue",
            "--primary-color": "var(--main-color)"
        ],
        "my_controller.label": [
            "background-color": "var(--primary-color)"
        ]
    ]
```

It will recursively search until a variable is not found

### NSObject Methods

#### func css(object: Any?, class klass: String?, custom: ((ViewCSSConfig) -> Void)?=nil)
The library extends "NSObject" to provide "css" helper methods that can
be called.  The methods provide the developer a means to apply CSS to an 
object.

The properties for this method are as follows

  - object: Any? - The object that the CSS is being applied to.  If ommited,
    it will default to the object that called "css"
  - class: String? - A list of classes for the object.  This is similar to the
    "class" tag used in standard HTML/CSS
  - style: String? - A string of additional elements.  This is similar to the
    "style" tag used in standard HTML/CSS

The library searches for properties in the following order.  It will
keep the first value that it sees for a property

  - "style" values
  - "class" values - for each class (separated by a " ")
      - <class_name>.class
      - .class
  - class_name

Where the class_name is the name of the class that called the ".css" method.
For example

```swift
class MyController: UIViewController {
	@IBOutlet weak var label1: UILabel?
	
	func viewDidLoad() [
	    super.viewDidLoad()
	    self.css(object: self.label1, class: "bold label")
	}
}
```

will search for the following dictionaries

  - my_controller.bold
  - .bold
  - my_controller.label1
  - .label1
  - my_controller

Note there is an important distinction on how the ".css" method is called.
Using the above example, class_name = "my_controller".  We can also call
".css" directly from the "label1" object, but this will change the names of
the dictionaries that the library searches for.  For example

```swift
class MyController: UIViewController {
	@IBOutlet weak var label1: UILabel?
	
	func viewDidLoad() [
	    super.viewDidLoad()
	    self.label1.css(class: "bold label")
	}
}
```

will search for the following dictionaries

  - ui_label.bold
  - .bold
  - ui_label.label1
  - .label1
  - ui_label

This behavior may be desireable.  It depends on the application.

In cases where an element is subclassed, for example like "UIButton", you
may want to do the following

```swift
class MyButton: UIButton {
	
	override func awakeFromNib() {
	    super.awakeFromNib()
	    
	    self.css()
	}
	
}
```
This will search for the following dictionaries

  - my_button

#### [class] func cssConfig(class klass: String?, style: String?) -> ViewCSSConfig
The "cssConfig" method provides a way for the developer to access the config
object directly from either the class or the instance that is calling "css".
This is useful, for example, to get the font size in order to estimate how
big a table view cell will be when subclassing UITableViewCell.  This is shown below

```swift
class MyCustomCell: UITableViewCell {
    @IBOutlet weak var label: UILabel?
    
    override func awakFromNib() {
        super.awakeFromNib()
        
        self.css(object: self.label, class: "label")
    }
    
    class var cellHeight: CGFloat {
        let config = self.css(class: "label") // Note that "self" is "MyCustomCell"
        if let font = config.font.getFont() {
            // Estimate the height of the cell based on the font size
        }
    }
}
```

Note that the same value must be used for "class" and "style" for the library 
to get the correct config.

### UILabel/UITextView ".cssText" Method
In order to support different text manipulations, ViewCSS wraps the
"NSAttributedText" features to allow CSS to be applied to displayed text.
An example is shown below

```swift
class MyCustomCell: UITableViewCell {
    @IBOutlet weak var label: UILabel?
    
    override func awakFromNib() {
        super.awakeFromNib()
        
        self.css(object: self.label, class: "label")
    }
    
    var setText(_ text: String) {
        self.label?.cssText = text
    }
}
```

The ".cssText" method will use the CSS currently defined for the label object
(in this case class="label") in order to generate the text.  The following
properties are supported by the ".cssText" method

  - text-transform

#### span

As an added bonus, the ".cssText" method also supports the HTML "span"
element to allow portions of the text to be modified independently.  An 
example of this is shown below

```swift
class MyCustomCell: UITableViewCell {
    @IBOutlet weak var label: UILabel?
    
    override func awakFromNib() {
        super.awakeFromNib()
        
        self.css(object: self.label, class: "label")
    }
    
    var setText(firstName: String, lastName: String) {
        self.label?.cssText = "\(firstName)<span class="bold">\(lastName)</span>"
    }
}
```

The above example will use the current properties defined for the
"self.label" object for displaying the "firstName" and then use the 
properties listed in the "bold" class to display the "lastName".  Note
that this is one of the few places where inheritance is used in the 
library.  The "bold" span text will default to the "label" class and then
override any properties that are defined in the "bold" class.  Note that
from the attribute dictionary perspective, it will search the following
classes in the following order

  - my_custom_cell.bold
  - .bold
  - (inherited) my_custom_cell.label
  - (inherited) .label
  - (inherited) my_custom_cell

It basically operates the same as if you had passed the "bold" class in
first when calling ".css" during the initialization

```swift
self.css(object: self.label, class: "bold label")
```

Note that multiple classes and the style attribute are also supported.
Here is a more complex example

```swift
class MyCustomCell: UITableViewCell {
    @IBOutlet weak var label: UILabel?
    
    override func awakFromNib() {
        super.awakeFromNib()
        
        self.css(object: self.label, class: "right label", style="text-align:right;")
    }
    
    var setText(firstName: String, lastName: String) {
        self.label?.cssText = "\(firstName)<span class="link bar" style="text-transform:uppercase;">\(lastName)</span>"
    }
}
```

The attribute dictionary would be formed by looking for elements in the 
following order (keeping the first match)

  - "text-transform:uppercase;"
  - my_custom_cell.link
  - .link
  - my_custom_cell.bar
  - .bar
  - (inherited) "text-align:right;"
  - (inherited) my_custom_cell.bold
  - (inherited) .bold
  - (inherited) my_custom_cell.label
  - (inherited) .label
  - (inherited) my_custom_cell

Note that the above example is intended to illustrate the order in which the 
library parses the attribute dictionary.  It is not recommended to make examples 
that are this complicated.  

### Customizations
Sometimes there is a need to customize an additional element.  For example,
maybe a button is created that has a custom "bar" at the bottom and you
always want that to be the same color as the text.  There are 2 ways to do
this.

#### "custom" callback
The "custom" callback is an option on the CSS call.  It will call back once
the CSS has been applied.  Below is an example

```swift
class MyButton: UIButton {
	@IBOutlet weak var bar: UIView?
	
	override func awakeFromNib() {
	    super.awakeFromNib()
	    
	    self.css() { (config: ViewCSSConfig) in
	    	self.bar?.backgroundColor = config.color
	    }
	}
	
}
```

#### ViewCSSCustomizableProtocol
The "ViewCSSCustomizableProtocol" provides a similar option as above, but 
uses a protocol instead.  Below is an example

```swift
class MyButton: UIButton, ViewCSSCustomizableProtocol {
	@IBOutlet weak var bar: UIView?
	
	override func awakeFromNib() {
	    super.awakeFromNib()
	    
	    self.css()
	}
	
	func cssCustomize(object: Any?, class klass: String?, style: String?, config: ViewCSSConfig) {
	    self.bar?.backgroundColor = config.color
	}
	
}
```

Note that the "cssCustomize" method is called every time ".css" is called.  In
order to differentiate between the different calls, the "object", "class", and
"style" from the ".css" call are included in the callback.

### Font Size Scaling
iOS offers the user the ability to globally change their font size settings.
It is up to the application developer to implement this which can be extremely
cumbersome.  If you are using "ViewCSS", this is straight forward (this is the 
entire reason I thought to create this library).

ViewCSS defines the "font-size-scale" property which allows the developer to
automatically specify that a certain text element should scale.  Note that it
is still up to the developer to make sure the UI looks OK when the text is
scaled.

The library implements the scaling by applying the scale factor to the original
font size and rounding the font size to the nearest pixel to ensure there is
no strange aliasing.  The final font size will be in the "config.font.scaledSize"
attribute of the config object.  This is the attribute that the 
"config.font.getFont()" method uses.

There are 2 ways (possibly more) to do this

#### number
The *number* value for "font-size-scale" allows a number to be specified.
Using the CSS variables, the developer can do the following

```swift
let css: [String:Any] = [
    ":root": [
        "--global-font-size-scale": "1.0"
    ],
    "my_controller.label": [
        "font-size-scale": "var(--global-font-size-scale)"
    ]
]
```

This approach defines a global scaling factor in the CSS dictionary that can
then be changed by the developer based on the user's OS settings.  Remember,
these values are cached so you will want to do it BEFORE loading.  You can
force a cache flush by setting the CSS dictionary again.  (This is not 
recommended because it will affect user-experience)

#### auto
By setting the "font-size-scale" property to "auto", you are telling the
ViewCSS logic to decide automatically how much the font size should scale 
based on the user's OS settings.  The library will use the 
UIApplication.shared.preferredContentSizeCategory to get the user's setting
and a "0.1" increment of the scaling factor for each "tick".

Note that with auto, you are not in control of supplying maximums and things
like that.  You can use the *number* approach described above if you need
to customize the behavior

### Snooping
Snooping is a mechanism that provides a way to print out the initial values
that the application currently has in order to pre-intialize the dictionary.

To turn on snooping, set the "snoop" flag on the ViewCSSManager.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

    override init() {
        super.init()

        let css: [String:Any] = [
            // CSS Properties
        ]
        
        ViewCSSManager.shared.snoop = true
        ViewCSSManager.shared.setCSS(dict: css)
    }
}
```

Turning this on will do 2 things.

Firstly, if a class is specified in the ".css" call but no matching dictionary
is found, it will print the name with the current settings of the object.  For
example

```swift
class MyController: UIViewController {
	@IBOutlet weak var label1: UILabel?
	
	func viewDidLoad() [
	    super.viewDidLoad()
	    self.css(object: self.label1, class: "label")
	}
}
```

will print the following in the console

```
ViewCSSManager WARN: No match found for CSS class 'label' referenced from the object of type 'my_controller'
Properties for unknown class my_controller.label:
- {
  "font-size" : "15px",
  "text-align" : "left",
  "background-color" : "#FFA500FF",
  "color" : "#007AFFFF"
}
```

This is intended to alert you that you specified the use of a class but
the library didn't find one and it gives the suggested values.  Note that
the "ViewCSSManager WARN: No match found..." message prints even if "snoop"
is off.

The second thing snoop does is store all of the values and allows you to 
print them all at once, for example, when the app is backgrounded. This 
is done by calling the "printSnoop" method.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

    override init() {
        super.init()

        let css: [String:Any] = [
            // CSS Properties
        ]
        
        ViewCSSManager.shared.snoop = true
        ViewCSSManager.shared.setCSS(dict: css)
    }
    
     func applicationWillResignActive(_ application: UIApplication) {
        ViewCSSManager.shared.printSnoop()
    }
}
```

This will print the entire dictionary in json to the console.

### Performance
For performance, the configuration object is lazily created and then cached
so that subsequent calls with the same "class name", "class", and "style"
will reuse the cached value.

The cache is reset when the dictionary object is set.  If the CSS dictionary
can be updated while the application is running, for example, a new version
was fetched from the server, it is recommended not to reload the dictionary
until the application is reloaded.  This will ensure that the user experience
is consistent.

### UIColor Extension
ViewCSS adds 2 useful methods

#### UIColor?(name: String)
This constructor will create a UIColor object using any of the supported CSS 
color names, like "lightblue" or "yellowgreen"

#### UIColor?(css: String)
This constructor will create a UIColor object using any of the supported CSS
color methods, such as ```rgb(red, green, blue, [alpha])```.  This adds some 
interesting capabilities.  For example, you can make your applications primary
color be defined in the CSS dictionary.  For example

```swift
// ... In your CSS dictionary
let css: [String, Any] = [
    ":root" : [
        "--primary-color", "#456789FF"
    ]
]

// Somewhere else...
extension UIColor {
    class var primary: UIColor {
        return UIColor(css: "var(--primary-color") ?? UIColor.black
    }
}
```


