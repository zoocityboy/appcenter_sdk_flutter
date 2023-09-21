package zoo.cityboy.appcenter_sdk

import android.R
import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.Toast
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
import zoo.cityboy.appcenter_sdk.analytics.AnalyticsApi
import zoo.cityboy.appcenter_sdk.appcenter.AppCenterApi
import zoo.cityboy.appcenter_sdk.appcenter.AppCenterConfig
import zoo.cityboy.appcenter_sdk.appcenter.LoggerLevel
import zoo.cityboy.appcenter_sdk.crashes.CrashesApi
import zoo.cityboy.appcenter_sdk.distribute.DistributeApi
import zoo.cityboy.appcenter_sdk.distribute.UpdateActionTap
import java.util.Date
import java.util.Locale


/** AppcenterSdkPlugin */
class AppcenterSdkPlugin: FlutterPlugin, ActivityAware, AppCenterApi, AnalyticsApi, CrashesApi,
    DistributeApi {

    private var events = mutableMapOf<String, Date>()
    private var mainActivity: Activity? = null
    private lateinit var preferences: SharedPreferences
    private var mEventChannel: EventChannel? = null
    private var mEvents: EventSink? = null
    private var uiThreadHandler: Handler = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(p0: FlutterPluginBinding) {
        p0.applicationContext.getSharedPreferences("AppCenterSdkFlutter", Context.MODE_PRIVATE)
        events["onAttachedToEngine_start"] = Date()
        AppCenterApi.setUp(p0.binaryMessenger, this)
        AnalyticsApi.setUp(p0.binaryMessenger, this)
        CrashesApi.setUp(p0.binaryMessenger, this)
        DistributeApi.setUp(p0.binaryMessenger, this)
        events["onAttachedToEngine_done"] = Date()

        mEventChannel =
            EventChannel(p0.binaryMessenger, "zoo.cityboy.appcenter_sdk/distribute_events")
        mEventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventSink) {
                Log.i("AppcenterSdk", "onListen $arguments -> $events")
                mEvents = events
            }

            override fun onCancel(arguments: Any?) {
                Log.i("AppcenterSdk", "onCancel -> $arguments")

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
            p0.activity.getSharedPreferences("AppCenterSdkFlutter", Context.MODE_PRIVATE);
        Distribute.checkForUpdate()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        events["onDetachedFromActivityForConfigChanges"] = Date()
        mainActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {

        events["onReattachedToActivityForConfigChanges"] = Date()
        mainActivity = p0.activity
        preferences =
            p0.activity.getSharedPreferences("AppCenterSdkFlutter", Context.MODE_PRIVATE);
        
    }

    override fun onDetachedFromActivity() {
        mainActivity = null
        events["onDetachedFromActivity"] = Date()
    }

    // App Center


    override fun start(config: AppCenterConfig) {
        events["AppCenterStart"] = Date()
        Distribute.setEnabled(config.distributeEnabled)
        Distribute.setListener( AppCenterDistributeListener())


        mainActivity?.let { it ->
            if (!AppCenter.isConfigured()) {


//                    object : DistributeListener {
//                        override fun onNoReleaseAvailable(activity: Activity?) {
//                            Log.i("AppcenterSdk", "Distribute: onNoReleaseAvailable")
//                            uiThreadHandler.postDelayed({ mEvents?.success(null) }, 1000)
//                        }
//                        override fun onReleaseAvailable(
//                            activity: Activity?,
//                            releaseDetails: ReleaseDetails?
//                        ): Boolean {
//                            releaseDetails?.let {detail ->
//                                try{
//                                    val converted = mapOf<String, Any?>(
//                                        "id" to detail.id.toInt(),
//                                        "version" to detail.version.toInt(),
//                                        "shortVersion" to detail.shortVersion.toString(),
//                                        "size" to detail.size.toInt(),
//                                        "releaseNotes" to detail.releaseNotes?.toString(),
//                                        "releaseNotesUrl" to detail.releaseNotesUrl?.toString(),
//                                        "minApiLevel" to Build.VERSION.SDK_INT,
//                                        "downloadUrl" to detail.downloadUrl.toString(),
//                                        "isMandatoryUpdate" to detail.isMandatoryUpdate,
//                                        "releaseHash" to detail.releaseHash.toString(),
//                                        "distributionGroupId" to
//                                                detail.distributionGroupId.toString(),
//                                    )
//                                    Log.i("AppcenterSdk", "[kt] Distribute: onReleaseAvailable $converted")
//
//                                    uiThreadHandler.postDelayed( { mEvents?.success(converted) },1000)
//
//                                } catch (e: Exception){
//                                    Log.i("AppcenterSdk", "error: ${e.message}")
//                                    uiThreadHandler.postDelayed({ mEvents?.success(null) }, 1000)
//
//                                    return false
//                                }
//
//                            } ?: {
//                                Log.i("AppcenterSdk", "Distribute: onReleaseAvailable $releaseDetails")
//                                uiThreadHandler.postDelayed( { mEvents?.success(null) },1000)
//                            }
//
//                            return true
//                        }
//                    }
//                )

                Analytics.setTransmissionInterval(config.transmissionInterval.toInt())
                AppCenter.start(it.application, config.secret, Analytics::class.java, Crashes::class.java, Distribute::class.java)
                events["AppCenterStart_done"] = Date()


            } else {
                Log.i("AppcenterSdk", "AppCenter is configured")
            }
            setDistributeEnabled(config.crashEnabled,{_->})
            crashesSetEnabled(config.crashEnabled,{_->})
            analyticsSetEnabled(config.analyticsEnabled,{_->})
            setLogLevel(config.logLevel)

            Log.i("AppcenterSdk", "start: ${AppCenter.isConfigured()}")
        }
    }


    override fun setEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
        Log.i("AppcenterSdk", "setEnabled: $enabled")
        AppCenter.setEnabled(enabled).thenAccept { callback(Result.success(Unit)) }
    }

    override fun isEnabled(callback: (Result<Boolean>) -> Unit) {
        try {
            AppCenter.isEnabled().thenAccept { value ->
                Log.i("AppcenterSdk", "isEnabled: $value")
                callback(Result.success(value))
            }
        } catch (e: Exception){
            callback(Result.failure(e))
        }

    }

    override fun isConfigured(): Boolean = AppCenter.isConfigured()

    override fun getInstallId(callback: (Result<String>) -> Unit) {
        try {
            AppCenter.getInstallId().thenAccept { uuid ->
                Log.i("AppcenterSdk", "getInstallId: $uuid")

                callback(Result.success(uuid.toString()))
            }
        } catch (e: Exception){
            callback(Result.failure(e))
        }
    }

    override fun isRunningInAppCenterTestCloud(): Boolean = AppCenter.isRunningInAppCenterTestCloud()

    override fun setUserId(userId: String, callback: (Result<Unit>) -> Unit) {
        try{
            AppCenter.setUserId(userId);
            callback(Result.success(Unit))
        } catch (e: Exception){
            callback(Result.failure(e))
        }
    }

    override fun setCountryCode(countryCode: String, callback: (Result<Unit>) -> Unit) {
        try{
            AppCenter.setCountryCode(countryCode);
            callback(Result.success(Unit))
        } catch (e: Exception){
            callback(Result.failure(e))
        }
    }

    override fun getSdkVersion(): String {
        return AppCenter.getSdkVersion()
    }

    override fun setNetworkRequestsAllowed(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
        try{
            AppCenter.setNetworkRequestsAllowed(enabled);
            callback(Result.success(Unit))
        } catch (e: Exception){
            callback(Result.failure(e))
        }
    }

    override fun isNetworkRequestsAllowed(): Boolean {
        return AppCenter.isNetworkRequestsAllowed()
    }

    override fun setLogLevel(level: LoggerLevel) {
        Log.i("AppcenterSdk", "setLogLevel: $level")
        AppCenter.setLogLevel(level.ordinal)
    }

    // App Center Analytics
    override fun trackEvent(name: String, properties: Map<String, String>?, flags: Long?) {
        Log.i("AppcenterSdk", "trackEvent: name: $name properties: $properties flags: $flags")

        if (flags != null) {
            Analytics.trackEvent(name, properties, flags.toInt())
        } else {
            Analytics.trackEvent(name, properties)
        }
    }

    override fun trackPage(name: String, properties: Map<String, String>?) {
        Analytics.trackEvent(name, properties)
    }

    override fun pause() {
        Analytics.pause()
    }

    override fun resume() {
        Analytics.resume()
    }

    override fun analyticsSetEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
        try {
            Analytics.setEnabled(enabled).thenAccept {
                Log.i("AppcenterSdk", "analyticsSetEnabled: $enabled")

                callback(Result.success(Unit))
            }
        } catch (e: Exception){
            callback(Result.failure(e))
        }

    }

    override fun analyticsIsEnabled(callback: (Result<Boolean>) -> Unit) {
        try {
            Analytics.isEnabled().thenAccept { value ->
                Log.i("AppcenterSdk", "analyticsIsEnabled: $value")
                callback(Result.success(value))
            }
        } catch (e: Exception){
            callback(Result.failure(e))
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
        try {
            Crashes.hasReceivedMemoryWarningInLastSession()
                .thenAccept { value -> callback(Result.success(value)) }
        } catch (e: Exception){
            callback(Result.failure(e))
        }

    }

    override fun hasCrashedInLastSession(callback: (Result<Boolean>) -> Unit) {
        try {
            Crashes.hasCrashedInLastSession()
                .thenAccept { value ->
                    Log.i("AppcenterSdk", "hasCrashedInLastSession: $value")
                    callback(Result.success(value))
                }
        } catch (e: Exception)  {
            callback(Result.failure(e))
        }

    }

    override fun crashesSetEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
        try {
            Crashes.setEnabled(enabled).thenAccept {
                Log.i("AppcenterSdk", "crashesSetEnabled: $enabled")
                callback(Result.success(Unit))
            }
        } catch (e: Exception){
            callback(Result.failure(e))
        }

    }

    override fun crashesIsEnabled(callback: (Result<Boolean>) -> Unit) {
        try {
            Crashes.isEnabled().thenAccept { value ->
                Log.i("AppcenterSdk", "crashesIsEnabled: $value")
                callback(Result.success(value))
            }
        } catch (e: Exception){
            callback(Result.failure(e))
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
        try {
            Distribute.setEnabled(enabled).thenAccept {
                Log.i("AppcenterSdk", "setDistributeEnabled: $enabled")
                callback(Result.success(Unit))
            }
        } catch (e: Exception){
            callback(Result.failure(e))
        }

    }


    override fun setDistributeDebugEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
       try {
           Log.i("AppcenterSdk", "setEnabledForDebuggableBuild: $enabled")
           Distribute.setEnabledForDebuggableBuild(enabled)
           callback(Result.success(Unit))
       } catch (e: Exception){
           callback(Result.failure(e))
       }

    }

    override fun isDistributeEnabled(callback: (Result<Boolean>) -> Unit) {
        try {
            Distribute.isEnabled().thenAccept { value ->
                Log.i("AppcenterSdk", "isDistributeEnabled: $value")
                callback(Result.success(value))
            }
        } catch (e: Exception){
            callback(Result.failure(e))
        }

    }


    override fun disableAutomaticCheckForUpdate(callback: (Result<Unit>) -> Unit) {
        try {
            Distribute.disableAutomaticCheckForUpdate()
            Log.i("AppcenterSdk", "disableAutomaticCheckForUpdate")

            callback(Result.success(Unit))
        } catch (e: Exception){
            callback(Result.failure(e))
        }

    }
    

    override fun checkForUpdates(callback: (Result<Unit>) -> Unit) {
        try {
            Distribute.checkForUpdate()
            Log.i("AppcenterSdk", "checkForUpdate")
            callback(Result.success(Unit))
        } catch (e: Exception){
            callback(Result.failure(e))
        }
    }

    override fun ifExistsReleaseDetails(): zoo.cityboy.appcenter_sdk.distribute.ReleaseDetails? {
        return null
    }

    override fun notifyDistributeUpdateAction(updateAction:UpdateActionTap, callback: (Result<Unit>) -> Unit) {
        try{
            val action = when (updateAction){
                UpdateActionTap.UPDATE -> com.microsoft.appcenter.distribute.UpdateAction.UPDATE
                UpdateActionTap.POSTPONE -> com.microsoft.appcenter.distribute.UpdateAction.POSTPONE
            }
            Distribute.notifyUpdateAction(action)
            Log.i("AppcenterSdk", "notifyUpdateAction: $updateAction")
            callback(Result.success(Unit))
        } catch (e: Exception){
            callback(Result.failure(e))
        }
    }

    override fun handleDistributeUpdateAction(updateAction: UpdateActionTap, callback: (Result<Unit>) -> Unit) {
        try{
            val action = when (updateAction){
                UpdateActionTap.UPDATE -> com.microsoft.appcenter.distribute.UpdateAction.UPDATE
                UpdateActionTap.POSTPONE -> com.microsoft.appcenter.distribute.UpdateAction.POSTPONE
            }
            Distribute.notifyUpdateAction(action)
            Log.i("AppcenterSdk", "notifyUpdateAction: $updateAction")
            callback(Result.success(Unit))
        } catch (e: Exception){
            callback(Result.failure(e))
        }
    }
}

