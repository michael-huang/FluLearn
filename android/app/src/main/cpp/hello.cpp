//
// Created by liyujiang on 2019/12/16.
//
#include <cstdio>
#include "log.h"
#include <jni.h>
#include "hello.h"

int main() {
    helloWorld();
    return 0;
}

void helloWorld() {
    LOGW("hello world from C/C++");
}

static int registerNativeMethods(JNIEnv *env, const char *className, JNINativeMethod *gMethods,
                                 int numMethods) {
    jclass clazz = env->FindClass(className);
    if (clazz == nullptr) {
        return JNI_FALSE;
    }
    if (env->RegisterNatives(clazz, gMethods, numMethods) < 0) {
        return JNI_FALSE;
    }
    return JNI_TRUE;
}

#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *) {
    LOGW("JNI_OnLoad");
    JNIEnv *env = nullptr;
    if (vm->GetEnv((void **) &env, JNI_VERSION_1_6) != JNI_OK) {
        return JNI_ERR;
    }
    LOGW("register native methods");
    //动态注册 native 方法，可以不受方法名称的限制，与 Java native 方法一一对应
    JNINativeMethod registerMethods[] = {
        {"helloWorld", "()V", (void *) helloWorld}
    };
    if (!registerNativeMethods(env, "com/example/flutter_app/HelloJNI", registerMethods,
                               sizeof(registerMethods) / sizeof(registerMethods[0]))) {
        LOGW("register native methods failed");
        return JNI_ERR;
    }
    LOGW("register native methods success");
    return JNI_VERSION_1_6;
}

#ifdef __cplusplus
}
#endif
