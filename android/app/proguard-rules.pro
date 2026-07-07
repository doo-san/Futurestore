# ============================================================
# Règles R8/ProGuard — Future Store (com.interprest.futurestore)
# Couvre le code natif Android des plugins Flutter du projet.
# NB : le code Dart (GetX, modèles, jsonDecode, Repository) est
# compilé en AOT natif et n'est PAS affecté par R8 ; seule la
# couche Java/Kotlin l'est.
# ============================================================

# --- Flutter embedding ---
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Flutter référence Play Core (deferred components) même quand la
# fonctionnalité n'est pas utilisée — sans ce dontwarn, R8 échoue.
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# --- Classes de l'application (MainActivity, etc.) ---
-keep class com.interprest.futurestore.** { *; }

# --- Firebase (firebase_core, firebase_auth) ---
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# --- Google Sign-In (google_sign_in 7.x / Credential Manager) ---
-keep class com.google.android.libraries.identity.googleid.** { *; }
-keep class androidx.credentials.** { *; }
-dontwarn androidx.credentials.**

# --- OneSignal (onesignal_flutter + SDK natif 5.6.1) ---
-keep class com.onesignal.** { *; }
-dontwarn com.onesignal.**

# --- Facebook SDK (dépendance native déclarée dans build.gradle) ---
-keep class com.facebook.** { *; }
-dontwarn com.facebook.**

# --- Cronet (cronet_http) ---
-keep class org.chromium.net.** { *; }
-dontwarn org.chromium.net.**

# --- flutter_inappwebview / webview_flutter ---
-keep class com.pichillilorenzo.flutter_inappwebview_android.** { *; }
-dontwarn com.pichillilorenzo.**
-keepclassmembers class * extends android.webkit.WebChromeClient { *; }

# --- Gson (utilisé par OneSignal/Facebook en interne) ---
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keep class sun.misc.Unsafe { *; }
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# --- OkHttp / Okio (transitifs via plugins réseau) ---
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**

# --- Kotlin ---
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.coroutines.**

# --- AndroidX divers ---
-dontwarn androidx.window.**
-keep class androidx.lifecycle.DefaultLifecycleObserver

# --- Rive (rive_common, lib native via JNI) ---
-keep class app.rive.runtime.** { *; }
-dontwarn app.rive.runtime.**

# --- Conserver les classes appelées uniquement depuis le JNI/réflexion ---
-keepclasseswithmembernames class * {
    native <methods>;
}
-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
