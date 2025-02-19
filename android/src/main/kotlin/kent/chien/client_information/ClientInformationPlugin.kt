package kent.chien.client_information

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import androidx.core.content.pm.PackageInfoCompat
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ClientInformationPlugin */
class ClientInformationPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context : Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "client_information")
        channel.setMethodCallHandler(this)
        this.context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getInformation") {
            val manager: PackageManager = context.packageManager;
            val info: PackageInfo?;

            var applicationId = "unknown_application_id";
            val applicationType = "app";
            var applicationVersion = "unknown_version";
            var applicationBuildCode: Long = 0;
            val applicationName: String = context.applicationInfo.loadLabel(manager).toString();

            val osName = "Android";
            val osVersion: String = Build.VERSION.RELEASE;
            val androidApiLevel: Int = Build.VERSION.SDK_INT;

            var deviceId = getDeviceId();
            var deviceName = Build.MODEL;

            try {
                info = manager.getPackageInfo(context.packageName, 0);
                applicationId = context.getPackageName() ?: "unknown_application_id";
                applicationVersion = info?.versionName ?: "unknown_version";
                applicationBuildCode = if (info == null) {
                    0;
                } else {
                    PackageInfoCompat.getLongVersionCode(info);
                }
            } catch (e: PackageManager.NameNotFoundException) {
                e.printStackTrace();
            }

            val resultInfo = HashMap<String, String>();

            resultInfo["deviceId"] = deviceId;
            resultInfo["deviceName"] = deviceName;
            resultInfo["osName"] = osName;
            resultInfo["osVersion"] = osVersion;
            resultInfo["osVersionCode"] = androidApiLevel.toString();
            resultInfo["softwareName"] = applicationName;
            resultInfo["softwareVersion"] = applicationVersion;
            resultInfo["applicationId"] = applicationId;
            resultInfo["applicationType"] = applicationType;
            resultInfo["applicationName"] = applicationName;
            resultInfo["applicationVersion"] = applicationVersion;
            resultInfo["applicationBuildCode"] = applicationBuildCode.toString();

            result.success(resultInfo);
        } else {
            result.notImplemented()
        }
    }

    private fun getDeviceId() : String {
        return Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
    }
}