//
//  Product.swift
//  Midterm_report
//
//  Created by MIKETSAI on 2021/7/1.
//

import Foundation

class Product : Codable {
    
    var productName : String
    var productPrice : Int
    var inCart : Bool = false
    var numberBuy: Int = 0
    
    init(name: String, price: Int) {
        self.productName = name
        self.productPrice = price
    }
    
    var subTotal : Int {
        get{
            return productPrice * numberBuy
        }
    }
    
    
}
