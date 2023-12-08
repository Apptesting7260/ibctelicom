 import UIKit
 import Flutter
 import BranchSDK
  import Firebase
 import FacebookCore


 @UIApplicationMain
 @objc class AppDelegate: FlutterAppDelegate {
   
     override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
         Branch.setUseTestBranchKey(true)
         FirebaseApp.configure()
         Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
             print(params as? [String: AnyObject] ?? {})
             // Access and use deep link data here (nav to page, display content, etc.)
         }
         GeneratedPluginRegistrant.register(with: self)
         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
     }
     override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         Branch.getInstance().application(app, open: url, options: options)
         return true
     }

     override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
         // Handler for Universal Links
         Branch.getInstance().continue(userActivity)
         return true
     }

     override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         // Handler for Push Notifications
         Branch.getInstance().handlePushNotification(userInfo)
     }

 }


