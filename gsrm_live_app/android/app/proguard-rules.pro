-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Firebase
-keep class com.google.firebase.** { *; }
-keep class io.flutter.plugins.firebase.** { *; }
-dontwarn com.google.firebase.**

# Pigeon (used by FlutterFire)
-keep class io.flutter.plugins.firebase.core.** { *; }
-keep interface io.flutter.plugins.firebase.core.** { *; }