//
//  ShareViewController.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/20.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

//分享控制器

import Foundation

class ShareViewController: BaseViewController,UMSocialUIDelegate {
    let AppKey = "56e50ed067e58e89620008ac"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "分享"
        let bgImageView : UIImageView?
        bgImageView = UIImageView(image: UIImage(named: "shareBg.png"))
        bgImageView?.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.addSubview(bgImageView!)
        UMSocialSnsService .presentSnsIconSheetView(self, appKey: AppKey, shareText: "友盟分享", shareImage: UIImage(named:"icon.png" ), shareToSnsNames: [UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite], delegate: self)
    }
    
    func isDirectShareInIconActionSheet() -> Bool {
        return true
    }
    
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        if response.responseCode == UMSResponseCodeSuccess {
            print("share to sns name is \(response.data)")
        }
    }
}
