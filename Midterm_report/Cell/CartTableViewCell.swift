//
//  CartTableViewCell.swift
//  Midterm_report
//
//  Created by MIKETSAI on 2021/7/2.
//

import UIKit
protocol CartTableViewCellDelegate {
    func updateCart(cell : CartTableViewCell, quantity: Int)
}

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    var quantity : Int = 0
    var delegate : CartTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        minusBtn.tag = 0
        plusBtn.tag = 1
        
        minusBtn.addTarget(self, action: #selector(didBtnPressed(_:)), for: .touchUpInside)
        plusBtn.addTarget(self, action: #selector(didBtnPressed(_:)), for: .touchUpInside)
        
    }
 
    @objc func didBtnPressed(_ sender : UIButton){
        if sender.tag == 1 {
            quantity += 1
        } else if quantity > 0{
            quantity -= 1
        }
        self.quantityLabel.text = String(describing: quantity)
        self.delegate?.updateCart(cell: self, quantity: quantity)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
