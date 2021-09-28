//
//  SingletonCart.swift
//  Midterm_report
//
//  Created by MIKETSAI on 2021/7/2.
//

import Foundation
import UIKit

class SingletonCart {
    
    static var shared = SingletonCart()
    
    var shoppingcart : [Product] = []
        
    var total : Int {
        get {
            var sum = 0
            for item in shoppingcart{
                if item.inCart{
                    sum += item.subTotal
                }
            }
            return sum
        }
    }
}
