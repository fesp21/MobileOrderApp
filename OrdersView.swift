//
//  OrdersView.swift
//  
//
//  Created by Paul Sun on 8/29/17.
//
//
import Foundation
import UIKit

class OrdersView: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    //Outlets
    @IBOutlet weak var NavB: UINavigationBar!
    @IBOutlet weak var OrderTableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var Back: UIBarButtonItem!
    
    //Actions
    @IBAction func GoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func GoCheckout(_ sender: Any) {
        present(checkoutView!, animated: true, completion: nil)
    }
    
    //Variables
    var reviewOrderArray: [String] = []
    var reviewPriceArray: [Double] = []
    var cell = CustomCell()
    var checkoutView: CheckoutView? = nil
    var storyb = UIStoryboard()
    //var menu: MainMenu? = nil
    
    override func viewDidLoad() {
        
        if checkoutView == nil {
            let sb = UIStoryboard(name:"Main", bundle: nil)
            checkoutView = sb.instantiateViewController(withIdentifier: "Checkout") as? CheckoutView
            print("instanting checkout view")
            
        } else {
            print("Using old instantiation of checkout view")
        }
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        downSwipe.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(downSwipe)
        
        OrderTableView.delegate = self
        OrderTableView.dataSource = self
        
    }
    
    //TableView Protocol Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        cell = self.OrderTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.title.text = reviewOrderArray[indexPath.row]
       // cell.picview.image = UIImage(named: "coffee.jpg")
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  reviewOrderArray.count
    }
    //EDIT ORDERS
    //Allow editable rows
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    //Delete function
    //removes element at selected index path, for both drinkOrderArray and reviewOrderArray
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            reviewOrderArray.remove(at: indexPath.row)
            reviewPriceArray.remove(at: indexPath.row)
            OrderTableView.deleteRows(at: [indexPath], with: .fade)
            let totalPrice = reviewPriceArray.reduce(0, +) as NSNumber
            
            //String(describing) maybe what's causing the awkward format
            totalPriceLabel.text = "Total Cost: $" + String(describing: totalPrice)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell number \(indexPath.row).")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print(totalPriceLabel)
        let TPLval = reviewPriceArray.reduce(0,+)
       // let rounded = Double(round(1000 * TPLval)/1000)
        print(reviewPriceArray)
        totalPriceLabel.text = "Total Cost: $" + String(TPLval)
        OrderTableView.reloadData()
        
    }
}
