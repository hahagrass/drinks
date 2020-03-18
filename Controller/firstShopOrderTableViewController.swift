//
//  firstShopOrderTableViewController.swift
//  drinks
//
//  Created by Eddy Chen on 2020/2/29.
//  Copyright © 2020 Eddy Chen. All rights reserved.
//

//丸作的訂購頁面
import UIKit

class firstShopOrderTableViewController: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    
    @IBOutlet weak var drinksPicker: UIPickerView!   //飲料項目picker
    @IBOutlet weak var ordererTextField: UITextField!  //訂購人
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!  //份量
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!   //冰量
    @IBOutlet weak var sugerSegmentedControl: UISegmentedControl!  //甜度
    @IBOutlet weak var toppingsSegmentedControl: UISegmentedControl!  //加料
    @IBOutlet weak var messageTextField: UITextField!   //特殊說明
    @IBOutlet weak var priceLabel: UILabel!  //價格
    
    
  
    
    
    var teaOrder = TeaChoicesData()  //tea的struct
    var drinksData:[DrinksList] = []  //DrinksList的struct
    var teaIndex = 0  //取得位置
    var drinksPrice = Int()
    
    
    
    let onlyTea = ["國寶冬瓜茶","茉莉綠茶","古樹蜜香紅茶","台灣四季春茶","台灣凍頂烏龍茶","手採冬片仔","QQ四季春"]  //大杯+5
    let teaBlend = ["國寶冬瓜青茶","國寶冬瓜檸檬","嚴選蜂蜜綠","蜂蜜檸檬","多多綠茶","綠茶青梅","冬瓜青梅","鳳梨青梅","大桔子冬瓜茶","大桔子四季春","大桔子冬瓜茶","招牌奶茶","焦糖奶茶","黑糖奶茶"]  //大杯+10
    
    
    
    //飲料size大杯加價
    @IBAction func sizeSelectSegmentedControl(_ sender: UISegmentedControl) {
        totalPriceUpdate()
    }
    
    //加料加價
    @IBAction func toppingSegmentedControl(_ sender: UISegmentedControl) {
        totalPriceUpdate()
        
    }
    
    //加入購物車按鈕
    @IBAction func orderButton(_ sender: Any) {
        if let orderer = ordererTextField.text, orderer.count > 0 {
            getOrder()
            sendDrinksOrderToServer()
            showAlertMessage(title:"\(drinksData[teaIndex].name)", message: "\(teaOrder.size) \n \(teaOrder.sugar.rawValue),\(teaOrder.ice.rawValue) \n 加購\(teaOrder.toppings.rawValue)")
        }else{
            showAlertMessage(title:"Error" , message: "請輸入訂購人名稱")
        }
  
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTeaMenu()   //載入丸作menu
        updatePriceUI()  //更新飲料價格
        
        //點選介面空白處收回鍵盤
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    //點選介面空白處收回鍵盤
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    

    


    // MARK: - get .txt menu
        
    //開啟丸作.txt,將資料讀取出來
    func getTeaMenu() {
        if let url = Bundle.main.url(forResource: "丸作", withExtension: "txt"), let content = try? String(contentsOf: url) {
            let menuArray = content.components(separatedBy: "\n") // 利用components將換行移除
            
            // 將丸作.txt茶飲名字和價格依序存入drinkData陣列
            for number in 0 ..< menuArray.count {
                if number % 2 == 0 {
                    let name = menuArray[number]
                    
                    if let price = Int(menuArray[number + 1]) {
                        drinksData.append(DrinksList(name: name, price: price))
                    } else {
                        print("轉型失敗")
                    }
                }
            }
        }
    }
    
    // MARK: - Table view

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 9
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }

    
    // MARK: - Picker view

        
    //有幾個類別
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    
    }
    
    //顯示飲料名的總數量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drinksData.count
        
    }
    
    //將飲料名顯示在picker上
    //titleForRow是設定要顯示在picker上的飲料名是第幾個位置row
    //component,可以用來判斷每個component要顯示的文字
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drinksData[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        teaIndex = row
        updatePriceUI()
        updateSizeSegmentedControl()
    }

    
    
    // MARK: - else function

    // 如果換飲料,size、甜度、冰塊、加料都要重新調整
    func updateSizeSegmentedControl(){
        sizeSegmentedControl.selectedSegmentIndex = 0
        iceSegmentedControl.selectedSegmentIndex = 0
        sugerSegmentedControl.selectedSegmentIndex = 0
        toppingsSegmentedControl.selectedSegmentIndex = 0
    }
    
    //更換飲料時,價錢會隨之變更
    func updatePriceUI(){
        priceLabel.text = "$ \(drinksData[teaIndex].price)"
    }
    
    //先提示加入訂單的確認訊息,後面要在加入沒有輸入到的項目
    func showAlertMessage(title:String,message:String){
        let confirm = UIAlertController(title: title, message: message, preferredStyle: .alert)  //產生AlertController
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)  // 產生確認按鍵
        confirm.addAction(okAction)  // 將確認按鍵加入AlertController
        self.present(confirm, animated: true, completion: nil)  // 顯示Alert
    }
    
    //點選return會關掉鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
    }
    
    //總價
    //應該可簡寫,有空來試試
    func totalPriceUpdate(){
        //中杯
        if onlyTea.contains(drinksData[teaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 0 && toppingsSegmentedControl.selectedSegmentIndex == 0{
            drinksPrice = drinksData[teaIndex].price
            priceLabel.text = "$ \(drinksPrice)"
            print(drinksPrice)
        }else if onlyTea.contains(drinksData[teaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 0 && toppingsSegmentedControl.selectedSegmentIndex != 0{
            drinksPrice = drinksData[teaIndex].price + 10
            priceLabel.text = "$ \(drinksPrice)"
            print(drinksPrice)
            
            
        }else if teaBlend.contains(drinksData[teaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 0 && toppingsSegmentedControl.selectedSegmentIndex == 0{
            drinksPrice = drinksData[teaIndex].price
            priceLabel.text = "$ \(drinksPrice)"
            print(drinksPrice)
        }else if teaBlend.contains(drinksData[teaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 0 && toppingsSegmentedControl.selectedSegmentIndex != 0{
            drinksPrice = drinksData[teaIndex].price + 10
            priceLabel.text = "$ \(drinksPrice)"
            print(drinksPrice)
            
            
        //大杯
        }else if onlyTea.contains(drinksData[teaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 1 && toppingsSegmentedControl.selectedSegmentIndex == 0{
            drinksPrice = drinksData[teaIndex].price + 5
            priceLabel.text = "$ \(drinksPrice)"
            print(drinksPrice)
        }else if onlyTea.contains(drinksData[teaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 1 && toppingsSegmentedControl.selectedSegmentIndex != 0{
            drinksPrice = drinksData[teaIndex].price + 15
            priceLabel.text = "$ \(drinksPrice)"
            print(drinksPrice)
            
            
        }else if teaBlend.contains(drinksData[teaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 1 && toppingsSegmentedControl.selectedSegmentIndex == 0{
            drinksPrice = drinksData[teaIndex].price + 10
            priceLabel.text = "$ \(drinksPrice)"
            print(drinksPrice)
        }else if teaBlend.contains(drinksData[teaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 1 && toppingsSegmentedControl.selectedSegmentIndex != 0{
            drinksPrice = drinksData[teaIndex].price + 20
            priceLabel.text = "$ \(drinksPrice)"
            print(drinksPrice)
        }
    }
    
    //取得訂單資料
    func getOrder(){
        
        //檢查是否已輸入訂購名稱
        guard let orderer = ordererTextField.text, orderer.count > 0 else{
            return showAlertMessage(title:"Error" , message: "請輸入訂購人名稱")
        }
        
        //姓名資料
        teaOrder.orderer = orderer
        print("訂購人:\(teaOrder.orderer)")
        
        //飲料資料
        teaOrder.drinks = drinksData[teaIndex].name
        print("飲料品項:\(teaOrder.drinks)")
        
        //容量資料
        if sizeSegmentedControl.selectedSegmentIndex == 0{
            teaOrder.size = "中杯"
        }else{
            teaOrder.size = "大杯"
        }
        print("容量:\(teaOrder.size)")
        
        //甜度資料
        switch sugerSegmentedControl.selectedSegmentIndex {
        case 0:
            teaOrder.sugar = .sugarFree
        case 1:
            teaOrder.sugar = .quarterSuger
        case 2:
            teaOrder.sugar = .halfSuger
        case 3:
            teaOrder.sugar = .lessSuger
        case 4:
            teaOrder.sugar = .regular
        default:
            break
        }
        print("甜度:\(teaOrder.sugar.rawValue)")   //rawValue.....
        
         //冰度資料
        switch iceSegmentedControl.selectedSegmentIndex {
        case 0:
            teaOrder.ice = .iceFree
        case 1:
            teaOrder.ice = .easyIce
        case 2:
            teaOrder.ice = .moreIce
        case 3:
            teaOrder.ice = .regular
        case 4:
            teaOrder.ice = .hot
        default:
            break
        }
        print("冰度:\(teaOrder.ice.rawValue)")
        
        //加料資料
        switch toppingsSegmentedControl.selectedSegmentIndex {
        case 0:
            teaOrder.toppings = .noadd
        case 1:
            teaOrder.toppings = .caramel
        case 2:
            teaOrder.toppings = .white
        case 3:
            teaOrder.toppings = .brownSugar
        case 4:
            teaOrder.toppings = .both
        case 5:
            teaOrder.toppings = .coconut
        default:
            break
        }
        print("是否加購:\(teaOrder.toppings.rawValue)")
        
        //備註欄
        if let message = messageTextField.text{
            teaOrder.message = message
            print("備註:\(message)")
        }
        
        //價格資料
        if let price = priceLabel.text{  //目前price有包含先前加入的 $符號
            let money = (price as NSString).substring(from: 2) //轉型成NSString後使用substring移除掉包含在price內的$符號
            teaOrder.price = money
        }
        print("價格:\(teaOrder.price)")
    }
    
   
    //傳送訂單資料到sheetDB
    func sendDrinksOrderToServer(){
        //post的API需要知道上傳的資料是什麼格式,所以依照API Documentation的規定去設定
        let url = URL(string: "https://sheetdb.io/api/v1/dmpt2jrczzwzq")
        var urlRequest = URLRequest(url: url!)
        
        //上傳資料所以設定為post
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //post所提供的API,Value為物件的陣列,所以用Dictionary實作
        let confirmOrder:[String:String] = ["orderer":teaOrder.orderer,"drinks":teaOrder.drinks,"size":teaOrder.size,"sugar":teaOrder.sugar.rawValue,"ice":teaOrder.ice.rawValue,"toppings":teaOrder.toppings.rawValue,"price":teaOrder.price,"message":teaOrder.message]
        
        
        //post API需要在物件內設定key值為data,value為一個物件的陣列
        let postData:[String: Any] = ["data" : confirmOrder]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: postData, options: []) //將data轉為JSON格式
            
            let task = URLSession.shared.uploadTask(with: urlRequest, from: data){ (retData, res, err) in //背景上傳資料
                
                NotificationCenter.default.post(name: Notification.Name("waitMessage"), object: nil, userInfo: ["message":true])
            }
            task.resume()
        }
        catch{
            
        }
    }
    
    
}


