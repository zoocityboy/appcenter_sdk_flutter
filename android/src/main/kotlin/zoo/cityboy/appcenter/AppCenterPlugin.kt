package zoo.cityboy.appcenter


import android.app.Activity
import android.content.Context
import android.content.SharedPreferences
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.WorkerThread
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes
import com.microsoft.appcenter.crashes.WrapperSdkExceptionManager
import com.microsoft.appcenter.distribute.Distribute
import com.microsoft.appcenter.distribute.DistributeListener
import com.microsoft.appcenter.distribute.ReleaseDetails
import com.microsoft.appcenter.distribute.UpdateTrack
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import java.util.Date


/** AppCenterPlugin */
class AppCenterPlugin : FlutterPlugin, ActivityAware, AppCenterApi, AppCenterAnalyticsApi, AppCenterCrashesApi, AppCenterDistributionApi {

    private var events = mutableMapOf<String, Date>()
    private var mainActivity: Activity? = null
    private lateinit var preferences: SharedPreferences
    private lateinit var mEventChannel: EventChannel
    private var mEvents: EventSink? = null
    private var uiThreadHandler: Handler = Handler(Looper.getMainLooper())



    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        binding.applicationContext.getSharedPreferences("AppCenterFlutter", Context.MODE_PRIVATE)
        mEventChannel = EventChannel(binding.binaryMessenger, "zoo.cityboy.appcenter/distribute_events")
        mEventChannel.setStreamHandler (object : StreamHandler {
            override fun onListen(arguments: Any?, es: EventSink) {
                mEvents = es
            }
            override fun onCancel(arguments: Any?) {
                mEvents = null
            }
        })

        events.put("onAttachedToEngine_start", Date())
        AppCenterApi.setUp(binding.binaryMessenger, this)
        AppCenterAnalyticsApi.setUp(binding.binaryMessenger, this)
        AppCenterCrashesApi.setUp(binding.binaryMessenger, this)
        AppCenterDistributionApi.setUp(binding.binaryMessenger, this)
        events.put("onAttachedToEngine_done", Date())
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        AppCenterApi.setUp(binding.binaryMessenger, null)
        AppCenterAnalyticsApi.setUp(binding.binaryMessenger, null)
        AppCenterCrashesApi.setUp(binding.binaryMessenger, null)
        AppCenterDistributionApi.setUp(binding.binaryMessenger, this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        events.put("onAttachedToActivity_start", Date())
        mainActivity = binding.activity
        preferences = binding.activity.getSharedPreferences("AppCenterFlutter", Context.MODE_PRIVATE);
    }

    override fun onDetachedFromActivityForConfigChanges() {
        mainActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        events["onReattachedToActivityForConfigChanges"] = Date()
        mainActivity = binding.activity
        preferences = binding.activity.getSharedPreferences("AppCenterFlutter", Context.MODE_PRIVATE);
    }

    override fun onDetachedFromActivity() {
        mainActivity = null
        mEventChannel.setStreamHandler(null)

    }

    // App Center
    override fun start(secret: String, usePrivateTrack: Boolean, callback: (Result<Unit>) -> Unit) {
        events["AppCenterStart"] = Date()
        mainActivity?.let {
            if (!AppCenter.isConfigured()) {
                if (usePrivateTrack){
                    Distribute.setUpdateTrack(UpdateTrack.PRIVATE);
                }
                Distribute.setListener(object : DistributeListener {


                    override fun onNoReleaseAvailable(activity: Activity?) {
                        uiThreadHandler.post {
                            mEvents?.success("onNoReleaseAvailable")
                        }
                    }

                    override fun onReleaseAvailable(
                        activity: Activity?,
                        releaseDetails: ReleaseDetails?
                    ): Boolean {
                        uiThreadHandler.post {
                            mEvents?.success("onReleaseAvailable")
                        }
                        return releaseDetails != null
                    }
                })
                AppCenter.setLogLevel(Log.VERBOSE)
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

    override fun fibonacci(n: Long, callback: (Result<Long>)-> Unit) {
        println("fibonacci: $n")

        val value = n.toInt()
        val result = fibonacciCalc(value)
        println("fibonacci: done $result")
        callback(Result.success(result.toLong()))

    }
    @WorkerThread
    fun fibonacciCalc(n: Int): Int {
        if (n == 0 || n == 1) {
            return n
        }
        print("fibonacciCalc $n ")

        return fibonacciCalc(n - 1) + fibonacciCalc(n - 2)
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
        exceptionModel.wrapperSdkName = "appcenter.react-native"
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
        Distribute.setEnabledForDebuggableBuild(enabled)
        println("setEnabledForDebuggableBuild: $enabled")

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
        print("checkForUpdate")
        callback(Result.success(Unit))
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
