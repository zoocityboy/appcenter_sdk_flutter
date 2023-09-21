import Flutter
import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
#if canImport(AppCenterDistribute)
    import AppCenterDistribute
#endif
public class AppcenterSdkPlugin: NSObject, FlutterPlugin, AppCenterApi {
    
    
       
    var mEvents: FlutterEventSink?
    var mEventChannel: FlutterEventChannel?
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger()
        let appCenterPlugin = AppcenterSdkPlugin()
        
        AppCenterApiSetup.setUp(binaryMessenger: binaryMessenger, api: appCenterPlugin)
        AnalyticsApiSetup.setUp(binaryMessenger: binaryMessenger, api: appCenterPlugin)
        CrashesApiSetup.setUp(binaryMessenger: binaryMessenger, api: appCenterPlugin)
        #if canImport(AppCenterDistribute)
            DistributeApiSetup.setUp(binaryMessenger: binaryMessenger, api: appCenterPlugin)
        #endif
        
        
        appCenterPlugin.mEventChannel = FlutterEventChannel(name: "zoo.cityboy.appcenter_sdk/distribute_events", binaryMessenger: binaryMessenger)
        appCenterPlugin.mEventChannel?.setStreamHandler(appCenterPlugin)
        
    }
    
    // AppCenter
    
    
    func setUserId(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        AppCenter.userId = userId
        completion(.success(Void()))
    }
    
    func setCountryCode(countryCode: String, completion: @escaping (Result<Void, Error>) -> Void) {
        AppCenter.countryCode = countryCode
    }
    
    func getSdkVersion() throws -> String {
        return AppCenter.sdkVersion
    }
    
    func setNetworkRequestsAllowed(enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        AppCenter.networkRequestsAllowed = enabled
    }
    
    func isNetworkRequestsAllowed() throws -> Bool {
        return AppCenter.networkRequestsAllowed
    }
//    func start(secret: String, usePrivateTrack: Bool) {
    func start(config: AppCenterConfig) throws {
        NSLog("Appcenter: start config \(config)")
    
        if (!AppCenter.isConfigured){
            Analytics.transmissionInterval = UInt(config.transmissionInterval)
            
            var services = [Analytics.self, Crashes.self]
            #if canImport(AppCenterDistribute)
                if config.usePrivateTrack {
                    Distribute.updateTrack = .private
                } else {
                    Distribute.updateTrack = .public
                }
                services.append(Distribute.self)
            #endif
            AppCenter.start(withAppSecret: config.secret, services: services)
            
            AppCenter.logLevel = config.logLevel.toLogLevel()
            Analytics.enabled = config.analyticsEnabled
            Crashes.enabled = config.crashEnabled
            #if canImport(AppCenterDistribute)
                Distribute.enabled = config.distributeEnabled
            #endif
            NSLog("Appcenter: start new configuration")
            
        } else {
            NSLog("Appcenter: start configured")
        }
    }
    
    
    func setEnabled(enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        AppCenter.enabled = enabled
        NSLog("Appcenter: setEnabled \(enabled)")
        completion(.success(Void()))
    }
    
    func isEnabled(completion: @escaping (Result<Bool, Error>) -> Void) {
        NSLog("Appcenter: isEnabled \(AppCenter.enabled)")
        completion(.success(AppCenter.enabled))
    }
    
    func isConfigured() -> Bool {
        NSLog("Appcenter: isConfigured \(AppCenter.isConfigured)")
        return AppCenter.isConfigured
    }
    
    func getInstallId(completion: @escaping (Result<String, Error>) -> Void) {
        NSLog("Appcenter: getInstallId \(AppCenter.installId.uuidString)")
        completion(.success(AppCenter.installId.uuidString))
    }
    
    func isRunningInAppCenterTestCloud() -> Bool {
        NSLog("Appcenter: isRunningInAppCenterTestCloud \(AppCenter.isRunningInAppCenterTestCloud)")
        return AppCenter.isRunningInAppCenterTestCloud
    }
    
    func setLogLevel(level: LoggerLevel) throws {
        NSLog("Appcenter: setLogLevel \(level)")
        AppCenter.logLevel = level.toLogLevel()
    }

// AppCenter
}
extension LoggerLevel{
    func toLogLevel() -> LogLevel {
            switch self {
            case .verbose: return LogLevel.verbose
            case .debug: return LogLevel.debug
            case .info: return LogLevel.info
            case .warning: return LogLevel.warning
            case .error: return LogLevel.error
            case .fatal: return LogLevel.assert
            case .none: return LogLevel.none
            }
        }
}
extension AppcenterSdkPlugin: CrashesApi {
    func generateTestCrash() {
        NSLog("Appcenter: generateTestCrash")
        Crashes.generateTestCrash()
    }
    
