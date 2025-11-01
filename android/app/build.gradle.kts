plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.zoo_app"
    compileSdk = 36  // pastikan ini cocok dengan SDK-mu

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.zoo_app"
        minSdk = flutter.minSdkVersion  // minimal SDK agar plugin modern bisa jalan
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")

    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
}

flutter {
    source = "../.."
}
