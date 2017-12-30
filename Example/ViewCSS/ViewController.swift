//
//  ViewController.swift
//  ViewCSS
//
//  Created by Eric Chapman on 12/29/2017.
//  Copyright (c) 2017 Eric Chapman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label1: UILabel?
    @IBOutlet weak var label2: UILabel?
    @IBOutlet weak var label3: UILabel?
    @IBOutlet weak var label4: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.label1?.css(class: "subheading")
        self.label2?.css(class: "label2")
        self.label3?.css(class: "label3")
        self.label4?.css(style: "background-color:lightgray;text-align:center;", class: "primary")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

