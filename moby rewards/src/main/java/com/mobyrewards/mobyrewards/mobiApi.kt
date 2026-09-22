package com.mobyrewards.mobyrewards

import android.os.Handler
import android.os.Looper
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import kotlin.concurrent.thread

object MobyApi {

    private const val API_URL =
            "https://mobyads.in/moby/v4/"

    // =========================================================
    // UPCOMING OFFERS
    // =========================================================

    fun getUpcomingOffers(
        affiliateId: String,
        appShortName: String,
        secureKey: String,
        userUnique: String,
        gender: String,
        age: Int,
        deviceId: String,
        onSuccess: (JSONObject) -> Unit,
        onError: (String) -> Unit
    ) {

        thread {

            try {

                val connection =
                    URL(API_URL).openConnection()
                            as HttpURLConnection

                connection.requestMethod = "POST"
                connection.connectTimeout = 15000
                connection.readTimeout = 15000
                connection.doOutput = true

                connection.setRequestProperty(
                    "Content-Type",
                    "application/json"
                )

                connection.setRequestProperty(
                    "Accept",
                    "application/json"
                )

                val request = JSONObject().apply {

                    put(
                        "fsAction",
                        "getUpcommingOffer"
                    )

                    put(
                        "fsAffiliateId",
                        affiliateId
                    )

                    put(
                        "fsAppShortName",
                        appShortName
                    )

                    put(
                        "fsSecureKey",
                        secureKey
                    )

                    put(
                        "fsUserUnique",
                        userUnique
                    )

                    put(
                        "fsGender",
                        gender
                    )

                    put(
                        "fiAge",
                        age
                    )

                    put(
                        "fsDeviceId",
                        deviceId
                    )
                }

                android.util.Log.d(
                    "MOBY_UPCOMING_API",
                    "REQUEST = ${request}"
                )

                connection.outputStream.use {
                    it.write(
                        request.toString()
                            .toByteArray(Charsets.UTF_8)
                    )
                }

                val responseCode =
                    connection.responseCode

                android.util.Log.d(
                    "MOBY_UPCOMING_API",
                    "HTTP RESPONSE CODE = $responseCode"
                )

                val response =
                    if (responseCode in 200..299) {

                        connection.inputStream
                            .bufferedReader()
                            .use { it.readText() }

                    } else {

                        connection.errorStream
                            ?.bufferedReader()
                            ?.use { it.readText() }
                            ?: "HTTP Error: $responseCode"
                    }

                connection.disconnect()

                Handler(Looper.getMainLooper()).post {

                    if (responseCode in 200..299) {

                        try {

                            val json =
                                JSONObject(response)

                            onSuccess(json)

                        } catch (e: Exception) {

                            onError(
                                "Invalid JSON response: ${e.message}"
                            )
                        }

                    } else {

                        onError(
                            "API Error $responseCode: $response"
                        )
                    }
                }

            } catch (e: Exception) {

                Handler(Looper.getMainLooper()).post {

                    onError(
                        e.message ?: "Network error"
                    )
                }
            }
        }
    }

    // =========================================================
// DIRECT SUBMIT QUIZ
// =========================================================

