//
//  secondShopOrderTableViewController.swift
//  drinks
//
//  Created by Eddy Chen on 2020/3/4.
//  Copyright © 2020 Eddy Chen. All rights reserved.
//


//可不可的訂單頁面
import UIKit

class secondShopOrderTableViewController: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var drinksPicker: UIPickerView!
    @IBOutlet weak var ordererTextField: UITextField!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sugerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var secondToppingsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    var teaOrder = TeaChoicesData() //tea的struct,用來讀取訂單內容
    var secondDrinksData:[DrinksList] = []  //DrinksList的struct
    var secondTeaIndex = 0  //取得位置
    var secondDrinksPrice = Int()
    
    let onlyTea = ["熟成紅茶","麗春紅茶","太妃紅茶","胭脂紅茶","熟成冷露","雪花冷露","春芽冷露","春芽綠茶",""]  //大杯+5
    let teaBlend = ["雪藏紅茶","春梅冰茶","冷露歐蕾","熟成歐蕾","白玉歐蕾"]  //大杯+10
    
    @IBAction func sizeSelectSegmentedControl(_ sender: Any) {
        totalPriceUpdate()
        
    }
    
    @IBAction func toppingSegmentedControl(_ sender: Any) {
        totalPriceUpdate()
    }
    
    @IBAction func orderButton(_ sender: Any) {
        if let orderer = ordererTextField.text,orderer.count > 0 {
            getSecondShopOrder()
            sendDrinksOrderToServer()
            showAlertMessage(title:"\(secondDrinksData[secondTeaIndex].name)", message: "\(teaOrder.size) \n \(teaOrder.sugar.rawValue),\(teaOrder.ice.rawValue) \n 加購\(teaOrder.secondShopTopping.rawValue)")
        }else{
            showAlertMessage(title:"Error" , message: "請輸入訂購人名稱")
        }
        
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getSecondTeaMenu()   //一開始就先讀取資料
        secondShopUpdatePrice() //一開始隨畫面的飲料名稱更新飲料價錢
        
        //點選介面空白處收回鍵盤
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap)

    }
    //點選介面空白處收回鍵盤
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 9
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    // MARK: - Picker view
    
    //回傳幾個類別的picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //回傳顯示飲料名字的數量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        secondDrinksData.count
    }
    
    //將顯示文字在picker上
    //titleForRow是設定要顯示在picker上的文字是第幾個位置row
    //這邊第三個參數component,可以用來判斷每個component要顯示的文字
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        secondDrinksData[row].name
    }
    
    //改變選擇後執行的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        secondTeaIndex = row //取得新的row位置
        secondShopUpdatePrice() //更新對應row飲料的價錢
        updateSizeSegmentedControl() //將所有的segmentedControl還原到第一格
    }
    
    
    // MARK: - 讀取.txt檔

    // 開啟可不可熟成.txt，將資料讀取出來
    func getSecondTeaMenu(){
        //指定檔案路徑 -> 將檔案內容加載到String
        if let url = Bundle.main.url(forResource: "可不可熟成", withExtension: "txt"),let content = try? String(contentsOf: url){
            let secondMenuArray = content.components(separatedBy: "\n")  //並利用components將換行移除
            
            // 將可不可熟成.txt茶飲名字和價格依序存入secondDrinkData陣列
            for number in 0..<secondMenuArray.count{
                if number % 2 == 0 {  //跑一次檔案,找出2的倍數,並將2的倍數對應列的飲料名稱存進name內
                    let name = secondMenuArray[number]
                    
                    if let price = Int(secondMenuArray[number + 1]){ //單數列則存進價格
                        secondDrinksData.append(DrinksList(name: name, price: price))
                        
                    }else{
                        print("轉型失敗")
                    }
                }
            }
            
        }
    }
    
    // MARK: - else function
    
    //價格更新
    func secondShopUpdatePrice(){
        priceLabel.text = "$ \(secondDrinksData[secondTeaIndex].price)"
    }
    
    //picker變動時,segmentedControl一起還原成1
    func updateSizeSegmentedControl(){
        sizeSegmentedControl.selectedSegmentIndex = 0
        iceSegmentedControl.selectedSegmentIndex = 0
        sugerSegmentedControl.selectedSegmentIndex = 0
        secondToppingsSegmentedControl.selectedSegmentIndex = 0
    }
    
    //總價
    //應該可以簡寫成一個for迴圈,有空來試試
    func totalPriceUpdate(){
        //中杯
        //若包含onlyTea內的飲料名 及 sizeSegmentedControl的位置在0的時候
        if onlyTea.contains(secondDrinksData[secondTeaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 0 && secondToppingsSegmentedControl.selectedSegmentIndex == 0{
            secondDrinksPrice = secondDrinksData[secondTeaIndex].price
            priceLabel.text = "$ \(secondDrinksPrice)"
            print(secondDrinksPrice)
            
        //若包含onlyTea內的飲料名 及 sizeSegmentedControl的位置不在0的時候
        }else if onlyTea.contains(secondDrinksData[secondTeaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 0 && secondToppingsSegmentedControl.selectedSegmentIndex != 0{
            secondDrinksPrice = secondDrinksData[secondTeaIndex].price + 10
            priceLabel.text = "$ \(secondDrinksPrice)"
            print(secondDrinksPrice)
            
        //若包含teaBlend內的飲料名 及 sizeSegmentedControl的位置在0的時候
        }else if teaBlend.contains(secondDrinksData[secondTeaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 0 && secondToppingsSegmentedControl.selectedSegmentIndex == 0{
            secondDrinksPrice = secondDrinksData[secondTeaIndex].price
            priceLabel.text = "$ \(secondDrinksPrice)"
            print(secondDrinksPrice)
        }else if teaBlend.contains(secondDrinksData[secondTeaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 0 && secondToppingsSegmentedControl.selectedSegmentIndex != 0{
            secondDrinksPrice = secondDrinksData[secondTeaIndex].price + 10
            priceLabel.text = "$ \(secondDrinksPrice)"
            print(secondDrinksPrice)
            
            
        //大杯
        }else if onlyTea.contains(secondDrinksData[secondTeaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 1 && secondToppingsSegmentedControl.selectedSegmentIndex == 0{
            secondDrinksPrice = secondDrinksData[secondTeaIndex].price + 5
            priceLabel.text = "$ \(secondDrinksPrice)"
            print(secondDrinksPrice)
        }else if onlyTea.contains(secondDrinksData[secondTeaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 1 && secondToppingsSegmentedControl.selectedSegmentIndex != 0{
            secondDrinksPrice = secondDrinksData[secondTeaIndex].price + 15
            priceLabel.text = "$ \(secondDrinksPrice)"
            print(secondDrinksPrice)
            
            
        }else if teaBlend.contains(secondDrinksData[secondTeaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 1 && secondToppingsSegmentedControl.selectedSegmentIndex == 0{
            secondDrinksPrice = secondDrinksData[secondTeaIndex].price + 10
            priceLabel.text = "$ \(secondDrinksPrice)"
            print(secondDrinksPrice)
            
        }else if teaBlend.contains(secondDrinksData[secondTeaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 1 && secondToppingsSegmentedControl.selectedSegmentIndex != 0{
            secondDrinksPrice = secondDrinksData[secondTeaIndex].price + 20
            priceLabel.text = "$ \(secondDrinksPrice)"
            print(secondDrinksPrice)
        }else if secondDrinksData[secondTeaIndex].name == "熟成檸果"{
            if sizeSegmentedControl.selectedSegmentIndex == 1{
                showAlertMessage(title: "熟成檸果只有中杯喲",message: "請選擇中杯或是換茶飲品項")
                sizeSegmentedControl.selectedSegmentIndex = 0
            }else if secondToppingsSegmentedControl.selectedSegmentIndex != 0{
                secondDrinksPrice = secondDrinksData[secondTeaIndex].price + 10
                priceLabel.text = "$ \(secondDrinksPrice)"
                print(secondDrinksPrice)
            }
            
            
        }

    }
    
    
    // 提示訊息
    func showAlertMessage(title: String, message: String) {
        let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) // 產生AlertController
        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil) // 產生確認按鍵
        inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController
        self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
    }
    
    //點選return會關掉鍵盤

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
    }
    
    //讀取訂購單的資料
    func getSecondShopOrder(){
        
        //先確認ordererTextField有沒有輸入值,沒有的話跳出提醒
        guard let orderer = ordererTextField.text, orderer.count > 0 else {
            return showAlertMessage(title:"Error" , message: "請輸入訂購人名稱")
        }
        
        //姓名資料
        teaOrder.orderer = orderer
        print("訂購人:\(teaOrder.orderer)")
        
        //飲料資料
        teaOrder.drinks = secondDrinksData[secondTeaIndex].name
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
        switch secondToppingsSegmentedControl.selectedSegmentIndex {
        case 0:
            teaOrder.secondShopTopping = .noadd
        case 1:
            teaOrder.secondShopTopping = .white
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
        let url = URL(string: "https://sheetdb.io/api/v1/yd96p3fdq9f90")
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