class AppCenterDistributeListener : DistributeListener {
    override fun onReleaseAvailable(activity: Activity, releaseDetails: ReleaseDetails): Boolean {
        val releaseNotes = releaseDetails.releaseNotes
        val custom =  releaseNotes != null

            val dialogBuilder = MaterialAlertDialogBuilder(activity)
                .setIcon(android.R.drawable.stat_sys_download_done)
            .setTitle(
                String.format(
                    activity.getString(com.microsoft.appcenter.distribute.R.string.appcenter_distribute_update_dialog_title),
                    releaseDetails.shortVersion
                )
            )
            .setMessage(releaseNotes)
            .setPositiveButton(com.microsoft.appcenter.distribute.R.string.appcenter_distribute_update_dialog_download,
                DialogInterface.OnClickListener { dialog, which ->
                    Distribute.notifyUpdateAction(
                        UpdateAction.UPDATE
                    )
                })
            .setCancelable(false)
            if (!releaseDetails.isMandatoryUpdate) {
                dialogBuilder.setNegativeButton(com.microsoft.appcenter.distribute.R.string.appcenter_distribute_update_dialog_postpone,
                    DialogInterface.OnClickListener { dialog, which ->
                        Distribute.notifyUpdateAction(
                            UpdateAction.POSTPONE
                        )
                    })
            }
            dialogBuilder.setNeutralButton(com.microsoft.appcenter.distribute.R.string.appcenter_distribute_update_dialog_view_release_notes,
                DialogInterface.OnClickListener { dialogInterface, i ->
                    activity.startActivity(
                        Intent(Intent.ACTION_VIEW, releaseDetails.releaseNotesUrl)
                    )
                })
            dialogBuilder.show()

        return custom
    }

    override fun onNoReleaseAvailable(activity: Activity) {
        Toast.makeText(
            activity,
            "No updates available",
            Toast.LENGTH_LONG
        ).show()
    }
}