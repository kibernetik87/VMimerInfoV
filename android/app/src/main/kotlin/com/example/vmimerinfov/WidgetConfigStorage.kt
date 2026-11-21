//(VIV [Widget Config Storage — 2026-10-08])

package com.example.vmimerinfov

import android.content.Context

//(VIV [Widget Config Storage Class — 2026-10-08])

class WidgetConfigStorage(
    context: Context,
) {

    companion object {
        private const val PREFS_NAME =
            "vmimerinfov_widget_config"

        private const val KEY_WALLET_PREFIX =
            "wallet_"

        private const val KEY_WALLET_NAME_PREFIX =
            "wallet_name_"
    }

    private val preferences =
        context.getSharedPreferences(
            PREFS_NAME,
            Context.MODE_PRIVATE,
        )

    //(VIV [Save Widget Wallet Configuration — 2026-10-08])

    fun saveWalletConfiguration(
        appWidgetId: Int,
        walletId: String,
        walletName: String,
    ) {
        preferences.edit()
            .putString(
                "$KEY_WALLET_PREFIX$appWidgetId",
                walletId,
            )
            .putString(
                "$KEY_WALLET_NAME_PREFIX$appWidgetId",
                walletName,
            )
            .apply()
    }

    //) VIV [Save Widget Wallet Configuration — 2026-10-08]

    //(VIV [Save Widget Wallet — 2026-10-05])

    fun saveWalletId(
        appWidgetId: Int,
        walletId: String,
    ) {
        preferences.edit()
            .putString(
                "$KEY_WALLET_PREFIX$appWidgetId",
                walletId,
            )
            .apply()
    }

    //) VIV [Save Widget Wallet — 2026-10-05]

    //(VIV [Load Widget Wallet — 2026-10-05])

    fun loadWalletId(
        appWidgetId: Int,
    ): String? {
        return preferences.getString(
            "$KEY_WALLET_PREFIX$appWidgetId",
            null,
        )
    }

    //) VIV [Load Widget Wallet — 2026-10-05]

    //(VIV [Load Widget Wallet Name — 2026-10-08])

    fun loadWalletName(
        appWidgetId: Int,
    ): String? {
        return preferences.getString(
            "$KEY_WALLET_NAME_PREFIX$appWidgetId",
            null,
        )
    }

    //) VIV [Load Widget Wallet Name — 2026-10-08]

    //(VIV [Load All Widget Wallets — 2026-10-05])

    fun loadAllWalletIds(): Map<Int, String> {
        return preferences.all
            .mapNotNull { (key, value) ->
                if (
                    !key.startsWith(
                        KEY_WALLET_PREFIX,
                    )
                ) {
                    return@mapNotNull null
                }

                val appWidgetId =
                    key.removePrefix(
                        KEY_WALLET_PREFIX,
                    ).toIntOrNull()
                        ?: return@mapNotNull null

                val walletId =
                    value as? String
                        ?: return@mapNotNull null

                appWidgetId to walletId
            }
            .toMap()
    }

    //) VIV [Load All Widget Wallets — 2026-10-05]

    //(VIV [Remove Widget Wallet — 2026-10-08])

    fun removeWalletId(
        appWidgetId: Int,
    ) {
        preferences.edit()
            .remove(
                "$KEY_WALLET_PREFIX$appWidgetId",
            )
            .remove(
                "$KEY_WALLET_NAME_PREFIX$appWidgetId",
            )
            .apply()
    }

    //) VIV [Remove Widget Wallet — 2026-10-08]
}

//) VIV [Widget Config Storage Class — 2026-10-08]

//) VIV [Widget Config Storage — 2026-10-08]