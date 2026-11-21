//(VIV [VMimerInfoV Widget — 2026-10-06])

package com.example.vmimerinfov

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import android.widget.RemoteViews
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

//(VIV [VMimerInfoV Widget Provider — 2026-10-06])
class VMimerInfoVWidget : AppWidgetProvider() {

    companion object {

        //(VIV [Flutter Shared Preferences — 2026-10-06])
        private const val PREFS_NAME =
            "FlutterSharedPreferences"

        private const val KEY_PREFIX =
            "flutter.wallet_mining_snapshot_"
        //) VIV [Flutter Shared Preferences — 2026-10-06]

        //(VIV [Widget Refresh Intent — 2026-10-06])
        private const val ACTION_REFRESH_WIDGET =
            "com.example.vmimerinfov.REFRESH_WIDGET"

        private const val EXTRA_APP_WIDGET_ID =
            "appWidgetId"

        private const val EXTRA_WALLET_ID =
            "walletId"
        //) VIV [Widget Refresh Intent — 2026-10-06]

        //(VIV [Widget Cache Fields — 2026-10-06])
        private const val FIELD_HASHRATE =
            "_hashRate"

        private const val FIELD_HASHRATE2 =
            "_hashRate2"

        private const val FIELD_WORKERS_ONLINE =
            "_workersOnline"

        private const val FIELD_WORKERS_TOTAL =
            "_workersTotal"

        private const val FIELD_AMOUNT_PAID =
            "_amountPaid"

        private const val FIELD_AMOUNT_DUE =
            "_amountDue"

        private const val FIELD_UPDATED_AT =
            "_updatedAt"
        //) VIV [Widget Cache Fields — 2026-10-06]

        //(VIV [Update All Widgets — 2026-10-06])
        fun updateAllWidgets(
            context: Context,
        ) {
            val appWidgetManager =
                AppWidgetManager.getInstance(context)

            val componentName =
                android.content.ComponentName(
                    context,
                    VMimerInfoVWidget::class.java,
                )

            val appWidgetIds =
                appWidgetManager.getAppWidgetIds(
                    componentName,
                )

            for (appWidgetId in appWidgetIds) {
                updateWidget(
                    context = context,
                    appWidgetManager = appWidgetManager,
                    appWidgetId = appWidgetId,
                )
            }
        }
        //) VIV [Update All Widgets — 2026-10-06]

        //(VIV [Widget Update — 2026-10-06])
        private fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
        ) {
            val views =
                RemoteViews(
                    context.packageName,
                    R.layout.widget_vmimer_info,
                )

            val widgetConfigStorage =
                WidgetConfigStorage(context)

            val walletId =
                widgetConfigStorage.loadWalletId(
                    appWidgetId,
                )
            //(VIV [Read Widget Wallet Name — 2026-10-08])
            val walletName =
                widgetConfigStorage.loadWalletName(
                    appWidgetId,
                ) ?: "--"
            //) VIV [Read Widget Wallet Name — 2026-10-08]
            val preferences =
                context.getSharedPreferences(
                    PREFS_NAME,
                    Context.MODE_PRIVATE,
                )

            //(VIV [Read Hashrate Double — 2026-10-06])
            val hashRate =
                walletId?.let {
                    preferences.getFlutterDouble(
                        buildKey(
                            walletId = it,
                            field = FIELD_HASHRATE,
                        ),
                    )
                }
            //) VIV [Read Hashrate Double — 2026-10-06]

            //(VIV [Read Hashrate 2 Double — 2026-10-06])
            val hashRate2 =
                walletId?.let {
                    preferences.getFlutterDouble(
                        buildKey(
                            walletId = it,
                            field = FIELD_HASHRATE2,
                        ),
                    )
                }
            //) VIV [Read Hashrate 2 Double — 2026-10-06]

            val workersOnline =
                walletId?.let {
                    preferences.get(
                        buildKey(
                            walletId = it,
                            field = FIELD_WORKERS_ONLINE,
                        ),
                    )?.toIntOrNull()
                } ?: 0

            val workersTotal =
                walletId?.let {
                    preferences.get(
                        buildKey(
                            walletId = it,
                            field = FIELD_WORKERS_TOTAL,
                        ),
                    )?.toIntOrNull()
                } ?: 0

            //(VIV [Read Amount Paid Double — 2026-10-06])
            val amountPaid =
                walletId?.let {
                    preferences.getFlutterDouble(
                        buildKey(
                            walletId = it,
                            field = FIELD_AMOUNT_PAID,
                        ),
                    )?.toString()
                }
            //) VIV [Read Amount Paid Double — 2026-10-06]

            //(VIV [Read Amount Due Double — 2026-10-06])
            val amountDue =
                walletId?.let {
                    preferences.getFlutterDouble(
                        buildKey(
                            walletId = it,
                            field = FIELD_AMOUNT_DUE,
                        ),
                    )?.toString()
                }
            //) VIV [Read Amount Due Double — 2026-10-06]

            val updatedAt =
                walletId?.let {
                    preferences.get(
                        buildKey(
                            walletId = it,
                            field = FIELD_UPDATED_AT,
                        ),
                    )?.toLongOrNull()
                } ?: 0L
            //(VIV [Widget Wallet Name Value — 2026-10-08])
            views.setTextViewText(
                R.id.widget_wallet_name,
                walletName,
            )
            //) VIV [Widget Wallet Name Value — 2026-10-08]
            //(VIV [Widget Hashrate Value — 2026-10-06])
            views.setTextViewText(
                R.id.widget_hashrate_value,
                hashRate?.let {
                    formatHashrate(it)
                } ?: "--",
            )
            //) VIV [Widget Hashrate Value — 2026-10-06]

            //(VIV [Widget Hashrate 2 Value — 2026-10-06])
            views.setTextViewText(
                R.id.widget_hashrate2_value,
                hashRate2?.let {
                    formatHashrate(it)
                } ?: "--",
            )
            //) VIV [Widget Hashrate 2 Value — 2026-10-06]

            //(VIV [Widget Miners Value — 2026-10-06])
            views.setTextViewText(
                R.id.widget_miners_value,
                "$workersOnline / $workersTotal online",
            )
            //) VIV [Widget Miners Value — 2026-10-06]

            //(VIV [Widget Paid Value — 2026-10-06])
            views.setTextViewText(
                R.id.widget_paid_value,
                amountPaid?.let {
                    "$it XMR"
                } ?: "--",
            )
            //) VIV [Widget Paid Value — 2026-10-06]

            //(VIV [Widget Due Value — 2026-10-06])
            views.setTextViewText(
                R.id.widget_due_value,
                amountDue?.let {
                    "$it XMR"
                } ?: "--",
            )
            //) VIV [Widget Due Value — 2026-10-06]

            //(VIV [Widget Updated Value — 2026-10-06])
            views.setTextViewText(
                R.id.widget_updated_value,
                formatUpdatedAt(updatedAt),
            )
            //) VIV [Widget Updated Value — 2026-10-06]

            //(VIV [Widget Open App Action — 2026-10-06])
            val launchIntent =
                Intent(
                    context,
                    MainActivity::class.java,
                ).apply {
                    flags =
                        Intent.FLAG_ACTIVITY_NEW_TASK or
                                Intent.FLAG_ACTIVITY_CLEAR_TOP
                }

            val pendingIntent =
                PendingIntent.getActivity(
                    context,
                    appWidgetId,
                    launchIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or
                            PendingIntent.FLAG_IMMUTABLE,
                )
            //(VIV [Widget Open App Action — 2026-10-08])
            views.setOnClickPendingIntent(
                R.id.widget_open_app_button,
                pendingIntent,
            )
            //) VIV [Widget Open App Action — 2026-10-08]
            /*
             * The widget root click is intentionally disabled
             * for now so that the refresh button receives
             * its own click event without interference.
             */
            // views.setOnClickPendingIntent(
            //     R.id.widget_root,
            //     pendingIntent,
            // )
            //) VIV [Widget Open App Action — 2026-10-06]

            //(VIV [Widget Refresh Action — 2026-10-06])
            val refreshIntent =
                Intent(
                    context,
                    WidgetRefreshReceiver::class.java,
                ).apply {
                    action = WidgetRefreshReceiver.ACTION_REFRESH_WIDGET

                    putExtra(
                        EXTRA_APP_WIDGET_ID,
                        appWidgetId,
                    )

                    putExtra(
                        EXTRA_WALLET_ID,
                        walletId,
                    )
                }

            val refreshPendingIntent =
                PendingIntent.getBroadcast(
                    context,
                    appWidgetId,
                    refreshIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or
                            PendingIntent.FLAG_IMMUTABLE,
                )

            views.setOnClickPendingIntent(
                R.id.widget_refresh_button,
                refreshPendingIntent,
            )
            //(VIV [Widget Update Diagnostic — 2026-10-07])
            if (BuildConfig.DEBUG) {
                Log.d(
                    "VMimerInfoVWidget",
                    "UPDATE appWidgetId=$appWidgetId | " +
                            "walletId=$walletId | " +
                            "hashRate=$hashRate | " +
                            "hashRate2=$hashRate2 | " +
                            "workers=$workersOnline/$workersTotal | " +
                            "updatedAt=$updatedAt",
                )
            }
            //) VIV [Widget Update Diagnostic — 2026-10-07])

            //(VIV [Widget Update To Launcher — 2026-10-08])
            appWidgetManager.updateAppWidget(
                appWidgetId,
                views,
            )
            //) VIV [Widget Update To Launcher — 2026-10-08]
            //(VIV [Widget Update Applied Diagnostic — 2026-10-07])
            if (BuildConfig.DEBUG) {
                Log.d(
                    "VMimerInfoVWidget",
                    "APPLIED appWidgetId=$appWidgetId | " +
                            "walletId=$walletId | " +
                            "updatedAt=$updatedAt",
                )
            }
//) VIV [Widget Update Applied Diagnostic — 2026-10-07])
        }
        //) VIV [Widget Update — 2026-10-06]

