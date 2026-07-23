package com.ouroprep.app

import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.nexora.ouroprep/permissions"
    private val PERMISSION_REQ_CODE = 1001

    private val permissionMap = mapOf(
        "android.permission.READ_EXTERNAL_STORAGE" to Manifest.permission.READ_EXTERNAL_STORAGE,
        "android.permission.RECORD_AUDIO" to Manifest.permission.RECORD_AUDIO,
        "android.permission.ACCESS_FINE_LOCATION" to Manifest.permission.ACCESS_FINE_LOCATION,
        "android.permission.CAMERA" to Manifest.permission.CAMERA,
        "android.permission.POST_NOTIFICATIONS" to Manifest.permission.POST_NOTIFICATIONS,
        "android.permission.NEARBY_WIFI_DEVICES" to Manifest.permission.NEARBY_WIFI_DEVICES,
        "android.permission.BLUETOOTH_CONNECT" to Manifest.permission.BLUETOOTH_CONNECT,
        "android.permission.READ_PHONE_STATE" to Manifest.permission.READ_PHONE_STATE,
    )

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkPermission" -> {
                    val permName = call.arguments as? String ?: ""
                    val androidPerm = permissionMap[permName]
                    val status = if (androidPerm != null) {
                        checkPermission(androidPerm)
                    } else {
                        "granted"
                    }
                    result.success(status)
                }
                "requestPermission" -> {
                    val permName = call.arguments as? String ?: ""
                    val androidPerm = permissionMap[permName]
                    if (androidPerm != null) {
                        pendingPermissionResult = result
                        requestPermission(androidPerm)
                    } else {
                        result.success("granted")
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private var pendingPermissionResult: MethodChannel.Result? = null
    private var pendingPermissionName: String? = null

    private fun checkPermission(perm: String): String {
        return when {
            ContextCompat.checkSelfPermission(this, perm) == PackageManager.PERMISSION_GRANTED -> "granted"
            ActivityCompat.shouldShowRequestPermissionRationale(this, perm) -> "denied_show_rationale"
            else -> "denied_never_ask"
        }
    }

    private fun requestPermission(perm: String) {
        pendingPermissionName = perm
        ActivityCompat.requestPermissions(this, arrayOf(perm), PERMISSION_REQ_CODE)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQ_CODE) {
            val result = pendingPermissionResult
            val permName = pendingPermissionName
            if (result != null && permName != null) {
                val denied = grantResults.isEmpty() || grantResults[0] != PackageManager.PERMISSION_GRANTED
                val status = if (!denied) {
                    "granted"
                } else if (ActivityCompat.shouldShowRequestPermissionRationale(this, permName)) {
                    "denied_show_rationale"
                } else {
                    "denied_never_ask"
                }
                result.success(status)
            }
            pendingPermissionResult = null
            pendingPermissionName = null
        }
    }
}
