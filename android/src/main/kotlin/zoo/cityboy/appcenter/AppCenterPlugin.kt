package zoo.cityboy.appcenter


import android.R
import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.SharedPreferences
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.WorkerThread
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes
import com.microsoft.appcenter.crashes.WrapperSdkExceptionManager
import com.microsoft.appcenter.distribute.Distribute
import com.microsoft.appcenter.distribute.DistributeListener
import com.microsoft.appcenter.distribute.ReleaseDetails
import com.microsoft.appcenter.distribute.UpdateAction
import com.microsoft.appcenter.distribute.UpdateTrack
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import zoo.cityboy.appcenter.analytics.AnalyticsApi
import zoo.cityboy.appcenter.appcenter.AppCenterApi
import zoo.cityboy.appcenter.crashes.CrashesApi
import zoo.cityboy.appcenter.distribute.DistributeApi
import java.util.Date


/** AppCenterPlugin */
class AppCenterPlugin : FlutterPlugin, ActivityAware, AppCenterApi, AnalyticsApi, CrashesApi, DistributeApi{

    private var events = mutableMapOf<String, Date>()
    private var mainActivity: Activity? = null
    private lateinit var preferences: SharedPreferences
    private var mEventChannel: EventChannel? = null
    private var mEvents: EventSink? = null
    private var uiThreadHandler: Handler = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(p0: FlutterPluginBinding) {

        p0.applicationContext.getSharedPreferences("AppCenterFlutter", Context.MODE_PRIVATE)
        events["onAttachedToEngine_start"] = Date()
        AppCenterApi.setUp(p0.binaryMessenger, this)
        AnalyticsApi.setUp(p0.binaryMessenger, this)
        CrashesApi.setUp(p0.binaryMessenger, this)
        DistributeApi.setUp(p0.binaryMessenger, this)
        events["onAttachedToEngine_done"] = Date()

        mEventChannel =
            EventChannel(p0.binaryMessenger, "zoo.cityboy.appcenter/distribute_events")
        mEventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventSink) {
                println("onListen $arguments -> $events")
                mEvents = events
            }

