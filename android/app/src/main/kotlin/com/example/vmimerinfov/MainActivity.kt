//(VIV [VMimerInfoV Main Activity — 2026-10-06])

package com.example.vmimerinfov

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

//(VIV [VMimerInfoV Main Activity Class — 2026-10-06])
class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL =
            "com.example.vmimerinfov/widget"

        private const val PREFS_NAME =
            "vmimerinfov_widget"

        private const val KEY_HASHRATE =
            "hashRate"

        private const val KEY_HASHRATE2 =
            "hashRate2"

        private const val KEY_WORKERS_ONLINE =
            "workersOnline"

        private const val KEY_WORKERS_TOTAL =
            "workersTotal"

        private const val KEY_AMOUNT_PAID =
            "amountPaid"

        private const val KEY_AMOUNT_DUE =
            "amountDue"

        private const val KEY_UPDATED_AT =
            "updatedAt"

        //(VIV [Load All Widget Wallets Method — 2026-10-05])
        private const val LOAD_ALL_WIDGET_WALLETS_METHOD =
            "loadAllWidgetWallets"
        //) VIV [Load All Widget Wallets Method — 2026-10-05]

        //(VIV [Widget Refresh Intent — 2026-10-06])
        private const val ACTION_REFRESH_WIDGET =
            "com.example.vmimerinfov.REFRESH_WIDGET"

        private const val EXTRA_APP_WIDGET_ID =
            "appWidgetId"

        private const val EXTRA_WALLET_ID =
            "walletId"
        //) VIV [Widget Refresh Intent — 2026-10-06]

        //(VIV [Widget Refresh Methods — 2026-10-06])
        private const val GET_PENDING_WIDGET_REFRESH_METHOD =
            "getPendingWidgetRefresh"

        private const val FINISH_WIDGET_REFRESH_METHOD =
            "finishWidgetRefresh"
        //) VIV [Widget Refresh Methods — 2026-10-06]

        //(VIV [Automatic Widget Refresh Methods — 2026-10-08])
        private const val SCHEDULE_AUTOMATIC_WIDGET_REFRESH_METHOD =
            "scheduleAutomaticWidgetRefresh"

        private const val CANCEL_AUTOMATIC_WIDGET_REFRESH_METHOD =
            "cancelAutomaticWidgetRefresh"
        //) VIV [Automatic Widget Refresh Methods — 2026-10-08]
    }

    //(VIV [Pending Widget Refresh — 2026-10-06])
    private var pendingWidgetRefresh:
            Map<String, Any?>? = null
    //) VIV [Pending Widget Refresh — 2026-10-06]

    //(VIV [Widget Refresh Method Channel — 2026-10-06])
    private var widgetMethodChannel:
            MethodChannel? = null
    //) VIV [Widget Refresh Method Channel — 2026-10-06]

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine,
    ) {
        super.configureFlutterEngine(flutterEngine)

        //(VIV [Capture Widget Refresh Intent — 2026-10-06])
        captureWidgetRefreshIntent(intent)
        //) VIV [Capture Widget Refresh Intent — 2026-10-06]

        val preferences = getSharedPreferences(
            PREFS_NAME,
            Context.MODE_PRIVATE,
        )

        //(VIV [Widget Refresh Method Channel Initialization — 2026-10-06])
        widgetMethodChannel =
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL,
            )

        widgetMethodChannel?.setMethodCallHandler { call, result ->

            when (call.method) {

                "updateWidgetData" -> {
                    val hashRate =
                        call.argument<Double>(KEY_HASHRATE)

                    val hashRate2 =
                        call.argument<Double>(KEY_HASHRATE2)

                    val workersOnline =
                        call.argument<Int>(KEY_WORKERS_ONLINE)

                    val workersTotal =
                        call.argument<Int>(KEY_WORKERS_TOTAL)

                    val amountPaid =
                        call.argument<Double>(KEY_AMOUNT_PAID)

                    val amountDue =
                        call.argument<Double>(KEY_AMOUNT_DUE)

                    val updatedAt =
                        call.argument<Long>(KEY_UPDATED_AT)

                    if (
                        hashRate == null ||
                        hashRate2 == null ||
                        workersOnline == null ||
                        workersTotal == null ||
                        amountPaid == null ||
                        amountDue == null ||
                        updatedAt == null
                    ) {
                        result.error(
                            "INVALID_DATA",
                            "Widget data is incomplete.",
                            null,
                        )
                        return@setMethodCallHandler
                    }

                    saveWidgetData(
                        preferences = preferences,
                        hashRate = hashRate,
                        hashRate2 = hashRate2,
                        workersOnline = workersOnline,
                        workersTotal = workersTotal,
                        amountPaid = amountPaid,
                        amountDue = amountDue,
                        updatedAt = updatedAt,
                    )

                    VMimerInfoVWidget.updateAllWidgets(
                        this,
                    )

                    result.success(null)
                }

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

                //(VIV [Get Pending Widget Refresh — 2026-10-06])
                GET_PENDING_WIDGET_REFRESH_METHOD -> {
                    val refresh =
                        pendingWidgetRefresh

                    pendingWidgetRefresh = null

                    result.success(refresh)
                }
                //) VIV [Get Pending Widget Refresh — 2026-10-06]

                //(VIV [Finish Widget Refresh — 2026-10-06])
                FINISH_WIDGET_REFRESH_METHOD -> {
                    finishAndRemoveTask()

                    result.success(null)
                }
                //) VIV [Finish Widget Refresh — 2026-10-06]

//(VIV [Schedule Automatic Widget Refresh Method — 2026-10-08])
                SCHEDULE_AUTOMATIC_WIDGET_REFRESH_METHOD -> {
                    val intervalMs =
                        (call.argument<Number>("intervalMs"))
                            ?.toLong()

                    if (intervalMs == null || intervalMs <= 0L) {
                        result.error(
                            "INVALID_INTERVAL",
                            "Invalid automatic widget refresh interval.",
                            null,
                        )
                        return@setMethodCallHandler
                    }

                    AutomaticWidgetRefreshScheduler.schedule(
                        context = this,
                        intervalMs = intervalMs,
                    )

                    result.success(null)
                }
//) VIV [Schedule Automatic Widget Refresh Method — 2026-10-08]

                //(VIV [Cancel Automatic Widget Refresh — 2026-10-08])
                CANCEL_AUTOMATIC_WIDGET_REFRESH_METHOD -> {
                    AutomaticWidgetRefreshScheduler.cancel(
                        context = this,
                    )

                    result.success(null)
                }
                //) VIV [Cancel Automatic Widget Refresh — 2026-10-08]

                else -> {
                    result.notImplemented()
                }
            }
        }

        //) VIV [Widget Refresh Method Channel Initialization — 2026-10-06]

        //(VIV [Deliver Pending Widget Refresh — 2026-10-06])
        pendingWidgetRefresh?.let { refresh ->

            widgetMethodChannel?.invokeMethod(
                "widgetRefreshRequested",
                mapOf(
                    EXTRA_WALLET_ID to
                            refresh[EXTRA_WALLET_ID],
                ),
            )

            pendingWidgetRefresh = null
        }
        //) VIV [Deliver Pending Widget Refresh — 2026-10-06]
    }

    //(VIV [Capture Widget Refresh Intent — 2026-10-06])
    private fun captureWidgetRefreshIntent(
        intent: Intent?,
    ) {
        if (
            intent?.action != ACTION_REFRESH_WIDGET
        ) {
            return
        }

        val appWidgetId =
            intent.getIntExtra(
                EXTRA_APP_WIDGET_ID,
                AppWidgetManager.INVALID_APPWIDGET_ID,
            )

        val walletId =
            intent.getStringExtra(
                EXTRA_WALLET_ID,
            )

        if (
            appWidgetId ==
            AppWidgetManager.INVALID_APPWIDGET_ID ||
            walletId.isNullOrEmpty()
        ) {
            return
        }

        pendingWidgetRefresh =
            mapOf(
                EXTRA_APP_WIDGET_ID to appWidgetId,
                EXTRA_WALLET_ID to walletId,
            )
    }
    //) VIV [Capture Widget Refresh Intent — 2026-10-06]

    //(VIV [Receive Widget Refresh Intent — 2026-10-06])
    override fun onNewIntent(
        intent: Intent,
    ) {
        super.onNewIntent(intent)

        setIntent(intent)

        captureWidgetRefreshIntent(intent)

        val walletId =
            intent.getStringExtra(
                EXTRA_WALLET_ID,
            )

        if (
            intent.action == ACTION_REFRESH_WIDGET &&
            !walletId.isNullOrEmpty()
        ) {
            widgetMethodChannel?.invokeMethod(
                "widgetRefreshRequested",
                mapOf(
                    EXTRA_WALLET_ID to walletId,
                ),
            )
        }
    }
    //) VIV [Receive Widget Refresh Intent — 2026-10-06]

    //(VIV [Save Widget Data — 2026-10-04])
    private fun saveWidgetData(
        preferences: SharedPreferences,
        hashRate: Double,
        hashRate2: Double,
        workersOnline: Int,
        workersTotal: Int,
        amountPaid: Double,
        amountDue: Double,
        updatedAt: Long,
    ) {
        preferences.edit()
            .putString(
                KEY_HASHRATE,
                hashRate.toString(),
            )
            .putString(
                KEY_HASHRATE2,
                hashRate2.toString(),
            )
            .putInt(
                KEY_WORKERS_ONLINE,
                workersOnline,
            )
            .putInt(
                KEY_WORKERS_TOTAL,
                workersTotal,
            )
            .putString(
                KEY_AMOUNT_PAID,
                amountPaid.toString(),
            )
            .putString(
                KEY_AMOUNT_DUE,
                amountDue.toString(),
            )
            .putLong(
                KEY_UPDATED_AT,
                updatedAt,
            )
            .apply()
    }
}
//) VIV [VMimerInfoV Main Activity Class — 2026-10-06]

//) VIV [VMimerInfoV Main Activity — 2026-10-06]