//
//  ViewController.swift
//  Midterm_report
//
//  Created by MIKETSAI on 2021/7/1.
//

import UIKit

class ProductTableVC: UIViewController {

    var data : [Product] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PviewDidLoad")

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        queryFromPHP()
        
        SingletonCart.shared.shoppingcart = data // Sava data to Singletoncart
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("PviewWillAppear")

//        self.cart = SingletonCart.shared.Cart
    }
    @IBAction func addBtn(_ sender: Any) {
        var textField = UITextField()
        var priceField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let productName = textField.text, let productPrice = Int(priceField.text!){
                let newItem = Product(name:productName, price: productPrice)
                self.data.append(newItem)
                SingletonCart.shared.shoppingcart = self.data

            }
            self.tableView.reloadData()

        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Input Product Name"
            textField = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Input Product Price"
            priceField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

        
    }
    
    
    func queryFromPHP() {
        //URLRequest, URLSession
        if let url = URL(string: "http://localhost:8888/shop_json.php"){

            var request = URLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response , error in
                if let e = error {
                    print("error : \(e)")
                    return
                }
                guard let responseData = data else {
                    return
                }
                
                do{
                    
                    if let allNotes = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String:Any]] {
                        for item in allNotes{
                            let productName = item["productName"]
                            print("productName:\(productName)")
                            let productPrice = item["productPrice"]
                            print("productPrice:\(productPrice)")
                            let product = Product(name: productName as! String , price: productPrice as! Int)
                            self.data.append(product)
                        }
                    }
                     
                    let content = String(data: responseData, encoding: .utf8)
                    print(content)
//                    let decoder = JSONDecoder()
//                    self.data = try decoder.decode([Product].self , from: responseData)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }catch{
                    print("error \(error)")
                }
            }
            task.resume()
        }

        
    }

}

//MARK: - UITableViewDataSource
extension ProductTableVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = self.data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = product.productName
        cell.detailTextLabel?.text = "NT " + String(product.productPrice)
        cell.accessoryType = product.inCart ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            self.data.remove(at: indexPath.row)
        }
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
}

//MARK: - UITableViewDelegate
extension ProductTableVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let product = self.data[indexPath.row]
        
        self.data[indexPath.row].inCart = !self.data[indexPath.row].inCart
        SingletonCart.shared.shoppingcart = self.data
        
        print(indexPath.row)

        self.tableView.reloadData()
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
