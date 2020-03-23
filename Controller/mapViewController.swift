//
//  mapViewController.swift
//  drinks
//
//  Created by Eddy Chen on 2020/3/21.
//  Copyright © 2020 Eddy Chen. All rights reserved.
//

import UIKit
import MapKit

class mapViewController: UIViewController {
    
    
    @IBOutlet weak var shopTitleLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var firstMapTitle:String?  //接收viewController傳來的店家資料
    var secondMapTitle:String?
    var thirdMapTitle:String?
    
    var latitude:CLLocationDegrees?  //接收viewController傳來的經緯度
    var longitude:CLLocationDegrees?
    var annotationTitle:String?   //接收viewController傳來的店名
    var phone:String?       //接收viewController傳來的電話
    
    
    @IBAction func phoneButton(_ sender: Any) {
        
        //撥電話alert
        let controller = UIAlertController(title: "\(annotationTitle ?? "shop")", message: "確定要打電話嗎？", preferredStyle: .actionSheet)
        let phoneNumber = "\(phone ?? "022222-2222")"
        let phoneAction = UIAlertAction(title: "打電話給\(phoneNumber)" , style: .default){(_) in
            if let url = URL(string: "tel:\(phoneNumber)"){    //設定呼叫號碼
                if UIApplication.shared.canOpenURL(url){  //打開url,打電話
                    UIApplication.shared.open(url,options: [:], completionHandler: nil)
                }else{
                    print("無法開啟URL")
                }
            }
            print("撥出成功")
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(phoneAction)
        controller.addAction(cancelAction)
        present(controller,animated: true ,completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if firstMapTitle != nil{
            shopTitleLabel.text = firstMapTitle
            
        }else if secondMapTitle != nil{
            shopTitleLabel.text = secondMapTitle
            
        }else if thirdMapTitle != nil{
            shopTitleLabel.text = thirdMapTitle
        }
        
        
        //let latitude:CLLocationDegrees = maplatitude //緯度
        //let longitude:CLLocationDegrees = 2.294524  //經度
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude ?? 25.033678, longitude: longitude ?? 121.564885)  //產生出座標,帶入初始值(初始值內帶入剛剛宣告的經緯度)
                    
        let xScale:CLLocationDegrees = 0.01  //x
        let yScale:CLLocationDegrees = 0.01  //y
        let Span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: yScale, longitudeDelta: xScale)  //產生出顯示比例
                    
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: Span)  //產生出顯示區域
            
        map.setRegion(region, animated: true)  //顯示在地圖上(帶入要顯示的範圍,是否要動畫)
                    
        let annotation = MKPointAnnotation()  //產生一個大頭針
        annotation.coordinate = location   //將大頭針放在剛剛的宣告的座標location上
        if let annotationT = annotationTitle{
            annotation.title = "\(annotationT)"
        }
        annotation.subtitle = "Choose your drink"   //加入副標題
        map.addAnnotation(annotation)  //將大頭針顯示在地圖上
        
        


    }
    

}
