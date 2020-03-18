//
//  ViewController.swift
//  drinks
//
//  Created by Eddy Chen on 2020/2/27.
//  Copyright © 2020 Eddy Chen. All rights reserved.
//

import UIKit
import Lottie
import MapKit

class ViewController: UIViewController {
    
    //map視窗
    @IBOutlet weak var map: MKMapView!
    
    //開map按鈕
    @IBAction func firstMapButton(_ sender: Any) {
    }
    
    @IBAction func secondMapButton(_ sender: Any) {
    }
    
    @IBAction func thirdMapButton(_ sender: Any) {
    }
    
    //menu視窗
    @IBOutlet weak var shopMenu1: UIView!
    @IBOutlet weak var shopMenu2: UIView!
    @IBOutlet weak var shopMenu3: UIView!
    
    //關掉menu的button
    @IBAction func closeMenuButton1(_ sender: Any) {
        shopMenu1.alpha = 0   //隱藏menu view
    }
    @IBAction func closeMenuButton2(_ sender: Any) {
        shopMenu2.alpha = 0
    }
    @IBAction func closeMenuButton3(_ sender: Any) {
        shopMenu3.alpha = 0
    }
    
    //打開menu的button
    @IBAction func openMenuButton1(_ sender: Any) {
        shopMenu1.alpha = 1     //顯示menu view
        shopMenu1.transform = CGAffineTransform(scaleX: 0.3, y: 2) //將x方向的比例調小,y方向的比例調大
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [UIView.AnimationOptions.curveEaseOut,.allowUserInteraction], animations: {
            self.shopMenu1.transform = CGAffineTransform.identity   //將縮放比例還原
        }, completion: nil)
    }
    @IBAction func openMenuButton2(_ sender: Any) {
        shopMenu2.alpha = 1
        shopMenu2.transform = CGAffineTransform(scaleX: 0.3, y: 2) //將x方向的比例調小,y方向的比例調大
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [UIView.AnimationOptions.curveEaseOut,.allowUserInteraction], animations: {
            self.shopMenu2.transform = CGAffineTransform.identity   //將縮放比例還原
        }, completion: nil)
    }
    
    @IBAction func openMenuButton3(_ sender: Any) {
        shopMenu3.alpha = 1
        shopMenu3.transform = CGAffineTransform(scaleX: 0.3, y: 2) //將x方向的比例調小,y方向的比例調大
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [UIView.AnimationOptions.curveEaseOut,.allowUserInteraction], animations: {
            self.shopMenu3.transform = CGAffineTransform.identity   //將縮放比例還原
        }, completion: nil)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //將shopMenu一開始隱藏起來
        shopMenu1.alpha = 0
        shopMenu2.alpha = 0
        shopMenu3.alpha = 0
        
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

