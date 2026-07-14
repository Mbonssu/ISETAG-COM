plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.prospection"
    compileSdk = 36  // ← Fixe à 36 au lieu de flutter.compileSdkVersion
    ndkVersion = "28.2.13676358"  // ← Fixe la version NDK

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // AJOUTE CETTE LIGNE (TRÈS IMPORTANTE)
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"  // ← Simplifie en "17"
    }

    defaultConfig {
        applicationId = "com.example.prospection"
        minSdk = flutter.minSdkVersion  // ← Fixe explicitement
        targetSdk = 36  // ← Fixe explicitement
        versionCode = 1
        versionName = "1.0.0"
        // AJOUTE CETTE LIGNE
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

//  AJOUTE CE BLOC dependencies
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
