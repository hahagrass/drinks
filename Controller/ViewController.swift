//
//  ViewController.swift
//  drinks
//
//  Created by Eddy Chen on 2020/2/27.
//  Copyright © 2020 Eddy Chen. All rights reserved.
//  firstShop跟secondSop都有完整功能,第三間店SheetDB超額所以沒建立sheetDB

import UIKit
import Lottie
import MapKit

class ViewController: UIViewController {
    
    
    
    
    
    //menu視窗
    @IBOutlet weak var shopMenu1: UIView!
    @IBOutlet weak var shopMenu2: UIView!
    @IBOutlet weak var shopMenu3: UIView!
    

    //關掉menu的button
    @IBAction func closeMenuButton1(_ sender: Any) {
        shopMenu1.isHidden = true  //隱藏menu view
    }
    @IBAction func closeMenuButton2(_ sender: Any) {
        shopMenu2.isHidden = true
    }
    @IBAction func closeMenuButton3(_ sender: Any) {
        shopMenu3.isHidden = true
    }
    
    //打開menu的button
    @IBAction func openMenuButton1(_ sender: Any) {
        shopMenu1.isHidden = false  //顯示menu view
        shopMenu1.transform = CGAffineTransform(scaleX: 0.3, y: 2) //將x方向的比例調小,y方向的比例調大
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [UIView.AnimationOptions.curveEaseOut,.allowUserInteraction], animations: {
            self.shopMenu1.transform = CGAffineTransform.identity   //將縮放比例還原
        }, completion: nil)
    }
    @IBAction func openMenuButton2(_ sender: Any) {
        shopMenu2.isHidden = false
        shopMenu2.transform = CGAffineTransform(scaleX: 0.3, y: 2) //將x方向的比例調小,y方向的比例調大
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [UIView.AnimationOptions.curveEaseOut,.allowUserInteraction], animations: {
            self.shopMenu2.transform = CGAffineTransform.identity   //將縮放比例還原
        }, completion: nil)
    }
    
    @IBAction func openMenuButton3(_ sender: Any) {
        shopMenu3.isHidden = false
        shopMenu3.transform = CGAffineTransform(scaleX: 0.3, y: 2) //將x方向的比例調小,y方向的比例調大
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [UIView.AnimationOptions.curveEaseOut,.allowUserInteraction], animations: {
            self.shopMenu3.transform = CGAffineTransform.identity   //將縮放比例還原
        }, completion: nil)
    }
    
    //segue傳值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstMap"{
            if let firstMap = segue.destination as? mapViewController {
                firstMap.firstMapTitle = "丸作食茶-台北內湖店 \n台北市內湖區內湖路一段591巷2號 \n(02)2659-1699"
                firstMap.latitude = 25.081230
                firstMap.longitude = 121.573208
                firstMap.annotationTitle = "丸作丸作"
                firstMap.phone = "0226591699"
                
                
            }
            
        }else if segue.identifier == "secondMap"{
            if let secondMap = segue.destination as? mapViewController{
                secondMap.secondMapTitle = "可不可熟成紅茶-台北伊通店 \n台北市中山區伊通街47號 \n(02)2517-5510"
                secondMap.latitude = 25.051143
                secondMap.longitude = 121.534958
                secondMap.annotationTitle = "可不可熟成紅茶"
                secondMap.phone = "0225175510"

            }
            
        }else if segue.identifier == "thirdMap"{
            if let thirdMap = segue.destination as? mapViewController{
                thirdMap.thirdMapTitle = "木子日青-松山概念店 \n台北市松山區民生東路三段130巷7弄1號 \n(02)2719-8987"
                thirdMap.latitude = 25.056706
                thirdMap.longitude = 121.546334
                thirdMap.annotationTitle = "木子日青"
                thirdMap.phone = "0227198987"
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //將shopMenu一開始隱藏起來
        shopMenu1.isHidden = true
        shopMenu2.isHidden = true
        shopMenu3.isHidden = true

        
        //一開始的動畫
        let animationView = AnimationView(name: "servishero_loading")
        animationView.frame = CGRect(x: 0, y: 0, width: 414, height: 725)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
            
        view.addSubview(animationView)
         
        animationView.play{(finished) in
            animationView.removeFromSuperview()  //播完動畫就關掉
        }
        
        
        
    }


}

