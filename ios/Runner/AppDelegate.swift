import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKEY("AIzaSyDLkJosEooi2EEk1YOiu8GjyYC_EPPogO0")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
