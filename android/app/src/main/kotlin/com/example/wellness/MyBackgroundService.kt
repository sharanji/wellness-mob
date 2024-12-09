package com.wellness.iamok

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.google.firebase.FirebaseApp
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.FieldValue
import com.google.firebase.firestore.SetOptions
import java.util.*
import android.os.AsyncTask
import java.net.HttpURLConnection
import java.net.URL


class MyBackgroundService : Service() {

    private lateinit var firestore: FirebaseFirestore
    private lateinit var userId: String
    private val screenReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            when (intent?.action) {
                Intent.ACTION_SCREEN_ON -> updateScreenStatus("Screen On")
                Intent.ACTION_SCREEN_OFF -> updateScreenStatus("Screen Off")
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        FirebaseApp.initializeApp(this) // Initialize Firebase
        firestore = FirebaseFirestore.getInstance()

        // Register receiver for screen on/off events
        val filter = IntentFilter()
        filter.addAction(Intent.ACTION_SCREEN_ON)
        filter.addAction(Intent.ACTION_SCREEN_OFF)
        registerReceiver(screenReceiver, filter)

        // Start foreground service
        startForegroundService()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        userId = intent?.getStringExtra("userId") ?: "defaultUserId" // Default or handle appropriately

        return START_STICKY
    }

    private fun updateScreenStatus(status: String) {
        val screenStatus = hashMapOf(
            "status" to status,
            "timestamp" to Date() // Use current timestamp
        )
    
        // Update or set the document for the userId
        firestore.collection("screen_status")
            .document(userId)
            .collection("records")
            .add(screenStatus)

        if (status == "Screen On") {
            val lastActive = HashMap<String, Any>() // Create a Java HashMap
            lastActive["last_active"] = Date() // Add the Date as an Any

        
            firestore.collection("users")
                .document(userId)
                .update(lastActive)
        }
    }
    

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(screenReceiver)
    }

    private fun startForegroundService() {
        val notificationChannelId = "SCREEN_STATUS_CHANNEL"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                notificationChannelId,
                "Screen Status Service",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }

        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE)
        } else {
            PendingIntent.getActivity(this, 0, notificationIntent, 0)
        }

        val notification: Notification = NotificationCompat.Builder(this, notificationChannelId)
            .setContentTitle("Screen Status Service")
            .setContentText("Monitoring screen status...")
            // .setSmallIcon(R.drawable.ic_notification) // Provide your own notification icon
            .setContentIntent(pendingIntent)
            .build()

        startForeground(1, notification)
    }
}
