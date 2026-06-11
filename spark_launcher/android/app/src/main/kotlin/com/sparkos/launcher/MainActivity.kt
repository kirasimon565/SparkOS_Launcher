package com.sparkos.launcher

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.provider.Settings

class MainActivity: FlutterActivity() {
    private val DEVICE_CHANNEL = "com.sparkos.launcher/device"
    private val LAUNCHER_CHANNEL = "com.sparkos.launcher/bridge"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICE_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getDeviceProfileLevel") {
                result.success(getDeviceProfileLevel())
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LAUNCHER_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "triggerHomePicker") {
                try {
                    val intent = Intent(Settings.ACTION_HOME_SETTINGS)
                    startActivity(intent)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("UNAVAILABLE", "Home settings unavailable.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getDeviceProfileLevel(): String {
        val actManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memInfo = ActivityManager.MemoryInfo()
        actManager.getMemoryInfo(memInfo)

        val totalMemoryGB = memInfo.totalMem / (1024 * 1024 * 1024).toDouble()
        val isLowRamDevice = actManager.isLowRamDevice

        // Complex logic mapping to LEVEL_LOW, LEVEL_STANDARD, LEVEL_HIGH
        if (isLowRamDevice || totalMemoryGB < 3.5) {
            return "LEVEL_LOW"
        } else if (totalMemoryGB < 6.5) {
            return "LEVEL_STANDARD"
        } else {
            return "LEVEL_HIGH"
        }
    }
}
