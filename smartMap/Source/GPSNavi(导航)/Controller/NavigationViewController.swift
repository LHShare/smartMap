//
//  NaviViewController.swift
//  smartMap
//
//  Created by 刘刘欢 on 16/4/12.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

import Foundation

class NavigationViewController: BaseMapViewController,AMapLocationManagerDelegate,AMapSearchDelegate,AMapNaviViewControllerDelegate {
    
    
    //搜索
    var search : AMapSearchAPI?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "导航"
        configMapView()
    }
    
    //MARK:初始化地图
    func configMapView(){
        mapView!.frame = self.view.bounds
        mapView!.delegate = self
        //显示用户位置
        mapView?.showsUserLocation = false
        //添加定位图层
        mapView?.setUserTrackingMode(MAUserTrackingMode.Follow, animated: true)
        mapView?.customizeUserLocationAccuracyCircleRepresentation = true
        //后台定位
        mapView?.pausesLocationUpdatesAutomatically = false
        //地图样式
        mapView?.mapType = MAMapType.Standard
        //设置地图相机角度
        mapView?.cameraDegree = 0.0
        //罗盘位置
        mapView?.compassOrigin = CGPointMake(20, 80)
        mapView?.setCompassImage(UIImage(named: "compass@2x.png"))
        //支持旋转
        mapView?.rotateEnabled = true
        self.view.addSubview(mapView!)

        //初始化导航
        naviManager?.delegate = self
        
        //讯飞语音
        iFlySpeechSynthesizer?.delegate = self
        
        //搜素
        search = AMapSearchAPI()
        search?.delegate = self
    }
    
}
