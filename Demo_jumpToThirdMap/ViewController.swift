//
//  ViewController.swift
//  Demo_jumpToThirdMap
//
//  Created by MC on 2018/5/29.
//  Copyright © 2018年 MC. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseSetting()
        
        initUI()
    }
    
    
    // MARK: - Action
    @objc func jumpToMapClicked() {
        
        let latitute = 31.248499
        let longitute = 121.360095
        let endAddress = "上海市金沙江路3131号"
        
        let alter = UIAlertController.init(title: "请选择导航应用程序", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancle = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (a) in
        }
        
        let action1 = UIAlertAction.init(title: "苹果地图", style: UIAlertActionStyle.default) { (b) in
            self.appleMap(lat: latitute, lng: longitute, destination: endAddress)
        }
        
        let action2 = UIAlertAction.init(title: "高德地图", style: UIAlertActionStyle.default) { (b) in
            self.amap(dlat: latitute, dlon: longitute, dname: endAddress, way: 0)
        }
        
        let action3 = UIAlertAction.init(title: "百度地图", style: UIAlertActionStyle.default) { (b) in
            
            self.baidumap(endAddress: endAddress, way: "driving", lat: latitute,lng: longitute)
        }
        
        alter.addAction(action1)
        alter.addAction(action2)
        alter.addAction(action3)
        alter.addAction(cancle)
        
        self.present(alter, animated: true, completion: nil)
    }
    
    
    // 打开苹果地图
    func appleMap(lat:Double,lng:Double,destination:String){
        let loc = CLLocationCoordinate2DMake(lat, lng)
        let currentLocation = MKMapItem.forCurrentLocation()
        let toLocation = MKMapItem(placemark:MKPlacemark(coordinate:loc,addressDictionary:nil))
        toLocation.name = destination
        MKMapItem.openMaps(with: [currentLocation,toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: "true"])
    }
    
    // 打开高德地图
    func amap(dlat:Double,dlon:Double,dname:String,way:Int) {
        let appName = "app的名字"
        
        let urlString = "iosamap://path?sourceApplication=\(appName)&dname=\(dname)&dlat=\(dlat)&dlon=\(dlon)&t=\(way)" as NSString
        
        if self.openMap(urlString) == false {
            print("您还没有安装高德地图")

        }
    }
    
    // 打开百度地图
    func baidumap(endAddress:String,way:String,lat:Double,lng:Double) {
        
        let coordinate = CLLocationCoordinate2DMake(lat, lng)
        
        
        let baidu_coordinate = getBaiDuCoordinateByGaoDeCoordinate(coordinate: coordinate)
        
        let destination = "\(baidu_coordinate.latitude),\(baidu_coordinate.longitude)"
        
        
        let urlString = "baidumap://map/direction?" + "&destination=" + endAddress + "&mode=" + way + "&destination=" + destination
        
        let str = urlString as NSString
        
        if self.openMap(str) == false {
            print("您还没有安装百度地图")
        }
    }
    
    // 打开第三方地图
    private func openMap(_ urlString: NSString) -> Bool {

        
        let url = NSURL(string:urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)

        if UIApplication.shared.canOpenURL(url! as URL) == true {
            UIApplication.shared.openURL(url! as URL)
            return true
        } else {
            return false
        }
    }
    
    // 高德经纬度转为百度地图经纬度
    func getBaiDuCoordinateByGaoDeCoordinate(coordinate:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(coordinate.latitude + 0.006, coordinate.longitude + 0.0065)
    }

    
    // MARK: - Method
    func baseSetting() {
        self.view.backgroundColor = UIColor.white
    }
    
    func initUI() {
        self.view.addSubview(jumpToMap)
    }
    
    // MARK: - Setter & Getter
    lazy var jumpToMap: UIButton = {
        let button = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect.init(x: 10, y: 100, width: self.view.frame.size.width - 20, height: 50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("跳转到第三方地图", for: .normal)
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(jumpToMapClicked), for: .touchUpInside)
        return button
    }()
}

