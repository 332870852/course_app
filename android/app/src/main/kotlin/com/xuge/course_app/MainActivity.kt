package com.xuge.course_app

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  //通讯名称,回到手机桌面
  private val CHANNEL = "android/back/desktop"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { methodCall, result ->
      if (methodCall.method == "backDesktop") {
        result.success(true)
        moveTaskToBack(false)
      }
    }
  }
}
