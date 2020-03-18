//
//  secondShopListTableViewController.swift
//  drinks
//
//  Created by Eddy Chen on 2020/3/9.
//  Copyright © 2020 Eddy Chen. All rights reserved.
//

import UIKit

class secondShopListTableViewController: UITableViewController {

        @IBOutlet var drinksListTableView: UITableView!
        @IBOutlet weak var secondShopCupLabel: UILabel!
        @IBOutlet weak var secondShopPriceLabel: UILabel!

        
        
        var secondListArray = [secondDrinksInformation]()
        
        
        //訂單總杯數統計
        func updateOrderUI(){
            //用array的數量來統計杯數
            secondShopCupLabel.text = "杯數 : \(secondListArray.count)"
            

            
        }
        
        //訂單總金額統計
        func updatePriceUI(){
            //每次一開始金額都是0,用for迴圈run一次listArray對應位置的飲料價格後,每對應好一筆資料,就將該杯飲料的價錢往上加,直到迴圈結束
            //當迴圈結束後,跑完所有ListArry的資料,再將加總完畢的price存進最終的firstShopPriceLabel裡面
            var price = 0
            for i in 0 ..< secondListArray.count{
                if let money = Int(secondListArray[i].price){
                    price += money
                }
            }
            secondShopPriceLabel.text = "金額 : \(price)"

        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            

            
            
        }
        
        // 畫面載入完成後清空原本array裡的資料，重新載入修改後的資料
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            secondListArray.removeAll()
            getOrderList()
        }

        
        // MARK: - Table view data source

        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            

            return secondListArray.count  //照ListArray的數量顯示row數
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let information = secondListArray[indexPath.row]
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath) as? secondShopListTableViewCell
            else {
                    return UITableViewCell()

            }
            cell.cellinformationSecond = information  //要把ListArray對應的位置存進cellinformation顯示
            cell.updateUI(id: indexPath.row)   //用id對應位置後,比照位置更新cell內容資料
            return cell
            
        }
            
        
        
        // MARK: - JSON
        
        //取得訂單資料
            func getOrderList(){
        
                //把從sheetDB轉成api的網址貼上,並將網址轉換成URL編碼(percent-Encoding也稱作URL Encoding)
                let urlStr = "https://sheetdb.io/api/v1/yd96p3fdq9f90".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: urlStr!) //將網址字串轉換成url
        
        
                //背景抓取飲料訂單的資料
                let task = URLSession.shared.dataTask(with: url!) { (data, response,error) in
                    if let data = data, let content = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                        //因為資料的json格式為陣列,包著物件,所以[[String:Any]]
        
                        for order in content{
                            if let data = secondDrinksInformation(json: order){
                                self.secondListArray.append(data)
                            }
                        }
                        print(self.secondListArray)
        
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

        
    }


