//
//  orderListTableViewCell.swift
//  drinks
//
//  Created by Eddy Chen on 2020/3/2.
//  Copyright © 2020 Eddy Chen. All rights reserved.
//


//所有飲料店家的訂購總統計頁面使用的cell
import UIKit

class firstShopListTableViewCell: UITableViewCell {
    
    
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
        orderLabel.text = "訂購人:\(cellinformation.orderer)"
        drinksLabel.text = "飲品:\(cellinformation.drinks)"
        sugarAndIceLabel.text = "甜度/冷熱:\(cellinformation.sugar)/\(cellinformation.ice)"
        toppingsLabel.text = "加料:\(cellinformation.toppings)"
        messageLabel.text = "備註:\(cellinformation.message)"
        sizeLabel.text = "size:\(cellinformation.size)"
        priceLabel.text = "金額:\(cellinformation.price)"
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