        //(VIV [Build Widget Cache Key — 2026-10-06])
        private fun buildKey(
            walletId: String,
            field: String,
        ): String {
            return "$KEY_PREFIX${walletId}${field}"
        }
        //) VIV [Build Widget Cache Key — 2026-10-06]

        //(VIV [Read Flutter Preference Diagnostic — 2026-10-06])
        private fun SharedPreferences.get(
            key: String,
        ): String? {
            val value =
                all[key]
            if (BuildConfig.DEBUG) {
                Log.d(
                    "VMimerInfoVWidget",
                    "PREF key=$key | " +
                            "type=${value?.javaClass?.name} | " +
                            "value=$value",
                )
            }
            return when (value) {
                is String -> value
                is Number -> value.toString()
                else -> null
            }
        }
        //) VIV [Read Flutter Preference Diagnostic — 2026-10-06]

        //(VIV [Read Flutter Double Preference — 2026-10-06])
        private fun SharedPreferences.getFlutterDouble(
            key: String,
        ): Double? {
            val value = all[key]
            if (BuildConfig.DEBUG) {
                Log.d(
                    "VMimerInfoVWidget",
                    "DOUBLE key=$key | " +
                            "type=${value?.javaClass?.name} | " +
                            "value=$value",
                )
            }
            return when (value) {
                is Number -> value.toDouble()
                is String -> {
                    val prefix =
                        "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBEb3VibGUu"

                    if (!value.startsWith(prefix)) {
                        value.toDoubleOrNull()
                    } else {
                        value
                            .removePrefix(prefix)
                            .toDoubleOrNull()
                    }
                }

                else -> null
            }
        }
        //) VIV [Read Flutter Double Preference — 2026-10-06]

