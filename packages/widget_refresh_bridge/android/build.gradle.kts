//(VIV [Widget Refresh Bridge Android Build — 2026-10-05])

plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

group = "com.example.widget_refresh_bridge"
version = "1.0"

android {
    namespace = "com.example.widget_refresh_bridge"
    compileSdk = 36

    defaultConfig {
        minSdk = 21
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

kotlin {
    compilerOptions {
        jvmTarget =
            org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

//) VIV [Widget Refresh Bridge Android Build — 2026-10-05]