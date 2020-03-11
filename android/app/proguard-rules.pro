## Flutter WebRTC

-keep class com.cloudwebrtc.webrtc.** { *; }

-keep class org.webrtc.** { *; }


### ffmpeg
##Flutter Wrapper
#-keep class io.flutter.app.** { *; }
#-keep class io.flutter.plugin.**  { *; }
#-keep class io.flutter.util.**  { *; }
#-keep class io.flutter.view.**  { *; }
#-keep class io.flutter.**  { *; }
#-keep class io.flutter.plugins.**  { *; }
#
## Flutter FFmpeg
#-keep class com.arthenica.mobileffmpeg.Config {
#    native <methods>;
#    void log(int, byte[]);
#    void statistics(int, float, float, long , int, double, double);
#
#}