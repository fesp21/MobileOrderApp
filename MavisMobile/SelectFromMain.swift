//
//  ChoseFromMain.swift
//  MavisMobile
//
//  Created by Paul Sun on 8/29/17.
//  Copyright © 2017 Paul Sun. All rights reserved.
//
import Foundation
import UIKit

class SelectFromMain: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Variables
    var customCell = CustomCell()
    let indexPath = IndexPath()
    
    var addingOrder: Add? = nil //Next view
    let cellReuseIdentifier = "cell"
    var cell = CustomCell()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        downSwipe.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(downSwipe)
        
        MenuTableView.delegate = self
        MenuTableView.dataSource = self
    }
    
    //Arrays
    var chosenArray: [String] = [] //selected category from menu
    var priceArray: [Double] = []
    let descArray: [String] = ["keeps you up ALL night", "USA", "ICED nuff said", "La Tradicion"]
    
    //ORDER IMAGES
    // var  coffeeimages: [UIImage] = [UIImage(named: "coffee.jpg")!, UIImage(named: "coffee.jpg")!, UIImage(named: "coffee.jpg")!, UIImage(named: "coffee.jpg")!, UIImage(named: "coffee.jpg")!]
    
    //Outlets and Actions
    @IBOutlet weak var BackButton: UIBarButtonItem!
    @IBOutlet weak var NavBar: UINavigationBar!
    @IBOutlet weak var MenuTableView: UITableView!
    @IBOutlet weak var OrderViewButton: UIButton!
    
    
    @IBAction func OrdersViewAction(_ sender: Any) {
        if addingOrder?.drinkOrderArray.count == 0 {
            let alertController = UIAlertController(title: "You don't have any orders!", message: "To place an order, select an item from the menu and add it to your cart", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                (result: UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            present((addingOrder?.ordersView)!, animated: true, completion: nil)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MenuTableView.reloadData()
    }
    //back out of view
    @IBAction func BackAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //TableView Protocol Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rounded = Double(round(1000 * priceArray[indexPath.row])/1000)
        
        cell = self.MenuTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CustomCell
        //  cell.picview.image = self.coffeeimages[indexPath.row]
        cell.title.text = self.chosenArray[indexPath.row]
     
        
        //cell.foodDescription.text = self.descArray[indexPath.row]
        cell.price.text = String(rounded)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.chosenArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.present(addingOrder!, animated: true, completion: nil)
        //addingOrder?.NavBar
        addingOrder?.LabelText = chosenArray[indexPath.row]
        //label: name of item chosen
        //let drinkTitle = addingOrder?.LabelText
        
    //addingOrder?.selectDrinkLabel.text = drinkTitle
       
        //addingOrder?.chosenPriceArray.append(priceArray[indexPath.row])
        addingOrder?.priceLabelText = priceArray[indexPath.row]
        //append(priceArray.indexPath.row)
        
        print("cell number \(indexPath.row).")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
