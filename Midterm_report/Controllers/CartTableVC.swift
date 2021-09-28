//
//  CartTableVC.swift
//  Midterm_report
//
//  Created by MIKETSAI on 2021/7/2.
//

import UIKit

class CartTableVC: UIViewController {
    

    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var data : [Product] = []
    
    var totalAmount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")

        self.tableView.dataSource = self
        self.tableView.delegate = self
        updataDataSource()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updataDataSource()
        print("viewWillAppear")
    }
    
    // Renew array by singleton cart
    func updataDataSource(){
        
        var updateCart : [Product] = []
        
        for item in SingletonCart.shared.shoppingcart{
            if item.inCart {
                updateCart.append(item)
            }
        }
        self.data = updateCart
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.totalAmount = SingletonCart.shared.total
            self.totalLabel.text = "Total: NT \(self.totalAmount)"
        }
    }

    
    @IBAction func checkoutBtnPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Total Amount is NT \(totalAmount)", message: "Your order has been sent successfully", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    

}
//MARK: - UITableViewDataSource
extension CartTableVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.data[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        
        if item.inCart {
            cell.nameLabel.text = item.productName
            cell.quantityLabel.text = "\(item.numberBuy)"
            cell.delegate = self
        } else {
//            cell.textLabel?.text = nil
//            cell.detailTextLabel?.text = nil
        }
        
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension CartTableVC : UITableViewDelegate {
    
    
}

//MARK: - CartTableViewCellDelegate
extension CartTableVC :  CartTableViewCellDelegate {
    func updateCart(cell: CartTableViewCell, quantity: Int) {
        
        guard  let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let cartItem = data[indexPath.row]
        // Update item quantity
        cartItem.numberBuy = quantity
        
        // Update UI
        totalAmount = SingletonCart.shared.total
        self.totalLabel.text = "Total: NT \(totalAmount)"
        
    }

}
