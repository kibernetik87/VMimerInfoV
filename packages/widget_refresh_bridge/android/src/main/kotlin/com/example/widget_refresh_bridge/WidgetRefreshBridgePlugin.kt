//(VIV [Widget Refresh Bridge Plugin — 2026-10-05])

package com.example.widget_refresh_bridge

import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

//(VIV [Widget Refresh Bridge Plugin Class — 2026-10-05])

class WidgetRefreshBridgePlugin : FlutterPlugin,
    MethodChannel.MethodCallHandler {

    companion object {
        private const val CHANNEL_NAME =
            "com.example.vmimerinfov/widget_refresh_bridge"

        private const val UPDATE_ALL_WIDGETS_METHOD =
            "updateAllWidgets"

        private const val UPDATE_WIDGETS_ACTION =
            "com.example.vmimerinfov.UPDATE_WIDGETS"
    }

    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    //(VIV [Attach Widget Refresh Bridge — 2026-10-05])

    override fun onAttachedToEngine(
        binding: FlutterPlugin.FlutterPluginBinding,
    ) {
        applicationContext =
            binding.applicationContext

        channel =
            MethodChannel(
                binding.binaryMessenger,
                CHANNEL_NAME,
            )

        channel.setMethodCallHandler(this)
    }

    //) VIV [Attach Widget Refresh Bridge — 2026-10-05]

    //(VIV [Handle Widget Refresh Method — 2026-10-05])

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        when (call.method) {
            UPDATE_ALL_WIDGETS_METHOD -> {
                val intent =
                    Intent(
                        UPDATE_WIDGETS_ACTION,
                    ).setPackage(
                        applicationContext.packageName,
                    )

                applicationContext.sendBroadcast(intent)

                result.success(null)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    //) VIV [Handle Widget Refresh Method — 2026-10-05]

    //(VIV [Detach Widget Refresh Bridge — 2026-10-05])

    override fun onDetachedFromEngine(
        binding: FlutterPlugin.FlutterPluginBinding,
    ) {
        channel.setMethodCallHandler(null)
    }

    //) VIV [Detach Widget Refresh Bridge — 2026-10-05]
}

//) VIV [Widget Refresh Bridge Plugin Class — 2026-10-05]

//) VIV [Widget Refresh Bridge Plugin — 2026-10-05]