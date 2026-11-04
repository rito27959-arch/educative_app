# OURO PREP - ProGuard / R8 rules
# ============================================
# Production-grade rules for the entire app.

# ---- Flutter / Dart ----
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ---- Flutter WebRTC ----
-keep class org.webrtc.** { *; }

# ---- Supabase ----
-keep class com.supabase.** { *; }

# ---- Nearby Service ----
-keep class com.google.android.gms.nearby.** { *; }

# ---- Universal BLE ----
-keep class com.pauldemarco.** { *; }
-keep class com.welie.blessed.** { *; }

# ---- Gson / JSON serialization ----
# Keep data classes used with JSON
-keep class com.ouroprep.app.** { *; }
-keepclassmembers class com.ouroprep.app.** { *; }

# ---- Kotlin ----
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**

# ---- General Android ----
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keepattributes Signature
-keepattributes Exceptions

# ---- Keep Crash reporting ----
-keep class * implements java.io.Serializable { *; }

# ---- Keep enum classes ----
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ---- Remove logging in release ----
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
}

# ---- Composants différés de Flutter (Play Core) ----
# Le moteur Flutter y fait référence sans que l'app les embarque : sans ces
# lignes, R8 refuse la construction de publication (« Missing classes »).
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
# ---- Rive (moteur natif appelé par JNI) ----
-keep class app.rive.** { *; }
