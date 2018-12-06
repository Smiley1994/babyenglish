import UIKit
import Flutter
import fluwx

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    Thread.sleep(forTimeInterval: 1);
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
     
        return WXApi .handleOpen(url, delegate: FluwxResponseHandler.defaultManager())
    }
}
