//(VIV [Automatic Widget Refresh Worker — 2026-10-08])

package com.example.vmimerinfov

import android.content.Context
import android.content.Intent
import androidx.work.Worker
import androidx.work.WorkerParameters

//(VIV [Automatic Widget Refresh Worker Class — 2026-10-08])

class AutomaticWidgetRefreshWorker(
    appContext: Context,
    workerParams: WorkerParameters,
) : Worker(
    appContext,
    workerParams,
) {

    //(VIV [Do Automatic Widget Refresh — 2026-10-08])

    override fun doWork(): Result {

        val context =
            applicationContext

        val intervalMs =
            inputData.getLong(
                AutomaticWidgetRefreshScheduler.INTERVAL_MS_KEY,
                -1L,
            )

        if (intervalMs <= 0L) {
            return Result.failure()
        }

        //(VIV [Request Automatic Widget Refresh — 2026-10-08])

        val refreshIntent =
            Intent(
                context,
                WidgetRefreshReceiver::class.java,
            ).apply {
                action =
                    WidgetRefreshReceiver
                        .ACTION_AUTOMATIC_REFRESH_WIDGET
            }

        context.sendBroadcast(
            refreshIntent,
        )

        //) VIV [Request Automatic Widget Refresh — 2026-10-08]

        //(VIV [Schedule Next Automatic Widget Refresh — 2026-10-08])

        AutomaticWidgetRefreshScheduler.schedule(
            context = context,
            intervalMs = intervalMs,
            append = true,
        )

        //) VIV [Schedule Next Automatic Widget Refresh — 2026-10-08]

        return Result.success()
    }

    //) VIV [Do Automatic Widget Refresh — 2026-10-08]
}

//) VIV [Automatic Widget Refresh Worker Class — 2026-10-08]

//) VIV [Automatic Widget Refresh Worker — 2026-10-08]