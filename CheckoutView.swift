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


class CheckoutView: UIViewController, STPPaymentContextDelegate, STPPaymentMethodsViewControllerDelegate {

    //Controllers
    private let customerContext: STPCustomerContext
    private let paymentContext: STPPaymentContext
    let serialQueue = DispatchQueue(label: "com.queue.Serial")


    // MARK: Init
    required init?(coder aDecoder: NSCoder) {
        customerContext = STPCustomerContext(keyProvider: APIClient.sharedClient)
        paymentContext = STPPaymentContext(customerContext: customerContext)
        
        super.init(coder: aDecoder)
        
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    //Button
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBOutlet weak var orderbutton: UIButton!
    @IBOutlet weak var handlePaymentButtonTapped: UIButton!
    
    @IBAction func handlePaymentButtonTapped(_ sender: Any) {
    /*
       presentPaymentMethodsVC()
        // Present the Stripe payment methods view controller to enter payment details
        // Setup payment methods view controller
       
        let paymentMethodsViewController = STPPaymentMethodsViewController(configuration: STPPaymentConfiguration.shared(), theme: STPTheme.default(), customerContext: customerContext, delegate: self as STPPaymentMethodsViewControllerDelegate)
        
        // Present payment methods view controller
        let navigationController = UINavigationController(rootViewController: paymentMethodsViewController)
        
        present(navigationController, animated: true)
      */
     presentPaymentMethodsVC()
 
    }
    
    @IBAction func requestPayment(_ sender: Any) {
        
        paymentContext.requestPayment()
    }
    
    // MARK: Helpers
    private func presentPaymentMethodsVC() {
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
        
        paymentContext.presentPaymentMethodsViewController()
    }
    // Present the Stripe payment methods view controller to enter payment details

    // MARK: STPPaymentMethodsViewControllerDelegate
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        // Dismiss payment methods view controller
     
        dismiss(animated: true)
        // Present error to user...
    }
    
    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        // Dismiss payment methods view controller
        dismiss(animated: true)
    }
    
    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        // Dismiss payment methods view controller
        dismiss(animated: true)
    }
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didSelect paymentMethod: STPPaymentMethod) {
        // Save selected payment method
        
        //selectedPaymentMethod = paymentMethod
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
