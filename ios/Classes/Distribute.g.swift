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

enum UpdateActionTap: Int {
  case postpone = 0
  case update = 1
}

/// Generated class from Pigeon that represents data sent in messages.
struct ReleaseDetails {
  var id: Int64
  var version: Int64
  var size: Int64
  var shortVersion: String
  var releaseNotes: String? = nil
  var releaseNotesUrl: String? = nil
  var minApiLevel: Int64
  var downloadUrl: String? = nil
  var isMandatoryUpdate: Bool
  var releaseHash: String
  var distributionGroupId: String

  static func fromList(_ list: [Any?]) -> ReleaseDetails? {
    let id = list[0] is Int64 ? list[0] as! Int64 : Int64(list[0] as! Int32)
    let version = list[1] is Int64 ? list[1] as! Int64 : Int64(list[1] as! Int32)
    let size = list[2] is Int64 ? list[2] as! Int64 : Int64(list[2] as! Int32)
    let shortVersion = list[3] as! String
    let releaseNotes: String? = nilOrValue(list[4])
    let releaseNotesUrl: String? = nilOrValue(list[5])
    let minApiLevel = list[6] is Int64 ? list[6] as! Int64 : Int64(list[6] as! Int32)
    let downloadUrl: String? = nilOrValue(list[7])
    let isMandatoryUpdate = list[8] as! Bool
    let releaseHash = list[9] as! String
    let distributionGroupId = list[10] as! String

    return ReleaseDetails(
      id: id,
      version: version,
      size: size,
      shortVersion: shortVersion,
      releaseNotes: releaseNotes,
      releaseNotesUrl: releaseNotesUrl,
      minApiLevel: minApiLevel,
      downloadUrl: downloadUrl,
      isMandatoryUpdate: isMandatoryUpdate,
      releaseHash: releaseHash,
      distributionGroupId: distributionGroupId
    )
  }
  func toList() -> [Any?] {
    return [
      id,
      version,
      size,
      shortVersion,
      releaseNotes,
      releaseNotesUrl,
      minApiLevel,
      downloadUrl,
      isMandatoryUpdate,
      releaseHash,
      distributionGroupId,
    ]
  }
}

private class DistributeApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return ReleaseDetails.fromList(self.readValue() as! [Any?])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class DistributeApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? ReleaseDetails {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class DistributeApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return DistributeApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return DistributeApiCodecWriter(data: data)
  }
}

class DistributeApiCodec: FlutterStandardMessageCodec {
  static let shared = DistributeApiCodec(readerWriter: DistributeApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol DistributeApi {
  func setDistributeEnabled(enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void)
  func notifyDistributeUpdateAction(updateAction: UpdateActionTap, completion: @escaping (Result<Void, Error>) -> Void)
  func handleDistributeUpdateAction(updateAction: UpdateActionTap, completion: @escaping (Result<Void, Error>) -> Void)
  func setDistributeDebugEnabled(enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void)
  func isDistributeEnabled(completion: @escaping (Result<Bool, Error>) -> Void)
  func disableAutomaticCheckForUpdate(completion: @escaping (Result<Void, Error>) -> Void)
  func checkForUpdates(completion: @escaping (Result<Void, Error>) -> Void)
  func ifExistsReleaseDetails() throws -> ReleaseDetails?
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class DistributeApiSetup {
  /// The codec used by DistributeApi.
  static var codec: FlutterStandardMessageCodec { DistributeApiCodec.shared }
  /// Sets up an instance of `DistributeApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: DistributeApi?) {
    let setDistributeEnabledChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.DistributeApi.setDistributeEnabled", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setDistributeEnabledChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let enabledArg = args[0] as! Bool
        api.setDistributeEnabled(enabled: enabledArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      setDistributeEnabledChannel.setMessageHandler(nil)
    }
    let notifyDistributeUpdateActionChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.DistributeApi.notifyDistributeUpdateAction", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      notifyDistributeUpdateActionChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let updateActionArg = UpdateActionTap(rawValue: args[0] as! Int)!
        api.notifyDistributeUpdateAction(updateAction: updateActionArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      notifyDistributeUpdateActionChannel.setMessageHandler(nil)
    }
    let handleDistributeUpdateActionChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.DistributeApi.handleDistributeUpdateAction", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      handleDistributeUpdateActionChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let updateActionArg = UpdateActionTap(rawValue: args[0] as! Int)!
        api.handleDistributeUpdateAction(updateAction: updateActionArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      handleDistributeUpdateActionChannel.setMessageHandler(nil)
    }
    let setDistributeDebugEnabledChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.DistributeApi.setDistributeDebugEnabled", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setDistributeDebugEnabledChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let enabledArg = args[0] as! Bool
        api.setDistributeDebugEnabled(enabled: enabledArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      setDistributeDebugEnabledChannel.setMessageHandler(nil)
    }
    let isDistributeEnabledChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.DistributeApi.isDistributeEnabled", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      isDistributeEnabledChannel.setMessageHandler { _, reply in
        api.isDistributeEnabled() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      isDistributeEnabledChannel.setMessageHandler(nil)
    }
    let disableAutomaticCheckForUpdateChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.DistributeApi.disableAutomaticCheckForUpdate", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      disableAutomaticCheckForUpdateChannel.setMessageHandler { _, reply in
        api.disableAutomaticCheckForUpdate() { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      disableAutomaticCheckForUpdateChannel.setMessageHandler(nil)
    }
    let checkForUpdatesChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.DistributeApi.checkForUpdates", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      checkForUpdatesChannel.setMessageHandler { _, reply in
        api.checkForUpdates() { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      checkForUpdatesChannel.setMessageHandler(nil)
    }
    let ifExistsReleaseDetailsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.appcenter_sdk.DistributeApi.ifExistsReleaseDetails", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      ifExistsReleaseDetailsChannel.setMessageHandler { _, reply in
        do {
          let result = try api.ifExistsReleaseDetails()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      ifExistsReleaseDetailsChannel.setMessageHandler(nil)
    }
  }
}
