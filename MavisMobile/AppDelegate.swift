//
//  AppDelegate.swift
//  MavisMobile
//
//  Created by Paul Sun on 8/29/17.
//  Copyright © 2017 Paul Sun. All rights reserved.
//
import Foundation
import UIKit
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        STPPaymentConfiguration.shared().publishableKey = "pk_test_BAXmaVnR8AmqM0VKrcWYc7We"
        // do any other necessary launch configuration
        return true
    }
}