        //(VIV [Widget Hashrate Formatting — 2026-10-06])
        private fun formatHashrate(
            hashRate: Double?,
        ): String {
            if (
                hashRate == null ||
                hashRate < 0
            ) {
                return "--"
            }

            return when {
                hashRate >= 1_000_000_000_000 -> {
                    "${formatHashrateValue(
                        hashRate / 1_000_000_000_000,
                    )} TH/s"
                }

                hashRate >= 1_000_000_000 -> {
                    "${formatHashrateValue(
                        hashRate / 1_000_000_000,
                    )} GH/s"
                }

                hashRate >= 1_000_000 -> {
                    "${formatHashrateValue(
                        hashRate / 1_000_000,
                    )} MH/s"
                }

                hashRate >= 1_000 -> {
                    "${formatHashrateValue(
                        hashRate / 1_000,
                    )} KH/s"
                }

                else -> {
                    "${formatHashrateValue(
                        hashRate,
                    )} H/s"
                }
            }
        }
        //) VIV [Widget Hashrate Formatting — 2026-10-06]

        //(VIV [Widget Hashrate Number Formatting — 2026-10-06])
        private fun formatHashrateValue(
            value: Double,
        ): String {
            return if (value % 1.0 == 0.0) {
                String.format(
                    Locale.US,
                    "%.0f",
                    value,
                )
            } else {
                String.format(
                    Locale.US,
                    "%.2f",
                    value,
                )
                    .trimEnd('0')
                    .trimEnd('.')
            }
        }
        //) VIV [Widget Hashrate Number Formatting — 2026-10-06]

        //(VIV [Widget Updated Time Formatting — 2026-10-06])
        private fun formatUpdatedAt(
            updatedAt: Long,
        ): String {
            if (updatedAt <= 0L) {
                return "Оновлено: --"
            }

            val formatter =
                SimpleDateFormat(
                    "HH:mm",
                    Locale.getDefault(),
                )

            return "Оновлено: ${
                formatter.format(
                    Date(updatedAt),
                )
            }"
        }
        //) VIV [Widget Updated Time Formatting — 2026-10-06]
    }

    //(VIV [Widget On Enabled — 2026-10-06])
    override fun onEnabled(
        context: Context,
    ) {
        super.onEnabled(context)
    }
    //) VIV [Widget On Enabled — 2026-10-06]

    //(VIV [Widget On Update — 2026-10-06])
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(
                context = context,
                appWidgetManager = appWidgetManager,
                appWidgetId = appWidgetId,
            )
        }
    }
    //) VIV [Widget On Update — 2026-10-06]

    //(VIV [Widget On Deleted — 2026-10-06])
    override fun onDeleted(
        context: Context,
        appWidgetIds: IntArray,
    ) {
        super.onDeleted(
            context,
            appWidgetIds,
        )

        val storage =
            WidgetConfigStorage(context)

        for (appWidgetId in appWidgetIds) {
            storage.removeWalletId(
                appWidgetId,
            )
        }
    }
    //) VIV [Widget On Deleted — 2026-10-06]

    //(VIV [Widget On Disabled — 2026-10-06])
    override fun onDisabled(
        context: Context,
    ) {
        super.onDisabled(context)

        val storage =
            WidgetConfigStorage(context)

        val widgetWallets =
            storage.loadAllWalletIds()

        for (appWidgetId in widgetWallets.keys) {
            storage.removeWalletId(
                appWidgetId,
            )
        }
    }
    //) VIV [Widget On Disabled — 2026-10-06]
}

//) VIV [VMimerInfoV Widget Provider — 2026-10-06]

//) VIV [VMimerInfoV Widget — 2026-10-06]