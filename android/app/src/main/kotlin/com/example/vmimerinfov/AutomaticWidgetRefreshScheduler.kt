//(VIV [Automatic Widget Refresh Scheduler — 2026-10-08])

package com.example.vmimerinfov

import android.content.Context
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequest
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit

//(VIV [Automatic Widget Refresh Scheduler Class — 2026-10-08])

object AutomaticWidgetRefreshScheduler {

    private const val UNIQUE_WORK_NAME =
        "vmimerinfov_automatic_widget_refresh"

    const val INTERVAL_MS_KEY =
        "automatic_interval_ms"

    //(VIV [Schedule Automatic Widget Refresh — 2026-10-08])

    fun schedule(
        context: Context,
        intervalMs: Long,
        append: Boolean = false,
    ) {
        if (intervalMs <= 0L) {
            return
        }

        val inputData =
            Data.Builder()
                .putLong(
                    INTERVAL_MS_KEY,
                    intervalMs,
                )
                .build()

        val request =
            OneTimeWorkRequest.Builder(
                AutomaticWidgetRefreshWorker::class.java,
            )
                .setInitialDelay(
                    intervalMs,
                    TimeUnit.MILLISECONDS,
                )
                .setInputData(
                    inputData,
                )
                .build()

        val existingWorkPolicy =
            if (append) {
                ExistingWorkPolicy.APPEND
            } else {
                ExistingWorkPolicy.REPLACE
            }

        WorkManager
            .getInstance(context)
            .enqueueUniqueWork(
                UNIQUE_WORK_NAME,
                existingWorkPolicy,
                request,
            )
    }

    //) VIV [Schedule Automatic Widget Refresh — 2026-10-08]

    //(VIV [Cancel Automatic Widget Refresh — 2026-10-08])

    fun cancel(
        context: Context,
    ) {
        WorkManager
            .getInstance(context)
            .cancelUniqueWork(
                UNIQUE_WORK_NAME,
            )
    }

    //) VIV [Cancel Automatic Widget Refresh — 2026-10-08]

    //(VIV [Load Automatic Interval — 2026-10-08])

    fun loadIntervalMs(
        inputData: Data,
    ): Long? {
        val intervalMs =
            inputData.getLong(
                INTERVAL_MS_KEY,
                -1L,
            )

        return if (intervalMs > 0L) {
            intervalMs
        } else {
            null
        }
    }

    //) VIV [Load Automatic Interval — 2026-10-08]
}

//) VIV [Automatic Widget Refresh Scheduler Class — 2026-10-08]

//) VIV [Automatic Widget Refresh Scheduler — 2026-10-08]