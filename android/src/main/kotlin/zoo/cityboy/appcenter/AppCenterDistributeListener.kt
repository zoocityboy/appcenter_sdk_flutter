package zoo.cityboy.appcenter

import android.app.Activity
import com.microsoft.appcenter.distribute.DistributeListener
import com.microsoft.appcenter.distribute.ReleaseDetails
import io.flutter.plugin.common.EventChannel.EventSink

class AppCenterDistributeListener(private val eventSink: EventSink) : DistributeListener {

    override fun onReleaseAvailable(activity: Activity, releaseDetails: ReleaseDetails): Boolean {
        eventSink.success("onReleaseAvailable")
        return false
    }

    override fun onNoReleaseAvailable(activity: Activity) {
        eventSink.success("onNoReleaseAvailable")
    }
}