//
//  CheckoutView.swift
//  
//
//  Created by Paul Sun on 8/29/17.
//
//
import Foundation
import UIKit
import Stripe

class CheckoutView: UIViewController {
    
    let stripePublishableKey = "pk_test_BAXmaVnR8AmqM0VKrcWYc7We"
    
    // MyAPIClient implements STPEphemeralKeyProvider (see above)
    // let customerContext = STPCustomerContext(keyProvider: MainAPIClient.sharedClient)
    
    let backendBaseURL: String? = "https://powerful-hamlet-29531.herokuapp.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup add card view controller
        let addCardViewController = STPAddCardViewController()
        
        addCardViewController.delegate = self as? STPAddCardViewControllerDelegate
        
        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        
        
        
        //self.present(vc, animated: true, completion: nil)
        present(navigationController, animated: true)
        
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