    func hasReceivedMemoryWarningInLastSession(completion: @escaping (Result<Bool, Error>) -> Void) {
        NSLog("Appcenter: hasReceivedMemoryWarningInLastSession \(Crashes.hasReceivedMemoryWarningInLastSession)")
        completion(.success(Crashes.hasReceivedMemoryWarningInLastSession))
    }
    
    func hasCrashedInLastSession(completion: @escaping (Result<Bool, Error>) -> Void) {
        NSLog("Appcenter: hasCrashedInLastSession \(Crashes.hasCrashedInLastSession)")
        completion(.success(Crashes.hasCrashedInLastSession))
    }
    
    func crashesSetEnabled(enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        NSLog("Appcenter: crashesSetEnabled \(enabled)")
        Crashes.enabled = enabled
        completion(.success(Void()))
    }
    
    func crashesIsEnabled(completion: @escaping (Result<Bool, Error>) -> Void) {
        NSLog("Appcenter: crashesIsEnabled \(Crashes.enabled)")
        completion(.success(Crashes.enabled))
    }
    
    func trackException(message: String, type: String?, stackTrace: String?, properties: [String : String]?) {
        let exceptionModel = MSACWrapperExceptionModel()
        exceptionModel.message = message
        exceptionModel.type = type
        exceptionModel.stackTrace = stackTrace
        exceptionModel.wrapperSdkName = "appcenter.flutter"
        
        NSLog("Appcenter: trackException \(exceptionModel)")
        Crashes.trackException(exceptionModel, properties: properties, attachments: nil)
    }
}
extension AppcenterSdkPlugin: AnalyticsApi {
    
    func trackPage(name: String, properties: [String : String]?) throws {
        NSLog("Appcenter: trackPage \(name) -> \(String(describing: properties))")
        Analytics.trackEvent(name, withProperties: properties)
    }
    
    func trackEvent(name: String, properties: [String : String]?, flags: Int64?)throws {
        NSLog("Appcenter: trackEvent \(name) -> \(String(describing: properties)) flags: \(String(describing: flags))")
        if(flags == nil){
            Analytics.trackEvent(name, withProperties: properties)
        }else{
            Analytics.trackEvent(name, withProperties: properties, flags: Flags.init(rawValue: UInt.init(flags!)))
        }
    }
    
    func pause() {
        NSLog("Appcenter: pause ")
        Analytics.pause()
    }
    
    func resume() {
        NSLog("Appcenter: resume")
        Analytics.resume()
    }
    
    func analyticsSetEnabled(enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        Analytics.enabled = enabled
        NSLog("Appcenter: analyticsSetEnabled \(enabled) ")
        completion(.success(Void()))
    }
    
    func analyticsIsEnabled(completion: @escaping (Result<Bool, Error>) -> Void) {
        NSLog("Appcenter: analyticsIsEnabled \(Analytics.enabled) ")
        completion(.success(Analytics.enabled))
    }
    
    func enableManualSessionTracker() {
        NSLog("Appcenter: enableManualSessionTracker")
        Analytics.enableManualSessionTracker()
    }
    
    func startSession() {
        NSLog("Appcenter: startSession")
        Analytics.startSession()
    }
    
    func setTransmissionInterval(seconds: Int64) throws -> Bool {
        NSLog("Appcenter: transmissionInterval \(seconds)")
        Analytics.transmissionInterval = UInt.init(seconds)
        return true
    }
}

extension AppcenterSdkPlugin: UIApplicationDelegate{
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//        // Forward the URL.
//        return Distribute.open(url);
//      }
    public func applicationDidBecomeActive(_ application: UIApplication) {
        NSLog("Appcenter: applicationDidBecomeActive")
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        NSLog("Appcenter: applicationWillTerminate")
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        NSLog("Appcenter: applicationWillResignActive")
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        NSLog("Appcenter: applicationDidEnterBackground")
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        NSLog("Appcenter: applicationWillEnterForeground")
    }
}
extension AppcenterSdkPlugin: FlutterStreamHandler {
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
      NSLog("Appcenter: distribute onListen: arguments \(String(describing: arguments)) events: \(String(describing: events))")
    self.mEvents = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.mEvents = nil
    return nil
  }
}
#if canImport(AppCenterDistribute)
extension AppcenterSdkPlugin: DistributeApi{
    func setDistributeEnabled(enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        #if canImport(AppCenterDistribute)
            NSLog("Appcenter: setDistributeEnabled \(enabled)")
            Distribute.enabled = enabled
            completion(.success(Void()))
        #else
            NSLog("Appcenter: [distribute not available] setDistributeEnabled \(enabled)")
            completion(.success(Void()))
        #endif
       
    }
    
