package com.example.nauman

import android.os.Bundle
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;



import io.flutter.embedding.android.FlutterActivity


class MainActivity: FlutterActivity() {
    lateinit var facebooksdk:FacebookSdk

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        facebooksdk = FacebookSdk
//        facebookSdk=FacebookSdk
//        facebookSdk
        facebooksdk.sdkInitialize(applicationContext)
        facebooksdk.setAutoLogAppEventsEnabled(true)
        facebooksdk.setAutoInitEnabled(true)


    }
}

    