//
//  secondShopOrderListTableViewCellTableViewCell.swift
//  drinks
//
//  Created by Eddy Chen on 2020/3/9.
//  Copyright © 2020 Eddy Chen. All rights reserved.
//

import UIKit

class secondShopListTableViewCell: UITableViewCell {

        @IBOutlet weak var orderLabel: UILabel!
        @IBOutlet weak var drinksLabel: UILabel!
        @IBOutlet weak var sugarAndIceLabel: UILabel!
        @IBOutlet weak var toppingsLabel: UILabel!
        @IBOutlet weak var sizeLabel: UILabel!
        @IBOutlet weak var messageLabel: UILabel!
        @IBOutlet weak var priceLabel: UILabel!
        

        
        var cellinformation: DrinksInformation!
        var cellinformationSecond: secondDrinksInformation!
        
        func updateUI(id:Int){
            orderLabel.text = "訂購人:\(cellinformationSecond.orderer)"
            drinksLabel.text = "飲品:\(cellinformationSecond.drinks)"
            sugarAndIceLabel.text = "甜度/冷熱:\(cellinformationSecond.sugar)/\(cellinformationSecond.ice)"
            toppingsLabel.text = "加料:\(cellinformationSecond.toppings)"
            messageLabel.text = "備註:\(cellinformationSecond.message)"
            sizeLabel.text = "size:\(cellinformationSecond.size)"
            priceLabel.text = "金額:\(cellinformationSecond.price)"
        }

        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    }