    func notifyDistributeUpdateAction(updateAction: UpdateActionTap, completion: @escaping (Result<Void, Error>) -> Void) {
        #if canImport(AppCenterDistribute)
            NSLog("Appcenter: notifyDistributeUpdateAction \(updateAction)")
            if (updateAction == UpdateActionTap.update){
               Distribute.notify(.update)
            } else if (updateAction == UpdateActionTap.postpone){
               Distribute.notify(.postpone)
            }
        #else
        NSLog("Appcenter: [distribute not available] notifyDistributeUpdateAction \(updateAction)")
        #endif
    }
    
    func handleDistributeUpdateAction(updateAction: UpdateActionTap, completion: @escaping (Result<Void, Error>) -> Void) {
        #if canImport(AppCenterDistribute)
            NSLog("Appcenter: handleDistributeUpdateAction \(updateAction)")
            completion(.success(Void()))
        #else
        NSLog("Appcenter: [distribute not available] handleDistributeUpdateAction \(updateAction)")
        #endif
    }
    
    func setDistributeDebugEnabled(enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        NSLog("Appcenter: [distribute not available] setDistributeDebugEnabled \(enabled)")
        completion(.success(Void()))
    }
    
    func isDistributeEnabled(completion: @escaping (Result<Bool, Error>) -> Void) {
        #if canImport(AppCenterDistribute)
            NSLog("Appcenter: isDistributeEnabled \(Distribute.enabled)")
            completion(.success(Distribute.enabled))
        #else
            NSLog("Appcenter: [distribute not available] isDistributeEnabled \(Distribute.enabled)")
            completion(.success(false))
        #endif
    }
    
    func disableAutomaticCheckForUpdate(completion: @escaping (Result<Void, Error>) -> Void) {
        #if canImport(AppCenterDistribute)
            NSLog("Appcenter: [distribute not available] disableAutomaticCheckForUpdate")
            Distribute.disableAutomaticCheckForUpdate()
        #else
            NSLog("Appcenter: [distribute not available] disableAutomaticCheckForUpdate")
        #endif
        completion(.success(Void()))
    }
    
    func checkForUpdates(completion: @escaping (Result<Void, Error>) -> Void) {
        #if canImport(AppCenterDistribute)
            NSLog("Appcenter: checkForUpdates")
            Distribute.checkForUpdate()
        #else
            NSLog("Appcenter: [distribute not available] checkForUpdates")
        #endif
        completion(.success(Void()))
    }
    
    func ifExistsReleaseDetails() throws -> ReleaseDetails? {
        return nil
    }
}

extension AppcenterSdkPlugin: DistributeDelegate{
    
    private func distribute(_ distribute: Distribute, releaseAvailableWith details: ReleaseDetails) -> Bool {
        NSLog("Appcenter: distribute details: \(details)")
        // mEvents = details
//        if UserDefaults.standard.bool(forKey: kSASCustomizedUpdateAlertKey) {
//
//              // Show a dialog to the user where they can choose if they want to update.
//              let alertController = UIAlertController(title: NSLocalizedString("distribute_alert_title", tableName: "Sasquatch", comment: ""),
//                      message: NSLocalizedString("distribute_alert_message", tableName: "Sasquatch", comment: ""),
//                      preferredStyle: .alert)
//
//              // Add a "Yes"-Button and call the notifyUpdateAction-callback with .update
//              alertController.addAction(UIAlertAction(title: NSLocalizedString("distribute_alert_yes", tableName: "Sasquatch", comment: ""), style: .cancel) { _ in
//                Distribute.notify(.update)
//              })
//
//              // Add a "No"-Button and call the notifyUpdateAction-callback with .postpone
//              alertController.addAction(UIAlertAction(title: NSLocalizedString("distribute_alert_no", tableName: "Sasquatch", comment: ""), style: .default) { _ in
//                Distribute.notify(.postpone)
//              })
//
//              // Show the alert controller.
//              self.topMostViewController()?.present(alertController, animated: true)
//              return true
//            }
//            return false
        return true;
    }
    public func distributeNoReleaseAvailable(_ distribute: Distribute) {
        NSLog("Appcenter: distributeNoReleaseAvailable")
    }
    public func distributeWillExitApp(_ distribute: Distribute) {
        NSLog("Appcenter: distributeWillExitApp")
    }
    
}
#endif
