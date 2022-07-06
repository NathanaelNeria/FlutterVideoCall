import UIKit
import Flutter
import Firebase
import PushKit
import flutter_callkit_incoming

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let mainQueue = DispatchQueue.main
    let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
    voipRegistry.delegate = self
    voipRegistry.desiredPushTypes = [PKPushType.voIP]
    
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    // Call back from Recent history
       override func application(_ application: UIApplication,
                                 continue userActivity: NSUserActivity,
                                 restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
           
           guard let handleObj = userActivity.handle else {
               return false
           }
           
           guard let isVideo = userActivity.isVideo else {
               return false
           }
           let nameCaller = handleObj.getDecryptHandle()["nameCaller"] as? String ?? ""
           let handle = handleObj.getDecryptHandle()["handle"] as? String ?? ""
           let data = flutter_callkit_incoming.Data(id: UUID().uuidString, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
           //set more data...
           data.nameCaller = "Johnny"
           SwiftFlutterCallkitIncomingPlugin.sharedInstance?.startCall(data, fromPushKit: true)
           
           return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
       }
       
       // Handle updated push credentials
       func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
           print(credentials.token)
           let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
           print(deviceToken)
           //Save deviceToken to your server
           SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
       }
       
       func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
           print("didInvalidatePushTokenFor")
           SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
       }
       
       // Handle incoming pushes
       func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWithPayload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
           print("didReceiveIncomingPushWith")
           guard type == .voIP else { return }
           
           let id = payload.dictionaryPayload["id"] as? String ?? ""
           let nameCaller = payload.dictionaryPayload["nameCaller"] as? String ?? ""
           let handle = payload.dictionaryPayload["handle"] as? String ?? ""
           let isVideo = payload.dictionaryPayload["isVideo"] as? Bool ?? false
           
           let data = flutter_callkit_incoming.Data(id: id, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
           //set more data
           data.extra = ["user": "abc@123", "platform": "ios"]
           //data.iconName = ...
           //data.....
           SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)
       }
}
