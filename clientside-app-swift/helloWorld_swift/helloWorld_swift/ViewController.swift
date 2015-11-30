// Copyright 2015 IBM Corp. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import Foundation
class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitAction(sender: AnyObject) {

        let name:String = nameTextField.text ?? ""
        let phone:String = phoneTextField.text ?? ""
        
        //値入力チェック
        if name.isEmpty  {
            displayAlert("必須入力",message:"氏名を入力してください")
            return
        }
        
        if phone.isEmpty  {
            displayAlert("必須入力",message:"電話番号を入力してください")
            return
        }
        
        //deviceid取得
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let deviceId = userDefaults.objectForKey("deviceId")
        
        //デバイスIDが取得できていたら登録
        if deviceId != nil {
            let imfClient = IMFClient.sharedInstance()
            let request = IMFResourceRequest(path: imfClient.backendRoute + "/adduser")
            request.setHTTPMethod("POST")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonObject: [String: AnyObject] = [
                "phone": phone,
                "name" : name,
                "deviceid" : deviceId!
            ]
            let jsonNSData = jsonToNSData(jsonObject)
            request.setHTTPBody(jsonNSData!)
            
            //アクティビティインディケーターの表示
            showActivityIndicator(view)
            
            request.sendWithCompletionHandler { (response, error ) -> Void in
                if error != nil {
                    NSLog("%@",error);
                    self.hideActivityIndicator(self.view)
                    self.displayAlert("エラー",message:"リクエストに失敗しました。ネットワーク接続を確認してください。")
                }
                else {
                    NSLog("ユーザー登録に成功しました")
                    self.hideActivityIndicator(self.view)
                    self.performSegueWithIdentifier("moveWaitView", sender: nil)
                }
                
            }
        }else{
            //デバイスIDが取得できていない場合
            displayAlert("プッシュ通知",message:"プッシュ通知を有効にしてください。iOS Simulatorではプッシュ通知を利用できません。実機で確認してください")
            return
        }
        

        
    }
    
    //画面遷移時に氏名、電話番号の入力値を受け渡し
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "moveWaitView" {
            
            let nav = segue.destinationViewController as! UINavigationController
            let waitView = nav.topViewController as! WaitViewController

            waitView.name = nameTextField.text!
            waitView.phone = phoneTextField.text!
            
        }
    }
    
    func displayAlert(title : String, message : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func jsonToNSData(json: AnyObject) -> NSData?{
        do {
            return try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }

}



