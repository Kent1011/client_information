import Flutter
import UIKit
import SAMKeychain

public class SwiftClientInformationPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "client_information", binaryMessenger: registrar.messenger())
    let instance = SwiftClientInformationPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    var info = [String: String]()
    switch call.method {
    case "getInformation":
      let applicationId = Bundle.main.bundleIdentifier as? String ?? "unknown_application_id"
      let applicationType = "app"
      let applicationVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown_version"
      let applicationBuildCode = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
      let applicationName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "unknown_name"
      let osName = "iOS"
      let osVersion = "iOS " + UIDevice.current.systemVersion
      let osVersionCode = UIDevice.current.systemVersion
      let deviceId = self.getDeviceId(applicationName: applicationName)
      let deviceName = UIDevice.current.model

      info["deviceId"] = deviceId
      info["deviceName"] = deviceName
      info["osName"] = osName
      info["osVersion"] = osVersion
      info["osVersionCode"] = osVersionCode
      info["softwareName"] = applicationName
      info["softwareVersion"] = applicationVersion
      info["applicationId"] = applicationId
      info["applicationType"] = applicationType
      info["applicationName"] = applicationName
      info["applicationVersion"] = applicationVersion
      info["applicationBuildCode"] = applicationBuildCode

      result(info)
    default:
      result(info)
    }
  }

  private func getDeviceId(applicationName: String) -> String {
    let account = Bundle.main.bundleIdentifier!
    var uuid = SAMKeychain.password(forService: applicationName, account: account)
    
    if uuid == nil {        
      uuid = (UIDevice.current.identifierForVendor?.uuidString)!
      
      let query = SAMKeychainQuery()
      query.service = applicationName
      query.account = account
      query.password = uuid
      query.synchronizationMode = SAMKeychainQuerySynchronizationMode.no

      do {
        try query.save()
      } catch let error as NSError {
        print("Exception: \(error)")
      }
    }
    
    return uuid as? String ?? "unknown_device_id"
  }
}
