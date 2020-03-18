//
//  thirdShopOrderTableViewController.swift
//  drinks
//
//  Created by Eddy Chen on 2020/3/4.
//  Copyright © 2020 Eddy Chen. All rights reserved.
//


//好的,由於sheetDB的api免費帳戶只能用2個,所以這個就先跟第二間飲料店的資料併再一起囉囉囉囉
import UIKit

class thirdShopOrderTableViewController: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    
    @IBOutlet weak var drinksPicker: UIPickerView!
    @IBOutlet weak var ordererTextField: UITextField!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sugerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var thirdToppingsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    var teaOrder = TeaChoicesData() //tea的struct,用來讀取訂單內容
    var thirdDrinksData:[DrinksList] = []
    var thirdTeaIndex = 0
    var thirdDrinksPrice = Int()
    
    
    //只有大杯的size
    let onlyLarge = ["坪林包種青茶","神農獎蜜香紅茶","神農獎鐵觀音茶","松柏嶺四季紅茶","錫蘭紅茶","茉香綠茶","烏龍綠茶","烏龍青茶","古法熬煮冬瓜茶","仙草甘茶","仙草冬瓜茶","冬瓜青茶","純龍眼蜜茶","百香綠茶","檸檬綠茶","甘蔗包種青茶","金桔檸檬汁","冬瓜檸檬","綠養樂多輕飲","綠多酚輕飲","青檸檬多酚輕飲","冬瓜鮮豆奶","蘋果醋冰茶","梅子醋冰茶"]
    
    //大杯+5元
    let onlyTea = ["蜜蜂掉進奶茶","紅茶","綠茶","烏龍","包種青","蜜香紅","四季紅","鐵觀音","原味鮮豆奶"]
    
    
    @IBAction func sizeSegmentedControl(_ sender: Any) {
        totalPriceUpdate()
    }
    
    @IBAction func thirdToppingsSegmentedControl(_ sender: Any) {
        totalPriceUpdate()
    }
    @IBAction func orderButton(_ sender: Any) {
        if let orderer = ordererTextField.text,orderer.count > 0 {
            getThirdShopOrder()
            sendDrinksOrderToServer()
            showAlertMessage(title:"\(thirdDrinksData[thirdTeaIndex].name)", message: "\(teaOrder.size) \n \(teaOrder.sugar.rawValue),\(teaOrder.ice.rawValue) \n 加購\(teaOrder.thirdShopTopping.rawValue)")
        }else{
            showAlertMessage(title:"Error" , message: "請輸入訂購人名稱")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getThirdTeaMenu()   //一開始就先讀取資料
        thirdShopUpdatePrice() //一開始隨畫面的飲料名稱更新飲料價錢
        
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
    func getThirdTeaMenu() {
        if let url = Bundle.main.url(forResource: "木子", withExtension: "txt"), let content = try? String(contentsOf: url) {
            let menuArray = content.components(separatedBy: "\n") // 利用components將換行移除
            
            // 將丸作.txt茶飲名字和價格依序存入drinkData陣列
            for number in 0 ..< menuArray.count {
                if number % 2 == 0 {
                    let name = menuArray[number]
                    
                    if let price = Int(menuArray[number + 1]) {
                        thirdDrinksData.append(DrinksList(name: name, price: price))
                    } else {
                        print("轉型失敗")
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    
    
    // MARK: - Picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return thirdDrinksData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return thirdDrinksData[row].name
    }
    
    //變動picker時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        thirdTeaIndex = row
        thirdShopUpdatePrice()
        updateSizeSegmentedControl()
        //將drinksPicker存成空
    }
    
    
    
    // MARK: - else function

    // 如果換飲料,size、甜度、冰塊、加料都要重新調整
    func updateSizeSegmentedControl(){
        sizeSegmentedControl.selectedSegmentIndex = 0
        iceSegmentedControl.selectedSegmentIndex = 0
        sugerSegmentedControl.selectedSegmentIndex = 0
        thirdToppingsSegmentedControl.selectedSegmentIndex = 0
    }
    
    //更換飲料時,價錢會隨之變更
    func thirdShopUpdatePrice(){
        priceLabel.text = "$ \(thirdDrinksData[thirdTeaIndex].price)"
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
    //應該可以簡寫成一個for迴圈,有空來試試
    func totalPriceUpdate(){
        //中杯
        //若包含onlyTea內的飲料名 及 sizeSegmentedControl的位置在0的時候
        if onlyLarge.contains(thirdDrinksData[thirdTeaIndex].name) {
            if sizeSegmentedControl.selectedSegmentIndex == 1{
                showAlertMessage(title: "只有中杯喲",message: "請選擇中杯或是換茶飲品項")
                sizeSegmentedControl.selectedSegmentIndex = 0
            }else if thirdToppingsSegmentedControl.selectedSegmentIndex != 0{
                thirdDrinksPrice = thirdDrinksData[thirdTeaIndex].price + 10
                priceLabel.text = "$ \(thirdDrinksPrice)"
                print(thirdDrinksPrice)
            }
            
        }else if onlyTea.contains(thirdDrinksData[thirdTeaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 0 && thirdToppingsSegmentedControl.selectedSegmentIndex == 0{
        thirdDrinksPrice = thirdDrinksData[thirdTeaIndex].price
        priceLabel.text = "$ \(thirdDrinksPrice)"
        print(thirdDrinksPrice)
        

        }else if onlyTea.contains(thirdDrinksData[thirdTeaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 0 && thirdToppingsSegmentedControl.selectedSegmentIndex != 0{
            thirdDrinksPrice = thirdDrinksData[thirdTeaIndex].price + 10
            priceLabel.text = "$ \(thirdDrinksPrice)"
            print(thirdDrinksPrice)
            
            
        //大杯
        }else if onlyTea.contains(thirdDrinksData[thirdTeaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 1 && thirdToppingsSegmentedControl.selectedSegmentIndex == 0{
            thirdDrinksPrice = thirdDrinksData[thirdTeaIndex].price + 5
            priceLabel.text = "$ \(thirdDrinksPrice)"
            print(thirdDrinksPrice)
        }else if onlyTea.contains(thirdDrinksData[thirdTeaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 1 && thirdToppingsSegmentedControl.selectedSegmentIndex != 0{
            thirdDrinksPrice = thirdDrinksData[thirdTeaIndex].price + 15
            priceLabel.text = "$ \(thirdDrinksPrice)"
            print(thirdDrinksPrice)
                        
            
        }

    }
    
    //讀取訂購單的資料
    func getThirdShopOrder(){
        
        //先確認ordererTextField有沒有輸入值,沒有的話跳出提醒
        guard let orderer = ordererTextField.text, orderer.count > 0 else {
            return showAlertMessage(title:"Error" , message: "請輸入訂購人名稱")
        }
        
        //姓名資料
        teaOrder.orderer = orderer
        print("訂購人:\(teaOrder.orderer)")
        
        //飲料資料
        teaOrder.drinks = thirdDrinksData[thirdTeaIndex].name
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
        switch thirdToppingsSegmentedControl.selectedSegmentIndex {
        case 0:
            teaOrder.thirdShopTopping = .noadd
        case 1:
            teaOrder.thirdShopTopping = .pearl
        case 2:
            teaOrder.thirdShopTopping = .mesona
        case 3:
            teaOrder.thirdShopTopping = .coconut
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
