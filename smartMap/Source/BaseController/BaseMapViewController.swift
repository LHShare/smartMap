//
//  BaseMapViewController.swift
//  smartMap
//
//  Created by 刘刘欢 on 16/4/12.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

import Foundation

class BaseMapViewController: BaseViewController,MAMapViewDelegate,AMapNaviManagerDelegate,IFlySpeechSynthesizerDelegate {
    
    var mapView : MAMapView?
    var naviManager : AMapNaviManager?
    var iFlySpeechSynthesizer : IFlySpeechSynthesizer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化地图实例
        initMapView()
        //初始化导航实例
        initNaviManager()
        //初始化讯飞语音实例
        initIFlysSpeech()
    }
    
    override func backBtnClick() {
        super.backBtnClick()
        cleanMapView()
    }
    
    func cleanMapView() {
        mapView?.showsUserLocation = false
        mapView?.removeAnnotations(mapView?.annotations)
        mapView?.removeOverlays(mapView?.overlays)
        mapView?.delegate = nil
        naviManager = nil
        naviManager?.delegate = nil
        iFlySpeechSynthesizer?.delegate = nil
    }
    
    //MARK:初始化地图实例
    func initMapView() {
        if mapView == nil {
            mapView = MAMapView(frame: self.view.bounds)
        }
        mapView?.delegate = self
    }
    //MARK:初始化导航实例
    func initNaviManager() {
        if naviManager == nil {
            naviManager = AMapNaviManager()
        }
        naviManager?.delegate = self
    }

    //MARK:初始化讯飞语音实例
    func initIFlysSpeech() {
        if iFlySpeechSynthesizer == nil {
            iFlySpeechSynthesizer = IFlySpeechSynthesizer()
        }
        iFlySpeechSynthesizer?.delegate = self
    }
    
    func naviManager(naviManager: AMapNaviManager!, playNaviSoundString soundString: String!, soundStringType: AMapNaviSoundType) {
        if soundStringType == AMapNaviSoundType.PassedReminder {
            //用系统自带的声音做简单例子，播放其他提示音需要另外配置
            AudioServicesPlaySystemSound(1009);
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { 
                self.iFlySpeechSynthesizer?.startSpeaking(soundString)
            });
        }
    }
}
