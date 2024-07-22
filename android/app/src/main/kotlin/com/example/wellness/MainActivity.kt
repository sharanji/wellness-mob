package com.example.wellness

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import androidx.work.PeriodicWorkRequest
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit
import androidx.work.Data

import androidx.work.WorkRequest

import android.content.Context
import androidx.work.Worker
import androidx.work.WorkerParameters
import android.util.Log

import java.util.*
import android.os.AsyncTask
import java.net.HttpURLConnection
import java.net.URL

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.wellness/screenStatus"
    private val CHANNEL_work = "com.example.wellness/workmanager"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startService") {
                val userId = call.argument<String>("userId")
                if (userId != null) {
                    startScreenStatusService(userId)
                    result.success(null)
                }
            } else {
                result.notImplemented()
            }
        }

        // MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_work).setMethodCallHandler { call, result ->
        //     if (call.method == "initializeWorkManager") {
        //         val userId = call.argument<String>("userId")
        //         if (userId != null) {
        //             initializeWorkManager(userId)
        //             result.success(null)
        //         }
        //     } else {
        //         result.notImplemented()
        //     }
        // }

    }

    private fun initializeWorkManager(userId: String) {
        // Create a PeriodicWorkRequest
        // val periodicWorkRequest: WorkRequest = PeriodicWorkRequestBuilder<PeriodicTaskWorker>(15, TimeUnit.MINUTES)
        //     .build()

        val inputData = Data.Builder()
            .putString("userId", userId)
            .build()

        val periodicWorkRequest: PeriodicWorkRequest = PeriodicWorkRequestBuilder<PeriodicTaskWorker>(15, TimeUnit.MINUTES)
            .setInputData(inputData)
            .build()

        // Enqueue the periodic work
        WorkManager.getInstance(this).enqueue(periodicWorkRequest)
    }

    private fun startScreenStatusService(userId: String) {
        val intent = Intent(this, MyBackgroundService::class.java)
        intent.putExtra("userId", userId)
        startService(intent)
    }
}

class PeriodicTaskWorker(appContext: Context, workerParams: WorkerParameters) :
    Worker(appContext, workerParams) {

    override fun doWork(): Result {
        val userId = inputData.getString("userId")
        val url = "https://0464-2404-8ec0-4-12a0-de2-379c-7c92-e0c7.ngrok-free.app/api/screenMonitor?userId="+userId;
        
        HttpGetRequest(url).execute().get().let {
            
        }

        // Your periodic code here
        Log.d("PeriodicTaskWorker", "This code runs periodically")

        // Indicate whether the work finished successfully with the Result
        return Result.success()
    }
}




class HttpGetRequest(private val urlString: String) : AsyncTask<Void, Void, String>() {

    override fun doInBackground(vararg params: Void?): String {
        var result = ""
        try {
            val url = URL(urlString)
            val urlConnection = url.openConnection() as HttpURLConnection
            try {
                val inputStream = urlConnection.inputStream
                result = inputStream.bufferedReader().use { it.readText() }
            } finally {
                urlConnection.disconnect()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return result
    }
}
