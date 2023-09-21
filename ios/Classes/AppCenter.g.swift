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

enum LoggerLevel: Int {
  case verbose = 0
  case debug = 1
  case info = 2
  case warning = 3
  case error = 4
  case fatal = 5
  case none = 6
}

/// Generated class from Pigeon that represents data sent in messages.
struct AppCenterConfig {
  var secret: String
  var crashEnabled: Bool
  var analyticsEnabled: Bool
  var distributeEnabled: Bool
  var usePrivateTrack: Bool
  var logLevel: LoggerLevel
  var transmissionInterval: Int64

  static func fromList(_ list: [Any?]) -> AppCenterConfig? {
    let secret = list[0] as! String
    let crashEnabled = list[1] as! Bool
    let analyticsEnabled = list[2] as! Bool
    let distributeEnabled = list[3] as! Bool
    let usePrivateTrack = list[4] as! Bool
    let logLevel = LoggerLevel(rawValue: list[5] as! Int)!
    let transmissionInterval = list[6] is Int64 ? list[6] as! Int64 : Int64(list[6] as! Int32)

    return AppCenterConfig(
      secret: secret,
      crashEnabled: crashEnabled,
      analyticsEnabled: analyticsEnabled,
      distributeEnabled: distributeEnabled,
      usePrivateTrack: usePrivateTrack,
      logLevel: logLevel,
      transmissionInterval: transmissionInterval
    )
  }
  func toList() -> [Any?] {
    return [
      secret,
      crashEnabled,
      analyticsEnabled,
      distributeEnabled,
      usePrivateTrack,
      logLevel.rawValue,
      transmissionInterval,
    ]
  }
}

private class AppCenterApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return AppCenterConfig.fromList(self.readValue() as! [Any?])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class AppCenterApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? AppCenterConfig {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class AppCenterApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return AppCenterApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return AppCenterApiCodecWriter(data: data)
  }
}

class AppCenterApiCodec: FlutterStandardMessageCodec {
  static let shared = AppCenterApiCodec(readerWriter: AppCenterApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol AppCenterApi {
  func start(config: AppCenterConfig) throws
  func setEnabled(enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void)
  func isEnabled(completion: @escaping (Result<Bool, Error>) -> Void)
  func isConfigured() throws -> Bool
  func getInstallId(completion: @escaping (Result<String, Error>) -> Void)
  func isRunningInAppCenterTestCloud() throws -> Bool
  func setUserId(userId: String, completion: @escaping (Result<Void, Error>) -> Void)
  func setCountryCode(countryCode: String, completion: @escaping (Result<Void, Error>) -> Void)
  func getSdkVersion() throws -> String
  func setNetworkRequestsAllowed(enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void)
  func isNetworkRequestsAllowed() throws -> Bool
  func setLogLevel(level: LoggerLevel) throws
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class AppCenterApiSetup {
  /// The codec used by AppCenterApi.
  static var codec: FlutterStandardMessageCodec { AppCenterApiCodec.shared }
  /// Sets up an instance of `AppCenterApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: AppCenterApi?) {
    let startChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AppCenterApi.start", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      startChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let configArg = args[0] as! AppCenterConfig
        do {
          try api.start(config: configArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      startChannel.setMessageHandler(nil)
    }
    let setEnabledChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AppCenterApi.setEnabled", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setEnabledChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let enabledArg = args[0] as! Bool
        api.setEnabled(enabled: enabledArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      setEnabledChannel.setMessageHandler(nil)
    }
    let isEnabledChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AppCenterApi.isEnabled", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      isEnabledChannel.setMessageHandler { _, reply in
        api.isEnabled() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      isEnabledChannel.setMessageHandler(nil)
    }
    let isConfiguredChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AppCenterApi.isConfigured", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      isConfiguredChannel.setMessageHandler { _, reply in
        do {
          let result = try api.isConfigured()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      isConfiguredChannel.setMessageHandler(nil)
    }
    let getInstallIdChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AppCenterApi.getInstallId", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getInstallIdChannel.setMessageHandler { _, reply in
        api.getInstallId() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getInstallIdChannel.setMessageHandler(nil)
    }
    let isRunningInAppCenterTestCloudChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AppCenterApi.isRunningInAppCenterTestCloud", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      isRunningInAppCenterTestCloudChannel.setMessageHandler { _, reply in
        do {
          let result = try api.isRunningInAppCenterTestCloud()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      isRunningInAppCenterTestCloudChannel.setMessageHandler(nil)
    }
    let setUserIdChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AppCenterApi.setUserId", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setUserIdChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let userIdArg = args[0] as! String
        api.setUserId(userId: userIdArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      setUserIdChannel.setMessageHandler(nil)
    }
    let setCountryCodeChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AppCenterApi.setCountryCode", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setCountryCodeChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let countryCodeArg = args[0] as! String
        api.setCountryCode(countryCode: countryCodeArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      setCountryCodeChannel.setMessageHandler(nil)
    }
    let getSdkVersionChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AppCenterApi.getSdkVersion", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getSdkVersionChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getSdkVersion()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getSdkVersionChannel.setMessageHandler(nil)
    }
    let setNetworkRequestsAllowedChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AppCenterApi.setNetworkRequestsAllowed", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setNetworkRequestsAllowedChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let enabledArg = args[0] as! Bool
        api.setNetworkRequestsAllowed(enabled: enabledArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      setNetworkRequestsAllowedChannel.setMessageHandler(nil)
    }
    let isNetworkRequestsAllowedChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AppCenterApi.isNetworkRequestsAllowed", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      isNetworkRequestsAllowedChannel.setMessageHandler { _, reply in
        do {
          let result = try api.isNetworkRequestsAllowed()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      isNetworkRequestsAllowedChannel.setMessageHandler(nil)
    }
    let setLogLevelChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.AppCenterApi.setLogLevel", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setLogLevelChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let levelArg = LoggerLevel(rawValue: args[0] as! Int)!
        do {
          try api.setLogLevel(level: levelArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setLogLevelChannel.setMessageHandler(nil)
    }
  }
}
