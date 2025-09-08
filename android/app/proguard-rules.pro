# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Google Play Core (Fix for R8 missing classes)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep line numbers for crash reports
-keepattributes SourceFile,LineNumberTable

# Enhanced obfuscation settings
-repackageclasses ''
-allowaccessmodification
-overloadaggressively
-mergeinterfacesaggressively

# Remove debugging logs
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}

# Remove print statements
-assumenosideeffects class java.io.PrintStream {
    public void println(%);
    public void print(%);
}

# Additional security measures
-keepattributes !LocalVariableTable,!LocalVariableTypeTable
-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*,EnclosingMethod