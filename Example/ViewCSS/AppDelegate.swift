//
//  AppDelegate.swift
//  ViewCSS
//
//  Created by Eric Chapman on 12/29/2017.
//  Copyright (c) 2017 Eric Chapman. All rights reserved.
//

import UIKit
import ViewCSS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Setup CSS
        let css: [String:Any] = [
            ":root": [
                "--main-color": "var(--main-second-color)",
                "--main-second-color": "pink",
            ],
            "ui_label": [
                "text-align": "right",
                "background-color": "pink",
            ],
            "ui_button": [
                "text-align": "left",
                "background-color": "orange",
                "text-shadow": "2px 2px 1px gray"
            ],
            "view_controller.label1": [
                "font-size": "30px",
                "font-size-scale": "0.5",
                "font-weight": "500",
                "color": "green",
                "text-transform": "uppercase",
                "text-align": "center",
            ],
            ".textView" : [
                "text-decoration-line" : "underline",
                "text-decoration-style" : "dotted",
                "text-decoration-color" : "green",
                "color" : "black",
            ],
            ".label2": [
                "font-size": "200%",
                "font-weight": "500",
                "text-align": "left",
                "color": "black",
                "background-color": "transparent",
                "text-shadow": "2px 2px 1px gray"
            ],
            ".label3": [
                "font-size": "120%",
                "font-weight": "900",
                "color": "green",
                "font-size-scale": "auto",
                "border-radius": "5px",
                "border-width": "5px",
                "border-color": "blue",
            ],
            ".primary": [
                "color": "white",
                "font-weight": "900",
                "font-size": "200%",
                "background-color": "var(--main-color)",
            ]
        ]
        ViewCSSManager.shared.setCSS(dict: css)
        ViewCSSManager.shared.snoop = true
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

