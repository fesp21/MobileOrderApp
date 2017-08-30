//
//  Add.swift
//  MavisMobile
//
//  Created by Paul Sun on 8/29/17.
//  Copyright © 2017 Paul Sun. All rights reserved.
//

import Foundation
import UIKit

class Add: UIViewController {
    
    //Outlets
    @IBOutlet weak var BackButton: UIBarButtonItem!
    @IBOutlet weak var AddOrderOutlet: UIButton!
    @IBOutlet weak var NavBar: UINavigationBar!
    // @IBOutlet public var selectDrinkLabel: UILabel!
    @IBOutlet weak var ReviewOrder: UIButton!
    
    //Outlet to table view. cells contain custom options
    @IBOutlet weak var describe: UILabel!
    
    //Actions
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ReviewOrderAction(sender: Any) {
        present(ordersView!, animated: true, completion: nil)
    }
    
    //Variables
    public var LabelText = String()
    public var priceLabelText = Double() //price label on table
    var ordersView: OrdersView? = nil
    var drinkOrderArray: [String] = [] //place order array
    var optionsArray: [String] = ["Size", "Milk", ""]
    var cell = CustomCell()
    var chosenPriceArray: [Double] = []
    var deleteIndexPath: NSIndexPath? = nil
    
    
    //Add to OrdersViewController array
    @IBAction func AddOrderAction(_ sender: Any) {
        //order matters! place .append array before defining "sum"
        chosenPriceArray.append(priceLabelText)
        drinkOrderArray.append(LabelText)
        ordersView?.reviewOrderArray.append(LabelText)
        ordersView?.reviewPriceArray.append(priceLabelText)
        
        print(priceLabelText)
        print(chosenPriceArray)
        print(drinkOrderArray)
        let amountInCart : Int = (ordersView?.reviewOrderArray.count)!
        let amountAsString = String(amountInCart)
        //shows how many orders currently is in cart
        ReviewOrder.setTitle( "cart: (" + amountAsString + ")", for: .normal)
        
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        downSwipe.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(downSwipe)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print(drinkOrderArray)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let amount : Int = (ordersView?.reviewOrderArray.count)!
        let amountString = String(amount)
        //shows how many orders currently is in cart
        ReviewOrder.setTitle("cart: (" + amountString + ")", for: .normal)
        
    }
    
}
//so any other view controller can have access to DOWNSWIPE
extension UIViewController {
    func swipeAction(swipe: UISwipeGestureRecognizer) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
