//
//  firstShopListTableViewController.swift
//  drinks
//
//  Created by Eddy Chen on 2020/3/9.
//  Copyright © 2020 Eddy Chen. All rights reserved.
//

import UIKit

class firstShopListTableViewController: UITableViewController {

        @IBOutlet var drinksListTableView: UITableView!
        @IBOutlet weak var firstShopCupLabel: UILabel!
        @IBOutlet weak var firstShopPriceLabel: UILabel!

        
        var ListArray = [DrinksInformation]()

        
        
    
        //訂單總杯數統計
        func updateOrderUI(){
            //用array的數量來統計杯數
            firstShopCupLabel.text = "杯數 : \(ListArray.count)"
            print(ListArray.count)
            
        }
        
        //訂單總金額統計
        func updatePriceUI(){
            //每次一開始金額都是0,用for迴圈run一次listArray對應位置的飲料價格後,每對應好一筆資料,就將該杯飲料的價錢往上加,直到迴圈結束
            //當迴圈結束後,跑完所有ListArry的資料,再將加總完畢的price存進最終的firstShopPriceLabel裡面
            var price = 0
            for i in 0 ..< ListArray.count{
                if let money = Int(ListArray[i].price){
                    price += money
                }
            }
            firstShopPriceLabel.text = "金額 : \(price)"
            
        }


    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
        }
        
        // 畫面載入完成後清空原本array裡的資料，重新載入修改後的資料
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            ListArray.removeAll()
            getOrderList()
        }
    
    

        
        // MARK: - Table view data source

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            

            return ListArray.count  //照ListArray的數量顯示row數
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let information = ListArray[indexPath.row]
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as? firstShopListTableViewCell
            else {
                    return UITableViewCell()

            }
            cell.cellinformation = information  //要把ListArray對應的位置存進cellinformation顯示
            cell.updateUI(id: indexPath.row)   //用id對應位置後,比照位置更新cell內容資料
            return cell
            
        }
    
    
        // 刪除cell資料
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == UITableViewCell.EditingStyle.delete{
                let drinks = ListArray[indexPath.row]
                deleteOrderList(ListArray: drinks) // 呼叫刪除sheetDB裡資料的function
                ListArray.remove(at: indexPath.row) // 移除陣列裡的資料
                tableView.deleteRows(at: [indexPath], with: .automatic) // 刪除這個row
                tableView.reloadData() // 重新載入tableView
                updatePriceUI() // 更新總金額
                updateOrderUI() // 更新總杯數
            }
        }
            
        
        
        // MARK: - JSON
        
        //取得訂單資料
            func getOrderList(){
        
                //把從sheetDB轉成api的網址貼上,並將網址轉換成URL編碼(percent-Encoding也稱作URL Encoding)
                let urlStr = "https://sheetdb.io/api/v1/dmpt2jrczzwzq".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: urlStr!) //將網址字串轉換成url
        
        
                //背景抓取飲料訂單的資料
                let task = URLSession.shared.dataTask(with: url!) { (data, response,error) in
                    if let data = data, let content = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                        //因為資料的json格式為陣列,包著物件,所以[[String:Any]]
        
                        for order in content{
                            if let data = DrinksInformation(json: order){
                                self.ListArray.append(data)
                            }
                        }
                        print(self.ListArray)
        
                        //UI的更新必須在Main thread
                        DispatchQueue.main.async {
                            //更新table view
                            self.drinksListTableView.reloadData()  //更新訂購表
                            self.updateOrderUI() //更新訂單數量
                            self.updatePriceUI() //更新總價
        
                        }
                    }
                }
                task.resume() //開始在背景下載資料
        
            }
    
    
    //刪除sheetDB訂單資料
    //這邊用訂購人的名字做為條件,若符合條件就會刪掉該筆資料,若有多筆資料符合,就會刪掉多筆資料
    func deleteOrderList(ListArray:DrinksInformation) {
        if let urlStr = "https://sheetdb.io/api/v1/dmpt2jrczzwzq/orderer/\(ListArray.orderer)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr){
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let List = Order(drinksdata: ListArray)
            let jsonEncoder = JSONEncoder()
            print(List)
            if let data = try? jsonEncoder.encode(List){
                let task = URLSession.shared.uploadTask(with: urlRequest, from: data){(retData,response, error)in
                    let decoder = JSONDecoder()
                    if let retData = retData , let dic = try? decoder.decode([String:Int].self, from:retData),dic["deleted"] == 1{
                        print("Successfully deleted")
                    }else{
                        print("Failed to delete")
                    }
                }
                task.resume()
            }else{
                print("Delete")
            }
        }
    }
    

        
}
