//(VIV [Widget Config Activity — 2026-10-08])

package com.example.vmimerinfov

import android.appwidget.AppWidgetManager
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

//(VIV [Widget Config Activity Class — 2026-10-08])

class WidgetConfigActivity : FlutterActivity() {

    companion object {
        private const val WIDGET_CONFIG_ROUTE =
            "/widget-config"

        private const val WIDGET_ID_ARGUMENT =
            "appWidgetId"

        //(VIV [Widget Config Channel — 2026-10-05])

        private const val CONFIG_CHANNEL =
            "com.example.vmimerinfov/widget_config"

        //) VIV [Widget Config Channel — 2026-10-05]

        //(VIV [Save Widget Configuration Method — 2026-10-05])

        private const val SAVE_CONFIGURATION_METHOD =
            "saveWidgetConfiguration"

        //) VIV [Save Widget Configuration Method — 2026-10-05]

        //(VIV [Finish Widget Configuration Method — 2026-10-05])

        private const val FINISH_WIDGET_CONFIGURATION_METHOD =
            "finishWidgetConfiguration"

        //) VIV [Finish Widget Configuration Method — 2026-10-05]

        //(VIV [Load All Widget Wallets Method — 2026-10-05])

        private const val LOAD_ALL_WIDGET_WALLETS_METHOD =
            "loadAllWidgetWallets"

        //) VIV [Load All Widget Wallets Method — 2026-10-05]
    }

    //(VIV [Widget Config Initial Route — 2026-10-05])

    override fun getInitialRoute(): String {
        val appWidgetId =
            intent?.getIntExtra(
                AppWidgetManager.EXTRA_APPWIDGET_ID,
                AppWidgetManager.INVALID_APPWIDGET_ID,
            )
                ?: AppWidgetManager.INVALID_APPWIDGET_ID

        return "$WIDGET_CONFIG_ROUTE?${WIDGET_ID_ARGUMENT}=$appWidgetId"
    }

    //) VIV [Widget Config Initial Route — 2026-10-05]

    //(VIV [Widget Config Flutter Channel — 2026-10-08])

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine,
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CONFIG_CHANNEL,
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                //(VIV [Save Widget Configuration — 2026-10-08])

                SAVE_CONFIGURATION_METHOD -> {
                    val walletId =
                        call.argument<String>("walletId")

                    val walletName =
                        call.argument<String>("walletName")

                    if (walletId.isNullOrBlank()) {
                        result.error(
                            "INVALID_WALLET",
                            "Wallet ID is missing.",
                            null,
                        )
                        return@setMethodCallHandler
                    }

                    if (walletName.isNullOrBlank()) {
                        result.error(
                            "INVALID_WALLET_NAME",
                            "Wallet name is missing.",
                            null,
                        )
                        return@setMethodCallHandler
                    }

                    val appWidgetId =
                        intent?.getIntExtra(
                            AppWidgetManager.EXTRA_APPWIDGET_ID,
                            AppWidgetManager.INVALID_APPWIDGET_ID,
                        )
                            ?: AppWidgetManager.INVALID_APPWIDGET_ID

                    if (
                        appWidgetId ==
                        AppWidgetManager.INVALID_APPWIDGET_ID
                    ) {
                        setResult(RESULT_CANCELED)

                        result.error(
                            "INVALID_WIDGET_ID",
                            "App widget ID is invalid.",
                            null,
                        )

                        finish()

                        return@setMethodCallHandler
                    }

                    //(VIV [Save Selected Widget Wallet Configuration — 2026-10-08])

                    WidgetConfigStorage(
                        this,
                    ).saveWalletConfiguration(
                        appWidgetId = appWidgetId,
                        walletId = walletId,
                        walletName = walletName,
                    )

                    //) VIV [Save Selected Widget Wallet Configuration — 2026-10-08]

                    //(VIV [Prepare Widget Configuration Result — 2026-10-05])

                    val resultIntent =
                        Intent().apply {
                            putExtra(
                                AppWidgetManager.EXTRA_APPWIDGET_ID,
                                appWidgetId,
                            )
                        }

                    setResult(
                        RESULT_OK,
                        resultIntent,
                    )

                    result.success(null)

                    //) VIV [Prepare Widget Configuration Result — 2026-10-05]
                }

                //(VIV [Finish Widget Configuration — 2026-10-05])

                FINISH_WIDGET_CONFIGURATION_METHOD -> {
                    finish()
                    result.success(null)
                }

                //) VIV [Finish Widget Configuration — 2026-10-05]

                //(VIV [Load All Widget Wallets — 2026-10-05])

                LOAD_ALL_WIDGET_WALLETS_METHOD -> {
                    val widgetWallets =
                        WidgetConfigStorage(
                            this,
                        ).loadAllWalletIds()

                    result.success(
                        widgetWallets.mapKeys { (appWidgetId, _) ->
                            appWidgetId.toString()
                        },
                    )
                }

                //) VIV [Load All Widget Wallets — 2026-10-05]

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    //) VIV [Widget Config Flutter Channel — 2026-10-08]
}

//) VIV [Widget Config Activity Class — 2026-10-08]

//) VIV [Widget Config Activity — 2026-10-08]