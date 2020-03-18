//
//  TeaData.swift
//  drinks
//
//  Created by Eddy Chen on 2020/2/29.
//  Copyright © 2020 Eddy Chen. All rights reserved.
//

import Foundation

//讀取丸作、可不可、木子.txt
struct DrinksList {
    var name: String
    var price: Int
}

//讀取訂單內容
struct TeaChoicesData {
    var drinks:String    //飲料
    var orderer: String   //訂購人
    var size:String     //大小
    var ice:IceLevel    //冰量
    var sugar:SweetnessLevel  //甜度
    var toppings:Toppings  //加料
    var secondShopTopping:secondShopTopping  //第二間店 加料
    var thirdShopTopping:thirdShopTopping   //第三間店 加料
    var message:String  //特殊需求
    var price:String   //價格
    
    
    init(){
        drinks = ""
        orderer = ""
        size = ""
        ice = .regular
        sugar = .regular
        toppings = .noadd
        secondShopTopping = .noadd
        thirdShopTopping = .noadd
        message = ""
        price = ""
        
    }
}

//甜度等級
enum SweetnessLevel:String {
    case sugarFree = "無糖",quarterSuger = "微糖",halfSuger = "半糖",lessSuger = "少糖",regular = "正常"
}

//冰度等級
enum IceLevel:String{
    case hot = "熱飲",iceFree = "去冰",easyIce = "微冰",moreIce = "少冰",regular = "正常冰"
}

//加料
enum Toppings:String{
    case noadd = "無",caramel = "焦糖丸",white = "白玉丸",brownSugar = "黑糖丸",coconut = "椰果",both = "QQ"
}

//第二間的加料
enum secondShopTopping:String{
    case noadd = "無",white = "白玉珍珠"
}

//第三間的加料
enum thirdShopTopping:String{
    case noadd = "無",pearl = "手作珍珠",mesona = "手作仙草",coconut = "椰果"
}


struct cellData {
    var isOpen:Bool  //用來開關cell的bool
    var sectionTitle:String  //用來顯示統計頁面標題的string
    var sectionData:String
    
}




//現在在統計頁面要重新將POST的API串回來
//所以利用struct將json所解析的物件生成所有訂單資料

//取得第一間訂單內容
struct DrinksInformation: Codable {
    var orderer: String
    var drinks:String
    var size:String
    var sugar:String
    var ice:String
    var toppings:String
    var price:String
    var message:String
    
    init?(json:[String:Any]) {
        guard let orderer = json["orderer"] as? String,
            let drinks = json["drinks"] as? String,
            let size = json["size"] as? String,
            let sugar = json["sugar"] as? String,
            let ice = json["ice"] as? String,
            let toppings = json["toppings"] as? String,
            let price = json["price"] as? String,
            let message = json["message"] as?String
        
            else {
                return nil
            }
            self.orderer = orderer
            self.drinks = drinks
            self.size = size
            self.sugar = sugar
            self.ice = ice
            self.toppings = toppings
            self.price = price
            self.message = message
        
    }
}


//取得第二間訂單內容
struct secondDrinksInformation: Codable {
    var orderer: String
    var drinks:String
    var size:String
    var sugar:String
    var ice:String
    var toppings:String
    var price:String
    var message:String

    init?(json:[String:Any]) {
        guard let orderer = json["orderer"] as? String,
            let drinks = json["drinks"] as? String,
            let size = json["size"] as? String,
            let sugar = json["sugar"] as? String,
            let ice = json["ice"] as? String,
            let toppings = json["toppings"] as? String,
            let price = json["price"] as? String,
            let message = json["message"] as?String
    
            else {
                return nil
            }
            self.orderer = orderer
            self.drinks = drinks
            self.size = size
            self.sugar = sugar
            self.ice = ice
            self.toppings = toppings
            self.price = price
            self.message = message
    }
}


// 刪除sheetDB資料用
struct Order:Encodable {
    var drinksdata:DrinksInformation
}

