//
//  SearchViewController.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/20.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

//搜索控制器

import Foundation

enum TableViewType {
    case SearchTableView
    case HistoryTableView
}

class SearchViewController: BaseViewController,AMapSearchDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {
    
    let filePath : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingString("/historyArray.data")
    let maxHistoryArrayCount = 20
    let navigationBarHeight : CGFloat = 64
    var mySearchBar : UISearchBar?
    var searchBg : UIView?
    var width : CGFloat?
    var height : CGFloat?
    var historyTableView : UITableView?
    var searchTableView : UITableView?
    var search : AMapSearchAPI?
    var tableViewType : TableViewType?
    var searchModelArray : NSMutableArray?
    //记录搜索历史记录数组
    var historyArray : NSMutableArray?
    var cover : Cover?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = self.view.frame.size.width
        height = self.view.frame.size.height
        self.navigationController?.navigationBarHidden = false
        
        buildUI()
        initSearchAPI()
        searchModelArray = NSMutableArray()
        historyArray = NSMutableArray()
        mySearchBar?.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchBg?.hidden = false
        //获取存储的历史记录
        getHistoryInfo()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBg!.hidden = true
    }
    
    //MARK: 初始化搜索对象
    func initSearchAPI() {
        //初始化检索对象
        search = AMapSearchAPI()
        search?.delegate = self
        
        //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
//        let request = AMapPOIAroundSearchRequest()
//        request.location = AMapGeoPoint.locationWithLatitude(39.990459, longitude: 116.481476)
//        request.keywords = "方恒"
//        request.types = "餐饮服务|生活服务";
//        request.sortrule = 0;
//        request.requireExtension = true;
//        
//        search?.AMapPOIAroundSearch(request)
    }
    
    //MARK:实现POI搜索对应的回调函数,提供经纬度，返回周边停车场
    func onPOISearchDone(request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if response.pois.count == 0 {
            return
        }
//        let strCount = "\(response.count)"
//        let strSuggestion = "\(response.suggestion)"
//        var strPoi = ""
//        for p in response.pois {
//            strPoi = "\(strPoi) + \(p.description)"
//        }
//        let result = "\(strCount) + \(strSuggestion) + \(strPoi)"
//        print("\(result)")
    }
    
    //MARK:模糊搜索回调，输入关键字，返回模糊数据
    func onInputTipsSearchDone(request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        if response.tips.count == 0 {
            return
        }
        searchModelArray?.removeAllObjects()
        for p in response.tips {
            let model = SearchModel()
            model.name = p.name as String
            model.district = p.district as String
            searchModelArray?.addObject(model)
        }
        searchTableView?.reloadData()
    }
    
    //MARK:正向地理编码回调，提供地址，返回经纬度
    func onGeocodeSearchDone(request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        if response.geocodes.count == 0 {
            return
        } else {
            let geoCode : AMapGeocode?
            geoCode = response.geocodes[0] as? AMapGeocode
            let dict : Dictionary<String,String> = ["targetLatitude": String((geoCode?.location.latitude)!),"targetLogitude": String((geoCode?.location.longitude)!),"name" : request.address]
            //在地图中显示
            var notification : NSNotification?
            notification = NSNotification(name: "searchTableViewCellNotification", object: nil, userInfo: dict)
            NSNotificationCenter.defaultCenter().postNotification(notification!)
            self.navigationController?.popViewControllerAnimated(false)
        }
    }
    
    //MARK:逆地理编码回调，提供经纬度，返回当前城市信息
    func onReGeocodeSearchDone(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        
    }
    
    
    
    //MARK: 创建界面
    func buildUI() {
        
        searchBg = UIView()
        searchBg!.frame = CGRectMake(38, 2, width! - 43, 38)
        searchBg!.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.addSubview(searchBg!)
        
        
        mySearchBar = UISearchBar(frame: CGRectMake(5, 3, CGRectGetWidth(searchBg!.frame) - 50, 34))
        mySearchBar?.barTintColor = UIColor.whiteColor()
        mySearchBar?.searchBarStyle = UISearchBarStyle.Minimal
        mySearchBar?.placeholder = "搜索"
        mySearchBar?.translucent = true
        mySearchBar?.delegate = self
        mySearchBar?.showsCancelButton = false
        mySearchBar?.translatesAutoresizingMaskIntoConstraints = false
        searchBg!.addSubview(mySearchBar!)
        
        let margin : CGFloat = 10
        let viewWidth : CGFloat = width! - margin * 2
        
        
        
        let lineView = UIView()
//        lineView.frame = CGRectMake(width! - 45, 10, 1, 25)
        lineView.frame = CGRectMake(CGRectGetMaxX((mySearchBar?.frame)!) + 10, 7, 1, 25)
        lineView.backgroundColor = UIColor.lightGrayColor()
        searchBg!.addSubview(lineView)
        
        let spakeButton = UIButton()
        spakeButton.center = CGPointMake(CGRectGetMaxX(lineView.frame) + 15, 20)
        spakeButton.bounds = CGRectMake(0, 0, 25, 25)
        spakeButton.setBackgroundImage(UIImage(named: "spake.png"), forState: UIControlState.Normal)
        spakeButton.adjustsImageWhenHighlighted = false
        searchBg!.addSubview(spakeButton)
        
        //history
        
        
        let backgroundImage = UIImageView(image: UIImage(named: "bgImage.png"))
        backgroundImage.frame = CGRectMake(0, 0, width!, height! - 64)
        backgroundImage.userInteractionEnabled = true
        self.view.addSubview(backgroundImage)
        
        //histryLabel
        let view1 = UIView()
        view1.backgroundColor = UIColor.lightGrayColor()
        view1.frame = CGRectMake(margin, 5, viewWidth, 32)
        view1.layer.masksToBounds = true
        view1.layer.cornerRadius = 5
        backgroundImage.addSubview(view1)
        
        let view2 = UIView()
        view2.backgroundColor = UIColor.whiteColor()
        view2.layer.masksToBounds = true
        view2.layer.cornerRadius = 5
        view2.frame = CGRectMake(margin + 1, 6, viewWidth - 2 , 30)
        backgroundImage.addSubview(view2)
        
        let label1 = UILabel()
        label1.frame = CGRectMake(margin + 1, 6, viewWidth - 2, 30)
        label1.text = "历史记录"
        label1.textAlignment = NSTextAlignment.Center
        label1.font = UIFont.systemFontOfSize(12)
        label1.textColor = UIColor.darkGrayColor()
        backgroundImage.addSubview(label1)
        
        //hsitorytableview
//        let viewBg = UIView()
//        viewBg.backgroundColor = UIColor.lightGrayColor()
//        viewBg.frame = CGRectMake(margin, CGRectGetMaxY(view1.frame) + 2, viewWidth, height! - CGRectGetMaxY(view1.frame) - 64 - 4)
//        viewBg.layer.masksToBounds = true
//        viewBg.layer.cornerRadius = 5
//        backgroundImage.addSubview(viewBg)
        historyTableView = UITableView()
        historyTableView?.frame = CGRectMake( margin, CGRectGetMaxY(view1.frame) + 2, viewWidth, height! - CGRectGetMaxY(view1.frame) - 64 - 4)
        //tableview不能滚动，最多纪录8条历史记录
        historyTableView?.layer.masksToBounds = true
//        historyTableView?.scrollEnabled = false
        historyTableView?.layer.cornerRadius = 5
        historyTableView?.delegate = self
        historyTableView?.dataSource = self
        backgroundImage.addSubview(historyTableView!)
        
        //searchTableView
        searchTableView = UITableView()
        searchTableView?.frame = CGRectMake(margin, 0, viewWidth, height! - 64)
        searchTableView?.hidden = true
        searchTableView?.delegate = self
        searchTableView?.dataSource = self
        self.view.addSubview(searchTableView!)
    }
    
    //MARK: 遮盖点击事件
    func coverClick() {
        cover?.removeFromSuperview()
        mySearchBar?.resignFirstResponder()
    }
    
    //MARK: 搜索框成为第一响应者
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        //添加遮盖
        cover = Cover.creageCover(self, action: #selector(SearchViewController.coverClick))
        cover?.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 216)
        cover?.alpha = 0.02
        self.view.addSubview(cover!)
        return true
    }
    
    //MARK:搜索框内容变化监听事件
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.isEmpty == false) {
            searchTableView?.hidden = false
            let tipsRequest = AMapInputTipsSearchRequest()
            tipsRequest.keywords = self.mySearchBar?.text
            search?.AMapInputTipsSearch(tipsRequest)
        }
    }
    
    //MARK:tableview的数据源河代理方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.historyTableView {
            return 2
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchTableView {
            return (searchModelArray?.count)!
        } else if tableView == self.historyTableView {
            if section == 0 {
                return (historyArray?.count)!
            } else {
                return 0
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.searchTableView {//搜索
            var cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(SearchTableViewCell.self)) as! SearchTableViewCell!
            if cell == nil {
                cell = SearchTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: NSStringFromClass(SearchTableViewCell.self))
            }
//            cell.model = searchModelArray[indexPath.row] as! SearchModel
            cell.model = searchModelArray?.objectAtIndex(indexPath.row) as? SearchModel
            return cell
        } else if tableView == self.historyTableView {//搜索记录
            var cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(HistoryTableViewCell.self)) as! HistoryTableViewCell!
            if cell == nil {
                cell = HistoryTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: NSStringFromClass(HistoryTableViewCell.self))
            }
            cell.nameLabel?.text = historyArray![indexPath.row] as? String
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == self.searchTableView {
            return 54
        } else if tableView == self.historyTableView {
            return 54
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (tableView == self.historyTableView) && (historyArray?.count > 0) && (section == 1){
            return 44;
        }
        return 0.01;
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (tableView == self.historyTableView) && (historyArray?.count > 0) && (section == 1) {
            let button : UIButton!
            button = UIButton(type: UIButtonType.Custom)
            button.setTitle("清除历史记录", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(14)
            button.addTarget(self, action: #selector(SearchViewController.clearHistory), forControlEvents: UIControlEvents.TouchUpInside)
            return button
        }
        return nil;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == searchTableView {
            let model = searchModelArray?.objectAtIndex(indexPath.row)
            let name : String = (model?.name)!
            historyInfowriteToFile(name)
            searchLocationWithName(name)
        } else if tableView == historyTableView {
            let name = historyArray![indexPath.row]
            searchLocationWithName(name as! String)
        }
    }
    
    func searchLocationWithName(name : String) {
        //调起正向地理编码
        let geo : AMapGeocodeSearchRequest?
        geo = AMapGeocodeSearchRequest()
        geo?.address = name
        search?.AMapGeocodeSearch(geo)
    }
    
    //MARK:将数据存入沙盒
    func historyInfowriteToFile(name : String) {
        var array = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? NSMutableArray
        if array == nil {
            array = NSMutableArray()
        }
        for item in array! {
            if name == item as! String {
                return
            }
        }
        if array?.count < maxHistoryArrayCount {
            array?.insertObject(name, atIndex: 0)
        } else {
            array?.removeLastObject()
            array?.insertObject(name, atIndex: 0)
        }
        NSKeyedArchiver.archiveRootObject(array!, toFile: filePath)
    }
    
    //MARK:从沙盒读取数据
    func getHistoryInfo() {
        let array = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? NSMutableArray
        if ((array?.isKindOfClass(NSArray)) != nil) {
            if (array?.count > 0) {
                historyArray = array;
                historyTableView?.reloadData()
            }
        }
    }
    
    func clearHistory() {
        let array = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? NSMutableArray
        if array != nil {
            array?.removeAllObjects()
        }
        NSKeyedArchiver.archiveRootObject(array!, toFile: filePath)
        historyArray?.removeAllObjects()
        historyTableView?.reloadData()
    }
}
