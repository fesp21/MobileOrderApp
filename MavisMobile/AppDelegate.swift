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
    
    private let baseURLString: String = "https://aqueous-dawn-63582.herokuapp.com/"
    
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

    
    
    /*
     let stripePublishableKey = "pk_test_BAXmaVnR8AmqM0VKrcWYc7We"
     
     // MyAPIClient implements STPEphemeralKeyProvider (see above)
     // let customerContext = STPCustomerContext(keyProvider: MainAPIClient.sharedClient)
     
     let backendBaseURL: String? = "https://aqueous-dawn-63582.herokuapp.com/"
     
     //STPPaymentContextDelegateMethods
     //1.
     func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
     
     
     
     }
     
     let myAPIClient = APIClient()
     
     //2. Successfully completed purchase/selected payment method
     func paymentContext(_ paymentContext: STPPaymentContext,
     didCreatePaymentResult paymentResult: STPPaymentResult,
     completion: @escaping STPErrorBlock) {
     
     myAPIClient.completeCharge(STPPaymentResult.init(), amount: 10, completion: { (error: Error?) in
     if let error = error {
     completion(error)
     } else {
     completion(nil)
     }
     })
     }
     
     func paymentContext(_ paymentContext: STPPaymentContext,
     didFinishWith status: STPPaymentStatus,
     error: Error?) {
     
     switch status {
     case .error:
     print("error")
     //    self.showError(error)
     case .success:
     //self.showReceipt()
     print("success")
     case .userCancellation: break
     //    return // Do nothing
     }
     }
     
     func paymentContext(_ paymentContext: STPPaymentContext,
     didFailToLoadWithError error: Error) {
     self.navigationController?.popViewController(animated: true)
     // Show the error to your user, etc.
     }
     
     override func viewDidLoad() {
     super.viewDidLoad()
     
     // Setup add card view controller
     let addCardViewController = STPAddCardViewController()
     
     addCardViewController.delegate = self as? STPAddCardViewControllerDelegate
     
     // Present add card view controller
     let navigationController = UINavigationController(rootViewController: addCardViewController)
     
     
     
     //self.present(vc, animated: true, completion: nil)
     //present(navigationController, animated: true)
     
     // present(addCardViewController, animated: true)
     
     }
     
     @IBOutlet weak var navbar: UINavigationBar!
     @IBOutlet weak var back: UIBarButtonItem!
     
     //move to add payment button action
     override func viewDidAppear(_ animated: Bool) {
     // Setup add card view controller
     let addCardViewController = STPAddCardViewController()
     addCardViewController.delegate = self as? STPAddCardViewControllerDelegate
     // Present add card view controller
     let navigationController = UINavigationController(rootViewController: addCardViewController)
     present(navigationController, animated: true)
     }
     
     // MARK: STPAddCardViewControllerDelegate
     func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
     // Dismiss add card view controller
     dismiss(animated: true)
     }
     
     
     func submitTokenToBackend(token: STPToken, completion: (_ error:Error)->()){
     print("doing this")
     }
     
     func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
     submitTokenToBackend(token: token, completion: { (error: Error?) in
     if let error = error {
     // Show error in add card view controller
     completion(error)
     }
     else {
     // Notify add card view controller that token creation was handled successfully
     completion(nil)
     
     // Dismiss add card view controller
     dismiss(animated: true)
     }
     })
     }
     
     
     
     internal typealias RequestCompletion = (Int?, Error?) -> ()?
     
     private var completionBlock: RequestCompletion!
     
     func postStripeToken(token: STPToken) {
     
     let URL = "http://localhost/donate/payment.php"
     let params = ["stripeToken": token.tokenId,
     "amount": 10,
     "currency": "usd",
     "description": "hi"] as [String : Any]
     
     
     sessionManager.request(URL, method: .post, parameters: params).validate().responseJSON {  //URL).validate().responseJSON {
     response in
     switch response.result {
     case .success:
     
     // print(response.data?.debugDescription ?? <#default value#>)
     // print(response.response?.debugDescription ?? <#default value#>)
     
     //  let UIAlertViewController as UIAler
     var statusCode = 0
     if let unwrappedResponse = response.response {
     statusCode = unwrappedResponse.statusCode
     }
     self.completionBlock(statusCode, nil)
     
     break
     case .failure(let error):
     print("error - > \n    \(error.localizedDescription) \n")
     let statusCode = response.response?.statusCode
     self.completionBlock?(statusCode, error)
     break
     }
     }
     }
     }
     /*
     //STPPaymentConfiguration.shared().publishableKey =  "pk_test_BAXmaVnR8AmqM0VKrcWYc7We"
     @IBOutlet weak var navBar: UINavigationBar!
     
     @IBAction func dismissCheckoutView(_ sender: Any) {
     self.dismiss(animated: true, completion: nil)
     }
     
     @IBOutlet weak var paymentView: UIView!
     
     //STRIPE Variables
     let paymentCartTextField = STPPaymentCardTextField()
     let stripePublishableKey = "pk_test_BAXmaVnR8AmqM0VKrcWYc7We"
     let backendBaseURL: String? = "https://powerful-hamlet-29531.herokuapp.com/"
     let paymentContext: STPPaymentContext! = nil
     
     override func viewDidLoad() {
     super.viewDidLoad()
     
     //set up payment card text field
     paymentCartTextField.delegate = self as? STPPaymentCardTextFieldDelegate
     paymentView.addSubview(paymentCartTextField)
     
     // Do any additional setup after loading the view, typically from a nib.
     }
     
     //MARK: STPPaymentCardTextFieldDelegate
     /*
     func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
     // Toggle buy button state
     buyButton.enabled = textField.isValid
     }
     */
     
     override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     // Dispose of any resources that can be recreated.
     }
     
     */
     */
}
