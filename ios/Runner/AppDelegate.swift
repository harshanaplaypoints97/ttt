import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let swiftScreenChannel = FlutterMethodChannel(name: "com.example.flutter_app/swift_screen", binaryMessenger: controller.binaryMessenger)
      
      swiftScreenChannel.setMethodCallHandler { [weak self] (call, result) in
        if call.method == "openSwiftScreen" {
          self?.openSwiftScreen()
            swiftScreenChannel.invokeMethod("opened", arguments: nil)
          result(nil)
        }else if call.method == "closeSwiftScreen" {
            self?.closeSwiftScreen()
            swiftScreenChannel.invokeMethod("closed", arguments: nil)
            result(nil)
        }
      }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    private func openSwiftScreen() {
        let viewController = MoneyDetectionViewController()
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    private func closeSwiftScreen() {
            if let presentedViewController = window?.rootViewController?.presentedViewController {
                presentedViewController.dismiss(animated: true, completion: nil)
            }
        }
}
