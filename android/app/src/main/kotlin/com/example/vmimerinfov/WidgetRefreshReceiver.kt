
//(VIV [Widget Refresh Receiver — 2026-10-06])

package com.example.vmimerinfov

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequest
import androidx.work.WorkManager
import dev.fluttercommunity.workmanager.BackgroundWorker
import org.json.JSONObject

class WidgetRefreshReceiver : BroadcastReceiver() {

    override fun onReceive(
        context: Context,
        intent: Intent,
    ) {
        when (intent.action) {

            ACTION_REFRESH_WIDGET -> {
                refreshWidgetInBackground(
                    context = context,
                    intent = intent,
                )
            }

            ACTION_AUTOMATIC_REFRESH_WIDGET -> {
                refreshAllActiveWidgetsInBackground(
                    context = context,
                )
            }

            ACTION_UPDATE_WIDGETS -> {
                VMimerInfoVWidget.updateAllWidgets(
                    context,
                )
            }
        }
    }

    //(VIV [Refresh Widget In Background — 2026-10-06])

    private fun refreshWidgetInBackground(
        context: Context,
        intent: Intent,
    ) {
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

        val widgetWallets =
            JSONObject().apply {
                put(
                    appWidgetId.toString(),
                    walletId,
                )
            }.toString()

        enqueueWidgetRefresh(
            context = context,
            widgetWallets = widgetWallets,
            uniqueWorkName = WIDGET_REFRESH_UNIQUE_NAME,
        )
    }

    //) VIV [Refresh Widget In Background — 2026-10-06]

    //(VIV [Refresh All Active Widgets In Background — 2026-10-08])

    private fun refreshAllActiveWidgetsInBackground(
        context: Context,
    ) {
        val appWidgetManager =
            AppWidgetManager.getInstance(
                context,
            )

        val componentName =
            ComponentName(
                context,
                VMimerInfoVWidget::class.java,
            )

        val appWidgetIds =
            appWidgetManager.getAppWidgetIds(
                componentName,
            )

        if (appWidgetIds.isEmpty()) {
            return
        }

        val widgetConfigStorage =
            WidgetConfigStorage(
                context,
            )

        val widgetWallets =
            JSONObject()

        for (appWidgetId in appWidgetIds) {
            val walletId =
                widgetConfigStorage.loadWalletId(
                    appWidgetId,
                )

            if (!walletId.isNullOrEmpty()) {
                widgetWallets.put(
                    appWidgetId.toString(),
                    walletId,
                )
            }
        }

        if (widgetWallets.length() == 0) {
            return
        }

        enqueueWidgetRefresh(
            context = context,
            widgetWallets = widgetWallets.toString(),
            uniqueWorkName =
                AUTOMATIC_WIDGET_REFRESH_WORK_UNIQUE_NAME,
            existingWorkPolicy = ExistingWorkPolicy.REPLACE,
        )
    }

    //) VIV [Refresh All Active Widgets In Background — 2026-10-08]

    //(VIV [Enqueue Widget Refresh — 2026-10-08])

    private fun enqueueWidgetRefresh(
        context: Context,
        widgetWallets: String,
        uniqueWorkName: String,
        existingWorkPolicy: ExistingWorkPolicy =
            ExistingWorkPolicy.REPLACE,
    ) {
        val inputData =
            Data.Builder()
                .putString(
                    DART_TASK_KEY,
                    WIDGET_REFRESH_TASK_NAME,
                )
                .putString(
                    UNIQUE_NAME_KEY,
                    uniqueWorkName,
                )
                .putString(
                    PAYLOAD_WIDGET_WALLETS_KEY,
                    widgetWallets,
                )
                .build()

        val request =
            OneTimeWorkRequest.Builder(
                BackgroundWorker::class.java,
            )
                .setInputData(
                    inputData,
                )
                .build()

        WorkManager
            .getInstance(context)
            .enqueueUniqueWork(
                uniqueWorkName,
                existingWorkPolicy,
                request,
            )
    }

    //) VIV [Enqueue Widget Refresh — 2026-10-08]

    //(VIV [Widget Refresh Actions — 2026-10-06])

    companion object {

        const val ACTION_REFRESH_WIDGET =
            "com.example.vmimerinfov.REFRESH_WIDGET"

        const val ACTION_AUTOMATIC_REFRESH_WIDGET =
            "com.example.vmimerinfov.AUTOMATIC_REFRESH_WIDGET"

        const val ACTION_UPDATE_WIDGETS =
            "com.example.vmimerinfov.UPDATE_WIDGETS"

        private const val EXTRA_APP_WIDGET_ID =
            "appWidgetId"

        private const val EXTRA_WALLET_ID =
            "walletId"

        private const val WIDGET_REFRESH_TASK_NAME =
            "vmimerinfov_widget_refresh"

        private const val WIDGET_REFRESH_UNIQUE_NAME =
            "vmimerinfov_widget_refresh_task"

        private const val AUTOMATIC_WIDGET_REFRESH_WORK_UNIQUE_NAME =
            "vmimerinfov_widget_refresh_automatic"

        private const val DART_TASK_KEY =
            "dev.fluttercommunity.workmanager.DART_TASK"

        private const val UNIQUE_NAME_KEY =
            "dev.fluttercommunity.workmanager.UNIQUE_NAME"

        private const val PAYLOAD_WIDGET_WALLETS_KEY =
            "payload_widget_wallets"
    }
}

//) VIV [Widget Refresh Receiver — 2026-10-06]
