//
//  ViewController.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/10.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

//主页面

import UIKit


class MapController: BaseMapViewController,AMapLocationManagerDelegate,UISearchBarDelegate,AMapSearchDelegate,AMapNaviViewControllerDelegate {
    
    //导航枚举
    internal enum NavigationType : Int {
        case None
        case Simulator//模拟导航
        case GPS//实时导航
    }
    
    let lockUpMapRotate = "lockUpMapRotate"
    let hideBigAndSmallButton = "hideBigAndSmallButton"
    let hide2dAnd3dButton = "hide2dAnd3dButton"
    
    let showLockUpMapRotate = "noLockUpMapRotate"
    let showBigAndSmallButton = "showBigAndSmallButton"
    let show2dAnd3dButton = "show2dAnd3dButton"
    let showSpeakResultLocation = "speakResultNotification"
    
//    //地图对象
//    var mapView:MAMapView?
//    //导航对象
//    var naviManager : AMapNaviManager?
//    //讯飞语音对象
//    var iFlySpeechSyn : IFlySpeechSynthesizer?
    
    var locationManager:AMapLocationManager?
    var completionBlock:AMapLocatingCompletionBlock?
    var width : CGFloat?
    var height : CGFloat?
    var zoomLevel : CGFloat?
    var isShowTraffic : Bool?
    var coverView : UIView?
    var viewBg : UIView?
    var btn3 : UIButton?
    var mapTypeBtn : UIButton?
    var cameraDegreeBtn : UIButton?
    var searchBar : UISearchBar?
    //用户当前位置
    var newUserLocation : Dictionary<String,String>?
    //用户搜索的位置
    var userSearchLocation : Dictionary<String,String>?
    var annotationArray : NSMutableArray?
    var accountTool : AccountTool?
    
    //放大按钮
    var bigButton : UIButton?
    //缩小按钮
    var smallButton : UIButton?
    //2d/3d按钮
    var angleButton : UIButton?
    //路况按钮
    var roadButtun : UIButton?
    
    
    //路径规划成功
    var calRuteSuccess : Bool?
    //导航类型
    var naviType : NavigationType?
    
