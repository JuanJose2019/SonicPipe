package com.example.sonic_pipe

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.sonicpipe/exoplayer"
    private var sonicPlayer: SonicPlayer? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        sonicPlayer = SonicPlayer(this, channel)

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "play" -> {
                    val path = call.argument<String>("path")
                    sonicPlayer?.play(path)
                    result.success(null)
                }
                "pause" -> {
                    sonicPlayer?.pause()
                    result.success(null)
                }
                "toggle" -> {
                    sonicPlayer?.toggle()
                    result.success(null)
                }
                "next" -> {
                    sonicPlayer?.next()
                    result.success(null)
                }
                "prev" -> {
                    sonicPlayer?.prev()
                    result.success(null)
                }
                "setPlaylist" -> {
                    val list = call.argument<List<Map<String, Any>>>("playlist")
                    if (list != null) {
                        sonicPlayer?.setPlaylist(list)
                    }
                    result.success(null)
                }
                "setVolume" -> {
                    val volume = call.argument<Double>("volume")?.toFloat() ?: 1f
                    sonicPlayer?.setVolume(volume)
                    result.success(null)
                }
                "seek" -> {
                    val position = call.argument<Number>("position")?.toLong() ?: 0L
                    sonicPlayer?.seek(position)
                    result.success(null)
                }
                "setRepeat" -> {
                    val repeat = call.argument<Boolean>("repeat") ?: false
                    sonicPlayer?.setRepeat(repeat)
                    result.success(null)
                }
                "setShuffle" -> {
                    val shuffle = call.argument<Boolean>("shuffle") ?: false
                    sonicPlayer?.setShuffle(shuffle)
                    result.success(null)
                }
                "getCurrentPosition" -> {
                    result.success(sonicPlayer?.getCurrentPosition())
                }
                "getDuration" -> {
                    result.success(sonicPlayer?.getDuration())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        sonicPlayer?.release()
    }
}
