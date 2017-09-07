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
import Alamofire


class CheckoutView: UIViewController, STPPaymentContextDelegate {
   /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup add card view controller
        //let addCardViewController = STPAddCardViewController()
        
      //  addCardViewController.delegate = self as? STPAddCardViewControllerDelegate
        
        // Present add card view controller
       // let navigationController = UINavigationController(rootViewController: addCardViewController)
        
        
        
        //self.present(vc, animated: true, completion: nil)
        //present(navigationController, animated: true)
        
        // present(addCardViewController, animated: true)
    }
*/

    //Controllers
    private let customerContext: STPCustomerContext
    private let paymentContext: STPPaymentContext


    
    //Button
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBOutlet weak var handlePaymentButtonTapped: UIButton!
    
    @IBAction func handlePaymentButtonTapped(_ sender: Any) {
        presentPaymentMethodsViewController()
        
    }
    
    // MARK: Init
    required init?(coder aDecoder: NSCoder) {
        customerContext = STPCustomerContext(keyProvider: APIClient.sharedClient)
        paymentContext = STPPaymentContext(customerContext: customerContext)
        
        super.init(coder: aDecoder)
        
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    
    // MARK: Helpers
    private func presentPaymentMethodsViewController() {
        guard !STPPaymentConfiguration.shared().publishableKey.isEmpty else {
            // Present error immediately because publishable key needs to be set
            let message = "Please assign a value to `publishableKey` before continuing. See `AppDelegate.swift`."
            print(message)
          //  present(UIAlertController(message: message), animated: true)
            return
        }
        
        guard !(APIClient.sharedClient.baseURLString?.isEmpty)! else {
            // Present error immediately because base url needs to be set
            let message = "Please assign a value to `MainAPIClient.shared.baseURLString` before continuing. See `AppDelegate.swift`."
            print(message)
            // present(UIAlertController(message: message), animated: true)
            return
        }
        
        // Present the Stripe payment methods view controller to enter payment details
        paymentContext.presentPaymentMethodsViewController()
    }
    

    //STPPaymentMethodsDelegate
   
    // MARK: STPPaymentContextDelegate
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        if let customerKeyError = error as? APIClient.CustomerKeyError {
            switch customerKeyError {
            case .missingBaseURL:
                // Fail silently until base url string is set
                print("[ERROR]: Please assign a value to `MainAPIClient.shared.baseURLString` before continuing. See `AppDelegate.swift`.")
            case .invalidResponse:
                // Use customer key specific error message
                print("[ERROR]: Missing or malformed response when attempting to `MainAPIClient.shared.createCustomerKey`. Please check internet connection and backend response formatting.");
                
                }
        }
        else {
            // Use generic error message
            print("[ERROR]: Unrecognized error while loading payment context: \(error)");
            
        }
    }
    
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        // Reload related components
      //  reloadPaymentButtonContent()
      //  reloadRequestRideButton()
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
        // Create charge using payment result
        let paymentSource = paymentResult.source.stripeID
        
        APIClient.sharedClient.completeCharge(STPPaymentResult(source: paymentSource as! STPSourceProtocol), amount: 10) { [weak self] (error) in
            guard self != nil else {
                // View controller was deallocated
                return
            }
            guard error == nil else {
                // Error while requesting ride
                completion(error)
                return
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        switch status {
        case .success:
            // Animate active ride
            print("Order success!!")
        case .error:
            // Present error to user
            if let orderError = error as? APIClient.OrderError {
                switch orderError {
                case .missingBaseURL:
                    // Fail silently until base url string is set
                    print("[ERROR]: Please assign a value to `MainAPIClient.shared.baseURLString` before continuing. See `AppDelegate.swift`.")
                case .invalidResponse:
                    // Missing response from backend
                    print("[ERROR]: Missing or malformed response when attempting to `MainAPIClient.shared.requestRide`. Please check internet connection and backend response formatting.");
                   // present(UIAlertController(coder: "Could not request ride"), animated: true)
                }
            }
            else {
                // Use generic error message
                print("[ERROR]: Unrecognized error while finishing payment: \(String(describing: error))");
               // present(UIAlertController(coder: "Could not request ride"), animated: true)
            }
            
            // Reset ride request state
           // rideRequestState = .none
        case .userCancellation: break
            // Reset ride request state
           // rideRequestState = .none
        }
    }

    
    
    
    
    
    
    
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