    fun directSubmitQuiz(
        adId: Int,
        deviceUniqueId: Int,
        token: String,
        userId: String,
        userContact: String,
        deviceId: String,
        isPwa: String = "no",
        onSuccess: (JSONObject) -> Unit,
        onError: (String) -> Unit
    ) {

        thread {

            try {

                val connection =
                    URL(API_URL).openConnection()
                            as HttpURLConnection

                connection.requestMethod = "POST"
                connection.connectTimeout = 15000
                connection.readTimeout = 15000
                connection.doOutput = true

                connection.setRequestProperty(
                    "Content-Type",
                    "application/json"
                )

                connection.setRequestProperty(
                    "Accept",
                    "application/json"
                )

                connection.setRequestProperty(
                    "Authorization",
                    "Bearer $token"
                )

                val request = JSONObject().apply {

                    put(
                        "fsAction",
                        "directSubmitQuiz"
                    )

                    put(
                        "fiAdId",
                        adId
                    )

                    put(
                        "device_unique_id",
                        deviceUniqueId
                    )

                    put(
                        "fsToken",
                        token
                    )

                    put(
                        "fiUserId",
                        userId
                    )

                    put(
                        "fsUserContact",
                        userContact
                    )

                    put(
                        "fsDeviceId",
                        deviceId
                    )

                    put(
                        "isPWA",
                        isPwa
                    )
                }

                connection.outputStream.use {
                    it.write(
                        request.toString()
                            .toByteArray(Charsets.UTF_8)
                    )
                }

                val responseCode =
                    connection.responseCode

                val response =
                    if (responseCode in 200..299) {

                        connection.inputStream
                            .bufferedReader()
                            .use { it.readText() }

                    } else {

                        connection.errorStream
                            ?.bufferedReader()
                            ?.use { it.readText() }
                            ?: "HTTP Error: $responseCode"
                    }

                connection.disconnect()

                Handler(Looper.getMainLooper()).post {

                    if (responseCode in 200..299) {

                        try {

                            val json =
                                JSONObject(response)

                            onSuccess(json)

                        } catch (e: Exception) {

                            onError(
                                "Invalid JSON response: ${e.message}"
                            )
                        }

                    } else {

                        onError(
                            "API Error $responseCode: $response"
                        )
                    }
                }

            } catch (e: Exception) {

                Handler(Looper.getMainLooper()).post {

                    onError(
                        e.message ?: "Network error"
                    )
                }
            }
        }
    }

    // =========================================================
    // ACTIVE OFFERS
    // =========================================================

    fun getActiveOffers(
        affiliateId: String,
        appShortName: String,
        secureKey: String,
        userUnique: String,
        gender: String,
        age: Int,
        deviceId: String,
        onSuccess: (JSONObject) -> Unit,
        onError: (String) -> Unit
    ) {

        thread {

            try {

                val connection =
                    URL(API_URL).openConnection()
                            as HttpURLConnection

                connection.requestMethod = "POST"
                connection.connectTimeout = 15000
                connection.readTimeout = 15000
                connection.doOutput = true

                connection.setRequestProperty(
                    "Content-Type",
                    "application/json"
                )

                connection.setRequestProperty(
                    "Accept",
                    "application/json"
                )

                val request = JSONObject().apply {

                    put(
                        "fsAction",
                        "getActiveOffer"
                    )

                    put(
                        "fsAffiliateId",
                        affiliateId
                    )

                    put(
                        "fsAppShortName",
                        appShortName
                    )

                    put(
                        "fsSecureKey",
                        secureKey
                    )

                    put(
                        "fsUserUnique",
                        userUnique
                    )

                    put(
                        "fsGender",
                        gender
                    )

                    put(
                        "fiAge",
                        age
                    )

                    put(
                        "fsDeviceId",
                        deviceId
                    )
                }

                connection.outputStream.use {
                    it.write(
                        request.toString()
                            .toByteArray(Charsets.UTF_8)
                    )
                }

                val responseCode =
                    connection.responseCode

                val response =
                    if (responseCode in 200..299) {

                        connection.inputStream
                            .bufferedReader()
                            .use { it.readText() }

                    } else {

                        connection.errorStream
                            ?.bufferedReader()
                            ?.use { it.readText() }
                            ?: "HTTP Error: $responseCode"
                    }

                connection.disconnect()

                Handler(Looper.getMainLooper()).post {

                    if (responseCode in 200..299) {

                        try {

                            val json =
                                JSONObject(response)

                            onSuccess(json)

                        } catch (e: Exception) {

                            onError(
                                "Invalid JSON response: ${e.message}"
                            )
                        }

                    } else {

                        onError(
                            "API Error $responseCode: $response"
                        )
                    }
                }

            } catch (e: Exception) {

                Handler(Looper.getMainLooper()).post {

                    onError(
                        e.message ?: "Network error"
                    )
                }
            }
        }
    }
}