#include <jni.h>
#include <string>

extern "C"
JNIEXPORT jstring JNICALL
Java_com_homebase_android_BaseActivity_stringFromJNI(
        JNIEnv *env,
        jobject /* this */) {
    std::string hello = "Homebase";
    return env->NewStringUTF(hello.c_str());
}
