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

    private let publishableKey: String = "pk_test_BAXmaVnR8AmqM0VKrcWYc7We"
    
    private let baseURLString: String = "https://warm-everglades-27251.herokuapp.com/"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        STPPaymentConfiguration.shared().publishableKey = "pk_test_BAXmaVnR8AmqM0VKrcWYc7We"
        // do any other necessary launch configuration
        return true
    }
    
    override init() {
        super.init()
        
        // Stripe payment configuration
        STPPaymentConfiguration.shared().companyName = "Mavis"
        
        if !publishableKey.isEmpty {
            STPPaymentConfiguration.shared().publishableKey = publishableKey
        }
    
        // Stripe theme configuration
        STPTheme.default().primaryBackgroundColor = UIColor.lightGray
        STPTheme.default().primaryForegroundColor = UIColor.blue
        STPTheme.default().secondaryForegroundColor = UIColor.darkGray
        STPTheme.default().accentColor = UIColor.green
        
        // Main API client configuration
        APIClient.sharedClient.baseURLString = baseURLString
    }

}