            override fun onCancel(arguments: Any?) {
                println("onCancel -> $arguments")

                mEvents = null
            }
        })
    }

    override fun onDetachedFromEngine(p0: FlutterPluginBinding) {
        events["onDetachedFromEngine_start"] = Date()
        mEventChannel?.setStreamHandler(null)
        mEventChannel = null
        AppCenterApi.setUp(p0.binaryMessenger, null)
        AnalyticsApi.setUp(p0.binaryMessenger, null)
        CrashesApi.setUp(p0.binaryMessenger, null)
        DistributeApi.setUp(p0.binaryMessenger, null)
    }

    override fun onAttachedToActivity(p0: ActivityPluginBinding) {
        events["onAttachedToActivity_start"] = Date()
        mainActivity = p0.activity
        preferences =
            p0.activity.getSharedPreferences("AppCenterFlutter", Context.MODE_PRIVATE);
    }

    override fun onDetachedFromActivityForConfigChanges() {
        events["onDetachedFromActivityForConfigChanges"] = Date()
        mainActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {

        events["onReattachedToActivityForConfigChanges"] = Date()
        mainActivity = p0.activity
        preferences =
            p0.activity.getSharedPreferences("AppCenterFlutter", Context.MODE_PRIVATE);
        
    }

    override fun onDetachedFromActivity() {
        mainActivity = null
        events["onDetachedFromActivity"] = Date()
    }

    // App Center
    override fun start(secret: String, usePrivateTrack: Boolean, callback: (Result<Unit>) -> Unit) {
        events["AppCenterStart"] = Date()
        mainActivity?.let { it ->
            if (!AppCenter.isConfigured()) {
                if (usePrivateTrack){
                    Distribute.setUpdateTrack(UpdateTrack.PRIVATE);
                }
                Distribute.setEnabled(true)
                Distribute.setEnabledForDebuggableBuild(true)
                Distribute.setListener(
                        object : DistributeListener {
                            override fun onNoReleaseAvailable(activity: Activity?) {
                                println("Distribute: onNoReleaseAvailable")
                                uiThreadHandler.post { mEvents?.success(null) }
                            }
                            override fun onReleaseAvailable(
                                    activity: Activity?,
                                    releaseDetails: ReleaseDetails?
                            ): Boolean {
                                releaseDetails?.let {detail ->
                                    try{
                                       val converted = mapOf<String, Any?>(
                                           "id" to detail.id.toInt(),
                                           "version" to detail.version.toInt(),
                                           "shortVersion" to detail.shortVersion.toString(),
                                           "size" to detail.size.toInt(),
                                           "releaseDetails" to detail.releaseNotes?.toString(),
                                           "releaseNotesUrl" to detail.releaseNotesUrl?.toString(),
                                           "minApiLevel" to 23,
                                           "downloadUrl" to detail.downloadUrl.toString(),
                                           "isMandatoryUpdate" to detail.isMandatoryUpdate,
                                           "releaseHash" to detail.releaseHash.toString(),
                                           "distributionGroupId" to
                                            detail.distributionGroupId.toString(),
                                       )
                                        println("[kt] Distribute: onReleaseAvailable $converted")

                                        uiThreadHandler.post { mEvents?.success(converted) }

                                    } catch (e: Exception){
                                        println("error: ${e.message}")
                                        uiThreadHandler.post { mEvents?.success(null) }

                                        return false
                                    }

                                 } ?: {
                                    println("Distribute: onReleaseAvailable $releaseDetails")
                                    uiThreadHandler.post { mEvents?.success(null) }
                                 }
                                
                                
                                
                                return releaseDetails != null
                            }
                        }
                )

                
                AppCenter.setLogLevel(Log.VERBOSE)
                Analytics.setTransmissionInterval(15)
                AppCenter.start(it.application, secret, Analytics::class.java, Crashes::class.java, Distribute::class.java)
                events["AppCenterStart_done"] = Date()
             
            }

            println("start: ${AppCenter.isConfigured()}")
        }
    }


    override fun setLogLevel(level: Long, callback: (Result<Unit>) -> Unit) {
        println("setLogLevel: $level")
        AppCenter.setLogLevel(level.toInt())
    }


    override fun setEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
        println("setEnabled: $enabled")
        AppCenter.setEnabled(enabled).thenAccept { callback(Result.success(Unit)) }
    }

    override fun isEnabled(callback: (Result<Boolean>) -> Unit) {
        AppCenter.isEnabled().thenAccept { value -> 
            println("isEnabled: $value")
            callback(Result.success(value))
         }
    }

    override fun isConfigured(): Boolean = AppCenter.isConfigured()

    override fun getInstallId(callback: (Result<String>) -> Unit) {
        AppCenter.getInstallId().thenAccept { uuid -> 
            println("getInstallId: $uuid")

            callback(Result.success(uuid.toString())) 
        }
    }

    override fun isRunningInAppCenterTestCloud(): Boolean = AppCenter.isRunningInAppCenterTestCloud()

    // App Center Analytics
    override fun trackEvent(name: String, properties: Map<String, String>?, flags: Long?) {
        println("trackEvent: name: $name properties: $properties flags: $flags")

        if (flags != null) {
            Analytics.trackEvent(name, properties, flags.toInt())
        } else {
            Analytics.trackEvent(name, properties)
        }
    }

    override fun trackPage(name: String, properties: Map<String, String>?) {
        
    }

    override fun pause() {
        Analytics.pause()
    }

    override fun resume() {
        Analytics.resume()
    }

    override fun analyticsSetEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
        Analytics.setEnabled(enabled).thenAccept { 
            println("analyticsSetEnabled: $enabled")

            callback(Result.success(Unit)) 
        }
    }

    override fun analyticsIsEnabled(callback: (Result<Boolean>) -> Unit) {
        Analytics.isEnabled().thenAccept { value -> 
            println("analyticsIsEnabled: $value")
            callback(Result.success(value)) 
        }
    }

    override fun enableManualSessionTracker() {
        Analytics.enableManualSessionTracker()
    }

    override fun startSession() {
        Analytics.startSession()
    }

    override fun setTransmissionInterval(seconds: Long): Boolean = Analytics.setTransmissionInterval(seconds.toInt())

    // App Center Crashes
    override fun generateTestCrash() {
        Crashes.generateTestCrash()
    }

    override fun hasReceivedMemoryWarningInLastSession(callback: (Result<Boolean>) -> Unit) {
        Crashes.hasReceivedMemoryWarningInLastSession()
            .thenAccept { value -> callback(Result.success(value)) }
    }

    override fun hasCrashedInLastSession(callback: (Result<Boolean>) -> Unit) {
        Crashes.hasCrashedInLastSession()
            .thenAccept { value -> 
                println("hasCrashedInLastSession: $value")
                callback(Result.success(value)) 
            }
    }

    override fun crashesSetEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
        Crashes.setEnabled(enabled).thenAccept { 
            println("crashesSetEnabled: $enabled")
            callback(Result.success(Unit)) 
        }
    }

    override fun crashesIsEnabled(callback: (Result<Boolean>) -> Unit) {
        Crashes.isEnabled().thenAccept { value -> 
            println("crashesIsEnabled: $value")
            callback(Result.success(value)) 
        }
    }

    override fun trackException(
        message: String,
        type: String?,
        stackTrace: String?,
        properties: Map<String, String>?
    ) {
        val exceptionModel = com.microsoft.appcenter.crashes.ingestion.models.Exception()
        exceptionModel.message = message
        exceptionModel.type = type
        exceptionModel.stackTrace = stackTrace
        exceptionModel.wrapperSdkName = "appcenter.flutter"
        WrapperSdkExceptionManager.trackException(exceptionModel, properties, null)
    }
    // App Center Crashes
    
    
    // App Center Distribution

    override fun setDistributeEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
        Distribute.setEnabled(enabled).thenAccept { 
            println("setDistributeEnabled: $enabled")
            callback(Result.success(Unit)) 
        }
    }

    override fun setDistributeDebugEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
       
        println("setEnabledForDebuggableBuild: $enabled")
        Distribute.setEnabledForDebuggableBuild(enabled)
        callback(Result.success(Unit))
    }

    override fun isDistributeEnabled(callback: (Result<Boolean>) -> Unit) {
        Distribute.isEnabled().thenAccept { value -> 
            println("isDistributeEnabled: $value")
            callback(Result.success(value)) 
        }
    }


    override fun disableAutomaticCheckForUpdate(callback: (Result<Unit>) -> Unit) {
        Distribute.disableAutomaticCheckForUpdate()
        println("disableAutomaticCheckForUpdate")

        callback(Result.success(Unit))
    }
    

    override fun checkForUpdates(callback: (Result<Unit>) -> Unit) {
        Distribute.checkForUpdate()
        println("checkForUpdate")
        callback(Result.success(Unit))
    }

    override fun ifExistsReleaseDetails(): zoo.cityboy.appcenter.distribute.ReleaseDetails? {
        return null
    }

    override fun notifyDistributeUpdateAction(updateAction: Long, callback: (Result<Unit>) -> Unit) {
        Distribute.notifyUpdateAction(updateAction.toInt())
        println("notifyUpdateAction: $updateAction")
        callback(Result.success(Unit))
    }

    override fun handleDistributeUpdateAction(updateAction: Long, callback: (Result<Unit>) -> Unit) {
        Distribute.notifyUpdateAction(updateAction.toInt())
        println("notifyUpdateAction: $updateAction")
        callback(Result.success(Unit))
    }
}
