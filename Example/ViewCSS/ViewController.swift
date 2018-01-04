//
//  ViewController.swift
//  ViewCSS
//
//  Created by Eric Chapman on 12/29/2017.
//  Copyright (c) 2017 Eric Chapman. All rights reserved.
//

import UIKit
import ViewCSS

class ViewController: UIViewController, ViewCSSCustomizableProtocol {
    
    @IBOutlet weak var label1: UILabel?
    @IBOutlet weak var label2: UILabel?
    @IBOutlet weak var label3: UILabel?
    @IBOutlet weak var label4: UILabel?
    @IBOutlet weak var button1: UIButton?
    @IBOutlet weak var button2: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*self.css(object: self.label1, class: "label1")
        self.label2?.css(class: "label2")
        self.css(object: self.label3, class: "label3")
        self.label4?.css(class: "primary", style: "background-color:lightgray;text-align:center;") { (config: ViewCSSConfig) in
            self.label1?.backgroundColor = config.color
        }
        self.button1?.css(class: "bad_class")
        self.button2?.css()
        
        var config = self.cssConfig(class: "label1")
        print(String(describing: config))
        
        config = ViewController.cssConfig(class: "label1")
        print(String(describing: config))
        
        ViewCSSManager.shared.printSnoop()*/
    }
    
    func cssCustomize(object: Any?, class klass: String?, style: String?, config: ViewCSSConfig) {
        self.label1?.textColor = UIColor.red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

