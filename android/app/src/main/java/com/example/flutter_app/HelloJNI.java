package com.example.flutter_app;

public class HelloJNI {

    static {
        System.loadLibrary("hello");
    }

    public static native void helloWorld();

}