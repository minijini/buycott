import UIKit
import Flutter

import NaverThirdPartyLogin


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if url.absoluteString.hasPrefix("kakao"){
                super.application(app, open:url, options: options)
                return true
             } else if url.absoluteString.contains("thirdPartyLoginResult") {
                NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
                return true
             } else {
                return true
             }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
