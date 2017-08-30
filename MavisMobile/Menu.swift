//
//  Menu.swift
//  MavisMobile
//
//  Created by Paul Sun on 8/29/17.
//  Copyright © 2017 Paul Sun. All rights reserved.
//
import Foundation
import UIKit

class Menu: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Outlets and Actions
    @IBOutlet weak var mainMenu: UITableView!
    @IBOutlet weak var OrdersButton: UIButton!
    @IBAction func OrdersAction(_ sender: Any) {
        if selectFromMain?.addingOrder?.drinkOrderArray.count == 0 {
            let alertController = UIAlertController(title: "You don't have any orders!", message: "To place an order, select an item from the menu and add it to your cart", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                (result: UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            present((selectFromMain?.addingOrder?.ordersView)!, animated: true, completion: nil)
        }
    }
    //Variables
    var selectFromMain: SelectFromMain? = nil
    var cell = CustomCell()
    var catArray: [String] = ["Coffee", "Tea", "Specialty Drink", "Tea Latte", "Iced Tea", "Valrhona Chocolate (hot or iced)"]
    
    //Drink Choices Arrays
    var coffeeArray: [String] = ["Espresso", "Americano", "Iced Americano", "Traditional Macchiato (4oz)"]
    var teaArray: [String] = ["White Coconut Creme", "Earl Grey Creme", "Matcha Grande A", "Egyptian Chamomile (Decaf)"]
    var teaLatteArray: [String] = ["Green Tea Latte", "Iced Green Tea Latte", "Chai Latte", "Iced Chai Latte"]
    var specialArray: [String] = ["Praline' Almond Hazelnut", "Dulce and Gabbana", "Honeybee Latte (hot/iced)", "Ginger Latte"]
    var icedTeaArray: [String] = ["Hibiscus Cooler", "Classic Black", "Passionfruit Jasmine", "Garden of Eden"]
    var cocoArray: [String] = ["Jivara Milk Chocolate", "Manjari Dark Chocolate"]
    
    //Drink Prices Array
    var coffeCost: [Double] = [3.00, 3.50, 4.00, 3.50]
    var teaCost: [Double] = [4.25, 4.25, 5.00, 4.00]
    var teaLatteCost: [Double] = [5.00, 5.50, 5.00, 5.50]
    var specialCost: [Double] = [6.00, 6.00, 4.50, 4.50]
    var icedTeaCost: [Double] = [4.00, 4.00, 4.25, 4.25]
    var cocoCost: [Double] = [5.25, 5.50]
    
    //VIEW DID LOAD - APPEAR
    override func viewDidLoad() {
        
        //instantiate SelectFromMain
        if selectFromMain == nil {
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            selectFromMain = storyboard.instantiateViewController(withIdentifier: "CategorySelected") as? SelectFromMain
            print("creating new instantiation of  Select From Main")
        } else {
            
            //secondView.LabelText = drinkArray[indexPath.row]
            print("Using old instantiation of Select From Main")
        }
        
        //instantiate AddOrder
        if selectFromMain?.addingOrder == nil {
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            selectFromMain?.addingOrder = storyboard.instantiateViewController(withIdentifier: "AddOrder") as? Add
            print("creating new instantiation of add order")
        } else {
            
            //secondView.LabelText = coffeeArray[indexPath.row]
            print("Using old instantiation of add orer")
        }
        
        //instantiate OrdersView
        if selectFromMain?.addingOrder?.ordersView == nil {
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            selectFromMain?.addingOrder?.ordersView = storyboard.instantiateViewController(withIdentifier: "OrdersView") as? OrdersView
            print("Creating instantion of orders view")
        } else {
            //secondView.LabelText = drinkArray[indexPath.row]
            print("Using old instantiation of orders view")
        }
        
        mainMenu.delegate = self
        mainMenu.dataSource = self
        
    }
    
    
    //TableView Protocol Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        cell.title.text = self.catArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.catArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //selectFromMain?.LabelText = drinkArray[indexPath.row]//label: name of item chosen
        //let drinkTitle = secondView?.LabelText
        switch indexPath.row {
        case 0: selectFromMain?.chosenArray = coffeeArray
        selectFromMain?.priceArray = coffeCost
        break;
        case 1: selectFromMain?.chosenArray = teaArray
        selectFromMain?.priceArray = teaCost
        break;
        case 2: selectFromMain?.chosenArray = specialArray
        selectFromMain?.priceArray = specialCost
        break;
        case 3: selectFromMain?.chosenArray = teaLatteArray
        selectFromMain?.priceArray = teaLatteCost
        break;
        case 4: selectFromMain?.chosenArray = icedTeaArray
        selectFromMain?.priceArray = icedTeaCost
        break;
        case 5: selectFromMain?.chosenArray = cocoArray
        selectFromMain?.priceArray = cocoCost
        break;
        default: selectFromMain?.chosenArray = coffeeArray
        
        break;
        }
        
        print(String(describing: selectFromMain?.chosenArray))
        self.present(selectFromMain!, animated: true, completion: nil)
        
        
        print("cell number \(indexPath.row).")
    }
    
}
