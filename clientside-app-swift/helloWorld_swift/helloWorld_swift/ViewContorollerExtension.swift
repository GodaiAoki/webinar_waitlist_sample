//
//  ViewContorollerExtension.swift
//  helloWorld_swift
//
//  Created by Godai_Aoki on 2015/11/11.
//  Copyright © 2015年 Joshua Alger. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func showActivityIndicator(uiView: UIView) {
        
        let container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        container.tag = 100
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 100, 100)
        loadingView.center = uiView.center
        loadingView.backgroundColor =  UIColor(red: 68/256, green: 68/256, blue: 68/256, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        
        // indicatorの作成
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRectMake(0, 0, 200, 200)
        activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2,
            loadingView.frame.size.height / 2);
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        //
        activityIndicator.hidesWhenStopped = false
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        
        //アニメーションの開始
        activityIndicator.startAnimating()
        
        //indicatorをビューへ追加
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        
    }
    
    func hideActivityIndicator(uiView: UIView) {
        let container: UIView = uiView.viewWithTag(100)!
        container.removeFromSuperview()
        
    }
}
  