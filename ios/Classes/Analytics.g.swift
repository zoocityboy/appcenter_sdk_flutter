// Copyright (c) 2023 zoocityboy. All rights reserved.
// Autogenerated from Pigeon (v10.1.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol AnalyticsApi {
  func trackEvent(name: String, properties: [String: String]?, flags: Int64?) throws
  func trackPage(name: String, properties: [String: String]?) throws
  func pause() throws
  func resume() throws
  func analyticsSetEnabled(enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void)
  func analyticsIsEnabled(completion: @escaping (Result<Bool, Error>) -> Void)
  func enableManualSessionTracker() throws
  func startSession() throws
  func setTransmissionInterval(seconds: Int64) throws -> Bool
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class AnalyticsApiSetup {
  /// The codec used by AnalyticsApi.
  /// Sets up an instance of `AnalyticsApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: AnalyticsApi?) {
    let trackEventChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.trackEvent", binaryMessenger: binaryMessenger)
    if let api = api {
      trackEventChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let nameArg = args[0] as! String
        let propertiesArg: [String: String]? = nilOrValue(args[1])
        let flagsArg: Int64? = args[2] is NSNull ? nil : (args[2] is Int64? ? args[2] as! Int64? : Int64(args[2] as! Int32))
        do {
          try api.trackEvent(name: nameArg, properties: propertiesArg, flags: flagsArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      trackEventChannel.setMessageHandler(nil)
    }
    let trackPageChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.trackPage", binaryMessenger: binaryMessenger)
    if let api = api {
      trackPageChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let nameArg = args[0] as! String
        let propertiesArg: [String: String]? = nilOrValue(args[1])
        do {
          try api.trackPage(name: nameArg, properties: propertiesArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      trackPageChannel.setMessageHandler(nil)
    }
    let pauseChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.pause", binaryMessenger: binaryMessenger)
    if let api = api {
      pauseChannel.setMessageHandler { _, reply in
        do {
          try api.pause()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      pauseChannel.setMessageHandler(nil)
    }
    let resumeChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.resume", binaryMessenger: binaryMessenger)
    if let api = api {
      resumeChannel.setMessageHandler { _, reply in
        do {
          try api.resume()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      resumeChannel.setMessageHandler(nil)
    }
    let analyticsSetEnabledChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.analyticsSetEnabled", binaryMessenger: binaryMessenger)
    if let api = api {
      analyticsSetEnabledChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let enabledArg = args[0] as! Bool
        api.analyticsSetEnabled(enabled: enabledArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      analyticsSetEnabledChannel.setMessageHandler(nil)
    }
    let analyticsIsEnabledChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.analyticsIsEnabled", binaryMessenger: binaryMessenger)
    if let api = api {
      analyticsIsEnabledChannel.setMessageHandler { _, reply in
        api.analyticsIsEnabled() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      analyticsIsEnabledChannel.setMessageHandler(nil)
    }
    let enableManualSessionTrackerChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.enableManualSessionTracker", binaryMessenger: binaryMessenger)
    if let api = api {
      enableManualSessionTrackerChannel.setMessageHandler { _, reply in
        do {
          try api.enableManualSessionTracker()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      enableManualSessionTrackerChannel.setMessageHandler(nil)
    }
    let startSessionChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.startSession", binaryMessenger: binaryMessenger)
    if let api = api {
      startSessionChannel.setMessageHandler { _, reply in
        do {
          try api.startSession()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      startSessionChannel.setMessageHandler(nil)
    }
    let setTransmissionIntervalChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.setTransmissionInterval", binaryMessenger: binaryMessenger)
    if let api = api {
      setTransmissionIntervalChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let secondsArg = args[0] is Int64 ? args[0] as! Int64 : Int64(args[0] as! Int32)
        do {
          let result = try api.setTransmissionInterval(seconds: secondsArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setTransmissionIntervalChannel.setMessageHandler(nil)
    }
  }
}