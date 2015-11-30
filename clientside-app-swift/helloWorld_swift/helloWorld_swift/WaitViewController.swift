//
//  WaitViewController.swift
//  helloWorld_swift
//
//  Created by Godai_Aoki on 2015/11/11.
//  Copyright © 2015年 Joshua Alger. All rights reserved.
//

import Foundation

class WaitViewController: UIViewController {
    
    var name : String = ""
    var phone : String = ""
    var que  : Int = 0
    
    @IBOutlet weak var queLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshNumber()
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        refreshNumber()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshNumber(){
        //自分が何番目なのか取得する
        let imfClient = IMFClient.sharedInstance()
        let request = IMFResourceRequest(path: imfClient.backendRoute + "/users")
        request.setHTTPMethod("GET")
        showActivityIndicator(view)
        request.sendWithCompletionHandler { (response, error ) -> Void in
            if error != nil {
                NSLog("%@",error);
                //displayAlert("エラー",message:"リクエストに失敗しました。ネットワーク接続を確認してください")
            }
            else {
                let responseStr : String = response.responseText
                let jsonData : NSData = responseStr.dataUsingEncoding(NSUTF8StringEncoding)!
                do{
                    let jsonArray:NSArray = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    NSLog("ユーザー一覧の取得に成功しました")
                    self.que = 0
                    for entry in jsonArray {
                        if entry["_id"] as! String == self.phone {
                            break
                        }
                        self.que = self.que + 1
                    }
                    self.queLabel.text = String(self.que)
                    self.hideActivityIndicator(self.view)
                    
                }catch {
                    print("ユーザー一覧のパースに失敗しました。")
                    self.hideActivityIndicator(self.view)
                }
            }
        }

    }
    
}