    //搜索
    var search : AMapSearchAPI?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        mapView?.delegate = self
        naviManager?.delegate = self
        if naviManager == nil {
            naviManager = AMapNaviManager()
            naviManager?.delegate = self
        }
//        if iFlySpeechSynthesizer == nil {
//            iFlySpeechSynthesizer = IFlySpeechSynthesizer()
//            iFlySpeechSynthesizer?.delegate = self
//        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBar?.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化MAMapView
        configMapView()
        //地图最开始的缩放级是12级
        initData()
        //初始化AMapLocationServices
        initLocationManager()
        //创建界面
        buildView()
        //初始化定位block
        initCompleteBlock()
        //第一次启动，自动定位
        self.locationManager?.requestLocationWithReGeocode(true, completionBlock: self.completionBlock)
        //添加罗盘遮盖
        addCompassCover()
        //添加通知监听
        addNotificationObserver()
        accountTool = AccountTool.shareAccountTool()
        //开始路径规划不成功
        calRuteSuccess = false
        //默认导航类型为模拟导航
        naviType = NavigationType.Simulator
    }
    
    //MARK:-----－－－－－－－－－－－－-通知方法
    //MARK:锁定地图旋转
    func lockUpMaproate() {
        roadButtun?.hidden = true
    }
    //MARK:隐藏放大／缩小按钮
    func hideBigASmallButton() {
        bigButton?.hidden = true
        smallButton?.hidden = true
    }
    //MARK:隐藏2d／3d按钮
    func hideTowAndThreeButton() {
        angleButton?.hidden = true
    }
    
    //MARK:不锁定地图旋转
    func noLockUpMaproate() {
        roadButtun?.hidden = false
    }
    //MARK:显示放大／缩小按钮
    func showBigASmallButton() {
        bigButton?.hidden = false
        smallButton?.hidden = false
    }
    //MARK:显示2d／3d按钮
    func showTwoAndThreeButton() {
        angleButton?.hidden = false
    }
    
    //MARK:显示语音输入结果
    func showSpeakLocation(let notification : NSNotification) {
        let locationName : String = notification.userInfo!["location"] as! String
        //调起正向地理编码
        let geo : AMapGeocodeSearchRequest?
        geo = AMapGeocodeSearchRequest()
        geo?.address = locationName
        search?.AMapGeocodeSearch(geo)
    }
    
    //MARK:添加通知监听
    func addNotificationObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapController.notificationObserver(_:)), /*"notificationObserver:",*/ name: "searchTableViewCellNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapController.lockUpMaproate), name: lockUpMapRotate, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapController.hideBigASmallButton), name: hideBigAndSmallButton, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapController.hideTowAndThreeButton), name: hide2dAnd3dButton, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapController.noLockUpMaproate), name: showLockUpMapRotate, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapController.showBigASmallButton), name: showBigAndSmallButton, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapController.showTwoAndThreeButton), name: show2dAnd3dButton, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapController.showSpeakLocation), name: showSpeakResultLocation, object: nil)
    }
    
    
    
    //在swift中取出了dealloc方法，而是添加了deinit析构方法，用以释放控制器中的对象
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver("searchTableViewCellNotification")
        NSNotificationCenter.defaultCenter().removeObserver(lockUpMapRotate)
        NSNotificationCenter.defaultCenter().removeObserver(hideBigAndSmallButton)
        NSNotificationCenter.defaultCenter().removeObserver(hide2dAnd3dButton)
        NSNotificationCenter.defaultCenter().removeObserver(showLockUpMapRotate)
        NSNotificationCenter.defaultCenter().removeObserver(showBigAndSmallButton)
        NSNotificationCenter.defaultCenter().removeObserver(show2dAnd3dButton)
        NSNotificationCenter.defaultCenter().removeObserver(showSpeakResultLocation)
    }
    
    
    //MARK:正向地理编码回调，提供地址，返回经纬度
    func onGeocodeSearchDone(request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        if response.geocodes.count == 0 {
            return
        } else {
            let geoCode : AMapGeocode?
            geoCode = response.geocodes[0] as? AMapGeocode
            let dict : Dictionary<String,String> = ["targetLatitude": String((geoCode?.location.latitude)!),"targetLogitude": String((geoCode?.location.longitude)!),"name" : request.address]
            userSearchLocation = dict
//            //根据经纬度显示在地图上
            let latitude : Double = Double((geoCode?.location.latitude)!)
            let longitude : Double = Double((geoCode?.location.longitude)!)
            
            let annotation : MAPointAnnotation? = MAPointAnnotation()
            annotation?.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            annotation?.title = request.address
            annotationArray?.addObject(annotation!)
            mapView?.addAnnotation(annotation)
            let array = [annotation!]
            mapView?.showAnnotations(array, animated: true)
        }
    }
    
    //MARK:搜索的通知方法，显示搜索位置
    func notificationObserver(notification : NSNotification) {
        
        let dict : Dictionary<String,String> = NSDictionary(dictionary: notification.userInfo!) as! Dictionary<String, String>
        userSearchLocation = dict
        //根据经纬度显示在地图上
        for annotation in annotationArray! {
            mapView?.removeAnnotation(annotation as! MAAnnotation)
        }
        let latitudeString = dict["targetLatitude"]
        let longitudeString = dict["targetLogitude"]
        let latitude : Double? = Double(latitudeString!)
        let longitude : Double? = Double(longitudeString!)
        let address : String = dict["name"]!
        let annotation : MAPointAnnotation? = MAPointAnnotation()
        annotation?.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        annotation?.title = address
        annotationArray?.addObject(annotation!)
        mapView?.addAnnotation(annotation)
        let array = [annotation!]
        mapView?.showAnnotations(array, animated: true)
    }
    
    //MARK: 初始化数据
    func initData() {
        width = self.view.frame.size.width
        height = self.view.frame.size.height
        zoomLevel = mapView?.zoomLevel
        //默认不开启路况
        isShowTraffic = false
        annotationArray = NSMutableArray()
    }
    
    //MARK:初始化定位的block
    func initCompleteBlock() {
        weak var weakSelf :  MapController?
        weakSelf = self
        self.completionBlock = {(location : CLLocation!,regeocode : AMapLocationReGeocode!, error : NSError!) -> Void in
            if (error) != nil {
                
            }
            if (location) != nil {
                let annotation = MAPointAnnotation()
                annotation.coordinate = location.coordinate
                
                if (regeocode) != nil {
                    annotation.title = NSString(string: "\(regeocode.formattedAddress)") as String
                } else {
                    annotation.title = NSString(string: "\(location.coordinate.latitude, location.coordinate.longitude)") as String
                }
                
                let mapController : MapController? = weakSelf
                mapController!.addAnnotationToMapView(annotation)
            }
        }
    }
    
    //MARK:添加大头针
    func addAnnotationToMapView(annotation : MAAnnotation) {
        mapView?.addAnnotation(annotation)
        mapView?.setZoomLevel((mapView?.zoomLevel)!, animated: true)
        mapView?.setCenterCoordinate(annotation.coordinate, animated: true)
    }
    
    //MARK:创建界面
    func buildView() {
        //放大按钮
        bigButton = createBtn(CGRectMake(self.width! - 60, self.height! - 210, 30, 30), backgroundImageName: "default_navi_zoomin_normal@2x.png", tag: 100, action: #selector(MapController.btnClick(_:)))
        //缩小按钮
        smallButton = createBtn(CGRectMake(self.width! - 60, self.height! - 185, 30, 30), backgroundImageName: "default_navi_zoomout_normal@2x.png", tag: 101, action: #selector(MapController.btnClick(_:)))
        //2d与3d视角以及地图类型切换按钮
        angleButton = createBtn(CGRectMake(self.width! - 60, 80, 30, 30), backgroundImageName: "change.png", tag: 104, action: #selector(MapController.btnClick(_:)))
        //路况按钮
        roadButtun = createBtn(CGRectMake(self.width! - 60, 120, 30, 30), backgroundImageName: "icon_traffic_off.png", tag: 102, action: #selector(MapController.btnClick(_:)))
        //定位按钮
        createBtn(CGRectMake(30, self.height! - 180, 30, 30), backgroundImageName: "btn_location.png", tag: 103, action: #selector(MapController.btnClick(_:)))
        //头部搜索框
        var searchBg : UIView?
        searchBg = UIView(frame: CGRectMake(5, 30, self.width! - 10, 44))
        searchBg?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(searchBg!)
        
//        var searchBar : UISearchBar?
        searchBar = UISearchBar(frame: CGRectMake(40, 0, (searchBg?.frame.size.width)! - 80, 44))
        searchBar?.barTintColor = UIColor.whiteColor()
        searchBar?.searchBarStyle = UISearchBarStyle.Minimal
        searchBar?.placeholder = "搜索地点、公交、地铁"
        searchBar?.translucent = true
        searchBar?.delegate = self
        searchBar?.showsCancelButton = false
        searchBar?.translatesAutoresizingMaskIntoConstraints = false
        searchBg!.addSubview(searchBar!)
        
        var lineView : UIView?
        lineView = UIView(frame: CGRectMake((searchBar?.frame.size.width)! + 40, 11, 1, 22))
        lineView?.backgroundColor = UIColor.lightGrayColor()
        searchBg?.addSubview(lineView!)
        
        var lineView1 : UIView?
        lineView1 = UIView(frame: CGRectMake(CGRectGetMinX((searchBar?.frame)!), 11, 1, 22))
        lineView1?.backgroundColor = UIColor.lightGrayColor()
        searchBg?.addSubview(lineView1!)
        
        var spakeBtn : UIButton?
        let x = ((searchBg?.frame.size.width)! - (lineView?.frame.origin.x)!) / 2 + (lineView?.frame.origin.x)!
        spakeBtn = UIButton(type: UIButtonType.Custom)
        spakeBtn?.setBackgroundImage(UIImage(named: "spake.png"), forState: UIControlState.Normal)
        spakeBtn?.adjustsImageWhenHighlighted = false
        spakeBtn?.backgroundColor = UIColor.clearColor()
        spakeBtn?.bounds = CGRectMake(0, 0, 33, 33)
        spakeBtn?.center = CGPointMake(x, 22)
        spakeBtn?.addTarget(self, action: #selector(MapController.spakeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        searchBg?.addSubview(spakeBtn!)
        
        var menuBtn : UIButton?
        menuBtn = UIButton(type: UIButtonType.Custom)
        menuBtn?.setBackgroundImage(UIImage(named: "usercoin.png"), forState: UIControlState.Normal)
        menuBtn?.adjustsImageWhenHighlighted = false
        menuBtn?.backgroundColor = UIColor.clearColor()
        menuBtn?.bounds = CGRectMake(0, 0, 22, 42)
        menuBtn?.center = CGPointMake(20, 22)
        menuBtn?.addTarget(self, action: #selector(MapController.menuBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        searchBg?.addSubview(menuBtn!)
        
        //搭建底部的路径和导航按钮
        let bottomView = UIView()
        bottomView.bounds = CGRectMake(0, 0, width! - 4, 42);
        bottomView.center = CGPoint(x: width! / 2, y: height! - 26)
        bottomView.layer.masksToBounds = true
        bottomView.layer.cornerRadius = 5
        bottomView.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(bottomView)
        let bottomView1 = UIView()
        bottomView1.bounds = CGRectMake(0, 0, width! - 6, 40)
        bottomView1.center = CGPointMake(width! / 2 - 2, 21)
        bottomView1.layer.masksToBounds = true
        bottomView1.layer.cornerRadius = 5
        bottomView1.backgroundColor = UIColor.whiteColor()
        bottomView.addSubview(bottomView1)
        
        let btnWidth = bottomView1.frame.size.width / 3
        let routeBtn = UIButton(type: UIButtonType.Custom)
        routeBtn.setTitle("路线规划", forState: UIControlState.Normal)
        routeBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        routeBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        routeBtn.frame = CGRectMake(0, 0, btnWidth, 40)
        routeBtn.addTarget(self, action: "routeBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        bottomView1.addSubview(routeBtn)
        
        let routeNav1 = UIButton(type: UIButtonType.Custom)
        routeNav1.setTitle("模拟导航", forState: UIControlState.Normal)
        routeNav1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        routeNav1.titleLabel?.font = UIFont.systemFontOfSize(14)
        routeNav1.frame = CGRectMake(btnWidth, 0, btnWidth, 40)
        routeNav1.addTarget(self, action: "simulatorNavi", forControlEvents: UIControlEvents.TouchUpInside)
        bottomView1.addSubview(routeNav1)
        
        let routeNav2 = UIButton(type: UIButtonType.Custom)
        routeNav2.setTitle("实时导航", forState: UIControlState.Normal)
        routeNav2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        routeNav2.titleLabel?.font = UIFont.systemFontOfSize(14)
        routeNav2.frame = CGRectMake(btnWidth * 2, 0, btnWidth, 40)
        routeNav2.addTarget(self, action: "GPSNavi", forControlEvents: UIControlEvents.TouchUpInside)
        bottomView1.addSubview(routeNav2)
        
        let line1 = UIView()
        line1.backgroundColor = UIColor.lightGrayColor()
        line1.frame = CGRectMake(CGRectGetMaxX(routeBtn.frame), 0, 1, 40)
        bottomView1.addSubview(line1)
        let line2 = UIView()
        line2.backgroundColor = UIColor.lightGrayColor()
        line2.frame = CGRectMake(CGRectGetMaxX(routeNav1.frame), 0, 1, 40)
        bottomView1.addSubview(line2)
        
        
    }
    
    //MARK:路线规划
    func routeBtnClick() {
        //起始点为用户当前位置
        let startPoint = AMapNaviPoint()
        let latitudeStr1 = newUserLocation!["currentLatitude"]! as String
        let latitude1 : Float = Float(latitudeStr1)!
        let longitudeStr1 = newUserLocation!["currentLogitude"]! as String
        let longitude1 : Float = Float(longitudeStr1)!
        
        startPoint.latitude = CGFloat(latitude1)
        startPoint.longitude = CGFloat(longitude1)
        
        //终止点为用户搜索位置
        let endPoint = AMapNaviPoint()
        
        let latitudeStr2 = userSearchLocation!["targetLatitude"]! as String
        let latitude2 : Float = Float(latitudeStr2)!
        let longitudeStr2 = userSearchLocation!["targetLogitude"]! as String
        let longitude2 : Float = Float(longitudeStr2)!
        
        endPoint.latitude = CGFloat(latitude2)
        endPoint.longitude = CGFloat( longitude2)
//        let startArray : [AMapNaviPoint] = [startPoint]
//        let endArray : [AMapNaviPoint] = [endPoint]
//        var startArray = NSArray(array: startPoint)
//        let endArray : NSArray = NSArray(array: endPoint)
        self.naviManager?.calculateDriveRouteWithStartPoints([startPoint], endPoints:[endPoint] , wayPoints: nil, drivingStrategy: AMapNaviDrivingStrategy.Default)
        
    }
    //MARK:驾车路径规划成功后的回调函数
    func naviManagerOnCalculateRouteSuccess(naviManager: AMapNaviManager!) {
        self.showRouteWithNaviRoute(naviManager.naviRoute.copy() as! AMapNaviRoute)
        calRuteSuccess = true
    }
    //展示路线
    func showRouteWithNaviRoute(naviRoute : AMapNaviRoute) {
//        if naviRoute == nil {
//            return
//        }
        //清除旧的overlays
        
        self.mapView?.removeOverlays(self.mapView?.overlays)
        let coordianteCount = naviRoute.routeCoordinates.count
        var coordinates = [CLLocationCoordinate2D](count: coordianteCount,repeatedValue:CLLocationCoordinate2DMake(0, 0))
        for i in 0...(coordianteCount-1) {
            let aCoordinate = naviRoute.routeCoordinates[i]
            let cllocation : CLLocationCoordinate2D?
            let latitude : Double = Double(aCoordinate.latitude)
            let longitude : Double = Double(aCoordinate.longitude)
            cllocation = CLLocationCoordinate2DMake(latitude, longitude)
            coordinates[i] = cllocation!
        }
        
        let polyline = MAPolyline(coordinates: UnsafeMutablePointer(coordinates), count: UInt(coordianteCount))
        self.mapView?.addOverlay(polyline)
    }
    //MARK:自定义精度圈
    /*!
     @brief 根据overlay生成对应的View
     @param mapView 地图View
     @param overlay 指定的overlay
     @return 生成的覆盖物View
     */
    func mapView(mapView: MAMapView!, viewForOverlay overlay: MAOverlay!) -> MAOverlayView! {
        print("\(overlay.description)") 
        if overlay.isKindOfClass(MAPolyline) {
            let polylineView = MAPolylineView(overlay: overlay)
            polylineView.lineWidth = 5.0
            polylineView.strokeColor = UIColor.redColor()
            return polylineView
        }
        return nil
    }
    
    //MARK:模拟导航
    func simulatorNavi() {
        if calRuteSuccess == true {//路径规划成功
            naviType = NavigationType.Simulator
            let naviViewController = AMapNaviViewController(delegate: self)
            naviManager?.presentNaviViewController(naviViewController, animated: true)
        } else {//没有路径规划成功
            print("路径规划尚未成功")
        }
    }
    
    //MARK:实时导航
    func GPSNavi() {
        if calRuteSuccess == true {
            naviType = NavigationType.GPS
            let naviViewController = AMapNaviViewController(delegate: self)
            self.naviManager?.presentNaviViewController(naviViewController, animated: true)
        } else {
            print("路径规划没有成功")
        }
    }
    
    //MARK:模拟导航被展示出来的回调
    func naviManager(naviManager: AMapNaviManager!, didPresentNaviViewController naviViewController: UIViewController!) {
        if naviType == NavigationType.Simulator {//模拟导航
            naviManager.startEmulatorNavi()
        } else if naviType == NavigationType.GPS {//实时导航
            naviManager.startGPSNavi()
        }
    }
    //MARK:导航界面关闭按钮点击时的回调函数
    func naviViewControllerCloseButtonClicked(naviViewController: AMapNaviViewController!) {
        if naviType != NavigationType.None {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { 
                //停止语音播报
                self.iFlySpeechSynthesizer!.stopSpeaking()
            })
            naviManager?.stopNavi()
        }
        naviManager?.dismissNaviViewControllerAnimated(true)
    }
    //MARK:被取取消展示后的回调
    func naviManager(naviManager: AMapNaviManager!, didDismissNaviViewController naviViewController: UIViewController!) {
        
    }
    
    override func naviManager(naviManager: AMapNaviManager!, playNaviSoundString soundString: String!, soundStringType: AMapNaviSoundType) {
        if soundStringType == AMapNaviSoundType.PassedReminder {
            //用系统自带的声音做简单例子，播放其它提示音需要另外配置
            AudioServicesPlayAlertSound(1009)
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { 
                self.iFlySpeechSynthesizer?.startSpeaking(soundString)
            })
        }
    }
    //MARK:讯飞语音代理方法
    
    
    
    //MARK:菜单按钮点击事件
    func menuBtnClick() {
        let menuView : CHTumblrMenuView?
        menuView = CHTumblrMenuView()
        menuView?.addMenuItemWithTitle("用户", andIcon: UIImage(named: "userBtn.png"), andSelectedBlock: {() in
            if self.isLogin() {
                let userViewController : UserViewController?
                userViewController = UserViewController()
                self.navigationController?.pushViewController(userViewController!, animated: false)
            } else {
                self.pushLoginController(self.navigationController!)
            }
        })
        menuView?.addMenuItemWithTitle("路线规划", andIcon: UIImage(named: "routePlaning.png"), andSelectedBlock: {() in
            let routeViewController : RouteViewController?
            routeViewController = RouteViewController()
            self.navigationController?.pushViewController(routeViewController!, animated: false)
        })
        menuView?.addMenuItemWithTitle("设置", andIcon: UIImage(named: "settingBtn.png"), andSelectedBlock: {() in
            let settingViewController : SettingViewController?
            settingViewController = SettingViewController()
            self.navigationController?.pushViewController(settingViewController!, animated: false)
        })
        menuView?.addMenuItemWithTitle("分享", andIcon: UIImage(named: "shareBtn.png"), andSelectedBlock: {() in
            if self.isLogin() {
                let shareViewController : ShareViewController?
                shareViewController = ShareViewController()
                self.navigationController?.pushViewController(shareViewController!, animated: false)
            } else {
                self.pushLoginController(self.navigationController!)
            }
        })
        menuView?.addMenuItemWithTitle("导航", andIcon: UIImage(named: "navigation.png"), andSelectedBlock: {() in
//            let navigationController : NavigationViewController?
//            navigationController = NavigationViewController()
//            self.navigationController?.pushViewController(navigationController!, animated: false)
            let vc : SuggestViewController?
            vc = SuggestViewController()
            self.navigationController?.pushViewController(vc!, animated: false)
        })
        menuView?.addMenuItemWithTitle("关于", andIcon: UIImage(named: "about.png"), andSelectedBlock: {() in
            let aboutViewController : AboutViewController?
            aboutViewController = AboutViewController()
            self.navigationController?.pushViewController(aboutViewController!, animated: false)
        })
        menuView?.show()
    }
    
    //MARK:推出登录控制器
    func pushLoginController(navigationController : UINavigationController) {
        let loginController = LoginViewController()
        navigationController.pushViewController(loginController, animated: true)
        
    }
    
    //MARK:判断用户是否登录
    func isLogin() -> Bool {
        let account = accountTool?.accountModel
        if account?.userName != nil {
            return true
        }
        return false
    }
    
    //MARK:语音输入
    func spakeBtnClick() {
        let speakViewController = SpeakViewController()
        self.navigationController?.pushViewController(speakViewController, animated: false)
        
    }
    
    //MARK:创建按钮
    func createBtn(frame : CGRect, backgroundImageName : NSString, tag : Int, action : Selector) -> UIButton {
        var button : UIButton?
        button = UIButton(type: UIButtonType.Custom)
        button?.frame = frame
        button?.setBackgroundImage(UIImage(named: backgroundImageName as String), forState: UIControlState.Normal)
        button?.adjustsImageWhenHighlighted = false
        button?.tag = tag
        button?.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button!)
        return button!
    }
    
    //MARK:放大、缩小、路况、定位按钮点击事件
    func btnClick(button : UIButton) {
        
        switch button.tag {
        case 100://放大
            zoomLevel = mapView?.zoomLevel
            zoomLevel = zoomLevel! + 0.3
            mapView?.setZoomLevel(zoomLevel!, animated: true)
        case 101://缩小
            zoomLevel = mapView?.zoomLevel
            zoomLevel = zoomLevel! - 0.3
            mapView?.setZoomLevel(zoomLevel!, animated: true)
        case 102://路况
            isShowTraffic = !isShowTraffic!
            mapView?.showTraffic = isShowTraffic!
            if isShowTraffic! {
                button.setBackgroundImage(UIImage(named: "icon_traffic.png"), forState: UIControlState.Normal)
            } else {
                button.setBackgroundImage(UIImage(named: "icon_traffic_off.png"), forState: UIControlState.Normal)
            }
        case 103://定位
            self.mapView?.removeAnnotations(self.mapView?.annotations)
            self.locationManager?.requestLocationWithReGeocode(true, completionBlock: self.completionBlock)
        case 104://地图类型
            changeMapType()
        default:
            break
        }
        
    }
    
    //MARK:更改地图类型以及视角
    func changeMapType() {
        //黑色背景
        let tapGesture = UITapGestureRecognizer(target: self, action: "clearCoverView")
        coverView = UIView()
        coverView!.frame = CGRectMake(0, 0, width!, height!)
        coverView!.backgroundColor = UIColor.blackColor()
        coverView!.alpha = 0.4
        coverView?.addGestureRecognizer(tapGesture)
        self.view.addSubview(coverView!)
        //白色背景
        viewBg = UIView()
        let bgWidth : CGFloat = width! - 20
        let bgHeight : CGFloat = (width! - 40) / 3 * 0.64 + 50
        viewBg!.center = CGPointMake(width! / 2, height! / 2)
        viewBg!.bounds = CGRectMake(0, 0, bgWidth, bgHeight)
        viewBg!.backgroundColor = UIColor.whiteColor()
        viewBg!.layer.masksToBounds = true
        viewBg!.layer.cornerRadius = 5
        self.view.addSubview(viewBg!)
        //三个按钮
        let btnWidth : CGFloat = (width! - 40) / 3
        let btnHeight : CGFloat = btnWidth * 0.64
        let firstBtn = UIButton(type: UIButtonType.Custom)
        firstBtn.frame = CGRectMake(5, 5, btnWidth, btnHeight)
        firstBtn.adjustsImageWhenHighlighted = false
        firstBtn.setTitle(" ", forState: UIControlState.Normal)
        firstBtn.setBackgroundImage(UIImage(named: "map1-1.png"), forState: UIControlState.Normal)
        firstBtn.setBackgroundImage(UIImage(named: "map1-2.png"), forState: UIControlState.Selected)
        firstBtn.addTarget(self, action: "chooseMapType:", forControlEvents: UIControlEvents.TouchUpInside)
        viewBg!.addSubview(firstBtn)
        mapTypeBtn = firstBtn
        
        let secondBtn = UIButton(type: UIButtonType.Custom)
        secondBtn.adjustsImageWhenHighlighted = false
        secondBtn.setTitle("  ", forState: UIControlState.Normal)
        secondBtn.frame = CGRectMake(CGRectGetMaxX(firstBtn.frame) + 5, 5, btnWidth, btnHeight)
        secondBtn.setBackgroundImage(UIImage(named: "map2-1.png"), forState: UIControlState.Normal)
        secondBtn.setBackgroundImage(UIImage(named: "map2-2.png"), forState: UIControlState.Selected)
        secondBtn.addTarget(self, action: "chooseMapType:", forControlEvents: UIControlEvents.TouchUpInside)
        viewBg!.addSubview(secondBtn)
        
        let thirdBtn = UIButton(type: UIButtonType.Custom)
        thirdBtn.adjustsImageWhenHighlighted = false
        thirdBtn.setTitle("   ", forState: UIControlState.Normal)
        thirdBtn.frame = CGRectMake(CGRectGetMaxX(secondBtn.frame) + 5, 5, btnWidth, btnHeight)
        thirdBtn.setBackgroundImage(UIImage(named: "map3-1.png"), forState: UIControlState.Normal)
        thirdBtn.setBackgroundImage(UIImage(named: "map3-2.png"), forState: UIControlState.Selected)
        thirdBtn.addTarget(self, action: "chooseMapType:", forControlEvents: UIControlEvents.TouchUpInside)
        viewBg!.addSubview(thirdBtn)
        if mapView?.mapType == MAMapType.Standard {
            firstBtn.selected = true
            mapTypeBtn = firstBtn
        } else if mapView?.mapType == MAMapType.Satellite {
            secondBtn.selected = true
            mapTypeBtn = secondBtn
        } else if mapView?.mapType == MAMapType.StandardNight {
            thirdBtn.selected = true
            mapTypeBtn = thirdBtn
        }
        
        
        //两条分割线
        let lineView1 = UIView()
        lineView1.backgroundColor = UIColor.lightGrayColor()
        lineView1.frame = CGRectMake(5, CGRectGetMaxY(firstBtn.frame) + 5, CGRectGetWidth(viewBg!.frame) - 10, 1)
        viewBg!.addSubview(lineView1)
        let lineView2 = UIView()
        lineView2.backgroundColor = UIColor.lightGrayColor()
        lineView2.frame = CGRectMake(CGRectGetWidth(viewBg!.frame) / 2, CGRectGetMaxY(lineView1.frame) + 5, 1, 30)
        viewBg!.addSubview(lineView2)
        //两个视角按钮
        let btn1 = CameraDegreeButton()
        btn1.initButtonData(CGRectMake(5, CGRectGetMaxY(lineView1.frame), CGRectGetWidth(lineView1.frame) / 2, 40), normalImage: "normalCircle.png", selectedImage: "selectedCircle.png", title: "2D视角")
        btn1.addTarget(self, action: "changeMapCameraDegree:", forControlEvents: UIControlEvents.TouchUpInside)
        viewBg!.addSubview(btn1)
        
        let btn2 = CameraDegreeButton()
        btn2.initButtonData(CGRectMake(CGRectGetMaxX(lineView2.frame), CGRectGetMaxY(lineView1.frame), CGRectGetWidth(lineView1.frame) / 2, 40), normalImage: "normalCircle.png", selectedImage: "selectedCircle.png", title: "3D视角")
        btn2.addTarget(self, action: "changeMapCameraDegree:", forControlEvents: UIControlEvents.TouchUpInside)
        viewBg!.addSubview(btn2)
        
        if mapView?.cameraDegree == 0 {
            btn1.selected = true
            cameraDegreeBtn = btn1
        } else  {
            btn2.selected = true
            cameraDegreeBtn = btn2
        }
        
        //右上角的关闭按钮
        btn3 = UIButton()
        btn3?.adjustsImageWhenHighlighted = false
        btn3!.setBackgroundImage(UIImage(named: "cuo.png"), forState: UIControlState.Normal)
        btn3!.backgroundColor = UIColor.whiteColor()
        btn3!.frame = CGRectMake(CGRectGetMaxX(viewBg!.frame) - 33, CGRectGetMinY(viewBg!.frame) - 30, 30, 30)
        btn3?.addTarget(self, action: "clearCoverView", forControlEvents: UIControlEvents.TouchUpInside)
        btn3!.alpha = 1
        self.view.addSubview(btn3!)
        
    }
    
    //MARK:地图视角转换
    func changeMapCameraDegree(button : UIButton) {
        if !(cameraDegreeBtn === button) {
            cameraDegreeBtn?.selected = false
            button.selected = true
            cameraDegreeBtn = button
            if button.titleLabel?.text == "2D视角" {
                mapView?.setCameraDegree(0, animated: true, duration: 0.3)
            } else {
                mapView?.setCameraDegree(45, animated: true, duration: 0.3)
            }
        }
    }
    
    //MARK:选择地图类型
    func chooseMapType(button : UIButton) {
        /*
        MAMapTypeStandard = 0,
        MAMapTypeSatellite,
        MAMapTypeStandardNight
        */
        if !(mapTypeBtn === button) {
            mapTypeBtn?.selected = false
            button.selected = true
            mapTypeBtn = button
            if button.titleLabel?.text == " " {
                mapView?.mapType = MAMapType.Standard
            } else if button.titleLabel?.text == "  " {
                mapView?.mapType = MAMapType.Satellite
            } else if button.titleLabel?.text == "   " {
                mapView?.mapType = MAMapType.StandardNight
            }
        }
    }
    
    //MARK:清空设置地图的视图
    func clearCoverView() {
        coverView?.removeFromSuperview()
        btn3?.removeFromSuperview()
        viewBg?.removeFromSuperview()
    }
    
    //MARK:初始化定位manager对象
    func initLocationManager() {
        locationManager = AMapLocationManager()
        locationManager?.delegate = self
        //开启持续定位
        locationManager?.startUpdatingLocation()
        //关闭持续定位
        locationManager?.stopUpdatingLocation()
        //设置定位精度
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    //MARK:初始化地图
    func configMapView(){
//        mapView = MAMapView(frame: self.view.bounds)
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
//        iFlySpeechSynthesizer = IFlySpeechSynthesizer.sharedInstance() as? IFlySpeechSynthesizer
        iFlySpeechSynthesizer?.delegate = self
        
        //搜素
        search = AMapSearchAPI()
        search?.delegate = self
    }
    
    
    //MARK:添加罗盘遮盖
    func addCompassCover() {
        let compassCover = UIView()
        compassCover.frame = CGRectMake(20,80,(mapView?.compassSize.width)!,(mapView?.compassSize.height)!)
        compassCover.backgroundColor = UIColor.whiteColor()
        compassCover.alpha = 0.2
        let tapGesture = UITapGestureRecognizer(target: self, action: "compassCoverClick")
        compassCover.addGestureRecognizer(tapGesture)
        self.view.addSubview(compassCover)
    }
    
    //MARK:罗盘遮盖的点击事件
    func compassCoverClick() {
        let cameraDegree = mapView?.cameraDegree
        if cameraDegree == 0 {
            mapView?.setCameraDegree(45, animated: true, duration: 0.3)
        } else if cameraDegree != 0 {
            mapView?.setCameraDegree(0, animated: true, duration: 0.3)
        }
    }

    //MARK: 地图启动后自定义的定位大头针
    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
        if (annotation.isKindOfClass(MAUserLocation)) {//第一次启动定位
            let annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: "identifier")
            annotationView.image = UIImage(named: "")
            annotationView.canShowCallout = true
            return annotationView
        } else if annotation.isKindOfClass(MAPointAnnotation) {//点击定位按钮定位
            let annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: "identifier")
            annotationView.image = UIImage(named: "location@3x.png")
            annotationView.canShowCallout = true
            return annotationView
        }
        return nil
    }
    
    //MARK:定位失败
    func mapView(mapView: MAMapView!, didFailToLocateUserWithError error: NSError!) {
        let hud = MBProgressHUD(view: self.view)
        hud.mode = MBProgressHUDMode.Text
        hud.labelText = "定位失败"
        hud.removeFromSuperViewOnHide = true
        self.view.addSubview(hud)
        hud.show(true)
        hud.hide(true, afterDelay: 1)
    }
    
    //MARK:定位成功，记录经纬度
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        let dict : Dictionary<String,String> = ["currentLogitude": String(userLocation.coordinate.longitude),"currentLatitude": String(userLocation.coordinate.latitude)]
        newUserLocation = dict
    }
    
//    //MARK:自定义精度圈
//    func mapView(mapView: MAMapView!, viewForOverlay overlay: MAOverlay!) -> MAOverlayView! {
//        if overlay === mapView.userLocationAccuracyCircle {
//            let circleView = MACircleView(overlay: overlay)
//            circleView.lineWidth = 1.0
//            circleView.strokeColor = UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 1)
//            circleView.fillColor = UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 1)
//            return circleView
//        }
//        return nil
//    }
    
    //MARK:搜索框开始编辑
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        let searchViewController : SearchViewController?
        searchViewController = SearchViewController()
        self.navigationController?.pushViewController(searchViewController!, animated: false)
    }
    
}

