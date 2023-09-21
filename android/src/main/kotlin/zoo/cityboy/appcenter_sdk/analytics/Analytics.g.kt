// Copyright (c) 2023 zoocityboy. All rights reserved.
// Autogenerated from Pigeon (v10.1.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package zoo.cityboy.appcenter_sdk.analytics

import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface AnalyticsApi {
  fun trackEvent(name: String, properties: Map<String, String>?, flags: Long?)
  fun trackPage(name: String, properties: Map<String, String>?)
  fun pause()
  fun resume()
  fun analyticsSetEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit)
  fun analyticsIsEnabled(callback: (Result<Boolean>) -> Unit)
  fun enableManualSessionTracker()
  fun startSession()
  fun setTransmissionInterval(seconds: Long): Boolean

  companion object {
    /** The codec used by AnalyticsApi. */
    val codec: MessageCodec<Any?> by lazy {
      StandardMessageCodec()
    }
    /** Sets up an instance of `AnalyticsApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: AnalyticsApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.trackEvent", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val nameArg = args[0] as String
            val propertiesArg = args[1] as Map<String, String>?
            val flagsArg = args[2].let { if (it is Int) it.toLong() else it as Long? }
            var wrapped: List<Any?>
            try {
              api.trackEvent(nameArg, propertiesArg, flagsArg)
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.trackPage", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val nameArg = args[0] as String
            val propertiesArg = args[1] as Map<String, String>?
            var wrapped: List<Any?>
            try {
              api.trackPage(nameArg, propertiesArg)
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.pause", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              api.pause()
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.resume", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              api.resume()
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.analyticsSetEnabled", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val enabledArg = args[0] as Boolean
            api.analyticsSetEnabled(enabledArg) { result: Result<Unit> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                reply.reply(wrapResult(null))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.analyticsIsEnabled", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.analyticsIsEnabled() { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.enableManualSessionTracker", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              api.enableManualSessionTracker()
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.startSession", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              api.startSession()
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.appcenter_sdk.AnalyticsApi.setTransmissionInterval", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val secondsArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.setTransmissionInterval(secondsArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
