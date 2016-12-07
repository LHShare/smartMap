//
//  AppDelegate.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/10.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //友盟分享key
    let UMAppKey = "56e50ed067e58e89620008ac"
    //高德key
    let APIKey = "7474caaaf52643ba8695b8d6a09d266e"
    //讯飞语音
    let IFlyKey = "564c08ec"
    
    func configAPIKey() {
        //设置apikey
        MAMapServices.sharedServices().apiKey = APIKey
        //定位
        AMapLocationServices.sharedServices().apiKey = APIKey
        //搜索
        AMapSearchServices.sharedServices().apiKey = APIKey
        //导航
        AMapNaviServices.sharedServices().apiKey = APIKey
    }
    
    func configIFlySpeech() {
        IFlySpeechUtility.createUtility("appid=\(IFlyKey),timeout=\("20000")")
        IFlySetting.setLogFile(LOG_LEVEL.LVL_NONE)
        IFlySetting.showLogcat(false)
        //设置语音合成的参数
        //合成的语速，取值范围0～100
        IFlySpeechSynthesizer.sharedInstance().setParameter("50", forKey: IFlySpeechConstant.SPEED())
        //合成的音量，取值范围0～100
        IFlySpeechSynthesizer.sharedInstance().setParameter("50", forKey: IFlySpeechConstant.VOLUME())
        //发音人，默认为“xiaoyan”,可以设置的参数列表可参考 个性发音人  列表
        IFlySpeechSynthesizer.sharedInstance().setParameter("vixr", forKey: IFlySpeechConstant.VOICE_NAME())
        //音频采样率，目前支持的采样率有16000和8000
        IFlySpeechSynthesizer.sharedInstance().setParameter("8000", forKey: IFlySpeechConstant.SAMPLE_RATE())
        //当你再租需要保存音频时，请在必要的地方加上这行
        IFlySpeechSynthesizer.sharedInstance().setParameter(nil, forKey: IFlySpeechConstant.TTS_AUDIO_PATH())
        
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //设置高德key
        configAPIKey()
        //设置讯飞语音
        configIFlySpeech()
        
        self.window = UIWindow()
        self.window?.frame = UIScreen.mainScreen().bounds
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        let nav = UINavigationController(rootViewController: MapController())
        let rootController = nav
        self.window?.rootViewController = rootController
        
        //设置友盟appkey
        UMSocialData.setAppKey(UMAppKey)
        UMSocialWechatHandler .setWXAppId("wxc0605839234b6173", appSecret: "f9cc06a6dae02e47a0da341efc53b96c", url: "http:www.baidu.com");
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        let result = UMSocialSnsService.handleOpenURL(url)
        if result == false {
            
        }
        return result
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

