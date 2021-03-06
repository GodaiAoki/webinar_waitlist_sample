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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //initialize SDK with IBM Bluemix application ID and route
        //TODO: Please Enter a valid ApplicationRoute for initializaWithBackendRoute and a valid ApplicationId for backenGUID
        //Example:
        IMFClient.sharedInstance().initializeWithBackendRoute("http://webinar-mfs.mybluemix.net", backendGUID: "dbfc0e91-8e87-4a0c-b169-920d22c50b24")
        
        let notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
        
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        
        //ステータスバーの色指定
        //UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        //ナビゲーションバーのスタイル設定
        // Set navigation bar tint / background colour
        UINavigationBar.appearance().barTintColor = UIColor(red: 67/255, green: 124/255, blue: 189/255, alpha: 1.0)
        UINavigationBar.appearance().backgroundColor = UIColor(red: 67/255, green: 124/255, blue: 189/255, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //UINavigationBar.appearance().frame = CGRectMake(0, 0, 320, 66)
        
        return true
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let push = IMFPushClient.sharedInstance()
        push.registerDeviceToken(deviceToken, completionHandler: { (response, error) -> Void in
            if error != nil {
                print("Error during device registration \(error.description)")
            }
            else {
                print("Response during device registration json: \(response.responseJson.description)")
                let responseObj:NSDictionary = response.responseJson
                //print(responseObj["deviceId"])
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(responseObj["deviceId"]!, forKey: "deviceId")
            }
        })
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

