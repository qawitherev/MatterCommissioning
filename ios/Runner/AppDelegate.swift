import UIKit
import Flutter
import Matter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let cChannel = FlutterMethodChannel(name: "com.adt.commission-app", binaryMessenger: controller.binaryMessenger)
        cChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "parseAll":
                let qrString = call.arguments as? String
                self?.parseAll(qrString!, result: result)
            case "startCms":
                let qrString = call.arguments as? String
                self?.startCms(qrString!, result: result)
            case "mSupport":
                self?.mSupport(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func parseAll(_ qrString: String, result: @escaping FlutterResult) {
        do {
            let pl = try MTRSetupPayload(onboardingPayload: qrString)
            let dict: [String: Any] = [
                "discriminator": pl.discriminator,
                "prodId": pl.productID,
                "serNum": pl.serialNumber as Any,
                "setupPCode": pl.setupPasscode,
                "vendId": pl.vendorID,
                "vers": pl.version,
            ]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    result(jsonString)
                }
            }
            result(pl.vendorID)
        } catch {
            let fErr = FlutterError(code: "MTRSETUPPAYLOAD_ERR", message: "Failed to parse payload", details: error.localizedDescription)
            result(fErr)
        }
    }
    
    func startCms(_ qrString: String, result: @escaping FlutterResult) {
        let _ = CommissionHelper(qrString: qrString, fr: result)
    }
    
    func mSupport(result: @escaping FlutterResult) {
        let _ = MSupport(home: "Qawi Home", result: result)
    }
}
