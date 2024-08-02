package com.example.ext_fingerprint

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import kotlinx.serialization.Serializable
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import okhttp3.Call
import okhttp3.Callback
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import java.io.IOException

@Serializable
data class User(val userId: Int, val id: Int, val title: String, val completed: Boolean)

class MainActivity: FlutterActivity() {
  private val CHANNEL = "sample.api.call"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "getApiResponse") {
          getApiResponse { apiResponse ->
              if (apiResponse != "-1") {
                  result.success(apiResponse)
              } else {
                  result.error("UNAVAILABLE", "API Response not available.", null)
              }
          }
      } else {
          result.notImplemented()
      }
  }
}

  private fun getApiResponse(callback: (String) -> Unit) {
    val client = OkHttpClient()
    val url = "https://jsonplaceholder.typicode.com/todos/1"
    val request = Request.Builder()
      .url(url)
      .build()
    client.newCall(request).enqueue(object : Callback {
      override fun onFailure(call: Call, e: IOException) {}
      override fun onResponse(call: Call, response: Response) {
        response.body?.use { responseBody ->
            val responseBodyString = responseBody.string()
            try {
                val user = Json.decodeFromString<User>(responseBodyString)
                val apiResponse = user.title
                Log.d("MainActivity", apiResponse)
                callback(apiResponse)
            } catch (e: Exception) {
                Log.e("MainActivity", "Failed to parse JSON", e)
                callback("-1")
            }
        } ?: callback("-1")
    }
    })
  }
}