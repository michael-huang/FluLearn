import 'dart:ffi';

typedef HelloWorldNativeSign = Void Function();
typedef HelloWorldDartSign = void Function();

///
/// Dart/Flutter调用C/C++动态库
///
class DartCallC {
  static void helloWorld() {
    DynamicLibrary dl = DynamicLibrary.open('libhello.so');
    var helloWorld =
        dl.lookupFunction<HelloWorldNativeSign, HelloWorldDartSign>(
            "helloWorld");
    helloWorld();
  }
}
