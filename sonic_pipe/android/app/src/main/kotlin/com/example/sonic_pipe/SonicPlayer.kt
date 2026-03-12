package com.example.sonic_pipe

import android.content.Context
import androidx.media3.common.MediaItem
import androidx.media3.common.Player
import androidx.media3.exoplayer.ExoPlayer
import io.flutter.plugin.common.MethodChannel

class SonicPlayer(private val context: Context, private val channel: MethodChannel) {
    private var exoPlayer: ExoPlayer? = null
    private var playlist: List<Map<String, Any>> = emptyList()
    private var currentIndex: Int = 0
    private var isRepeat: Boolean = false
    private var isShuffle: Boolean = false
    private val MAX_VOLUME_LIMIT = 0.1f
    private var volume: Float = 1.0f

    init {
        val dataSourceFactory = androidx.media3.datasource.DefaultHttpDataSource.Factory()
            .setAllowCrossProtocolRedirects(true)
            
        val mediaSourceFactory = androidx.media3.exoplayer.source.DefaultMediaSourceFactory(dataSourceFactory)

        exoPlayer = ExoPlayer.Builder(context)
            .setMediaSourceFactory(mediaSourceFactory)
            .build().apply {
            addListener(object : Player.Listener {
                override fun onPlaybackStateChanged(playbackState: Int) {
                    when (playbackState) {
                        Player.STATE_READY -> {
                            channel.invokeMethod("onDuration", duration)
                        }
                        Player.STATE_ENDED -> {
                            onEnded()
                        }
                    }
                }

                override fun onIsPlayingChanged(isPlaying: Boolean) {
                    channel.invokeMethod("onIsPlayingChanged", isPlaying)
                }
            })
        }
    }

    fun setPlaylist(list: List<Map<String, Any>>) {
        playlist = list
        exoPlayer?.clearMediaItems()
        val items = list.mapNotNull { it["path"] as? String }.map { MediaItem.fromUri(it) }
        exoPlayer?.addMediaItems(items)
        exoPlayer?.prepare()
    }

    fun play(path: String?) {
        exoPlayer?.let { player ->
            if (path != null) {
                // Find index
                val index = playlist.indexOfFirst { it["path"] == path }
                if (index != -1) {
                    currentIndex = index
                    player.seekToDefaultPosition(currentIndex)
                } else {
                    // Not in playlist, just play it isolated
                    val mediaItem = MediaItem.fromUri(path)
                    player.setMediaItem(mediaItem)
                    player.prepare()
                }
            } else if (playlist.isNotEmpty() && player.mediaItemCount > 0) {
                    player.seekToDefaultPosition(currentIndex)
            }
            player.play()
        }
    }

    fun pause() {
        exoPlayer?.pause()
    }

    fun toggle() {
        exoPlayer?.let {
            if (it.isPlaying) it.pause() else it.play()
        }
    }

    fun next() {
        if (playlist.isEmpty()) return
        if (isShuffle) {
            currentIndex = (0 until playlist.size).random()
        } else {
            currentIndex = (currentIndex + 1) % playlist.size
        }
        playCurrent()
    }

    fun prev() {
        if (playlist.isEmpty()) return
        currentIndex = (currentIndex - 1 + playlist.size) % playlist.size
        playCurrent()
    }

    private fun playCurrent() {
        exoPlayer?.let { player ->
            if (currentIndex in 0 until player.mediaItemCount) {
                player.seekToDefaultPosition(currentIndex)
                player.play()
            }
        }
    }

    private fun onEnded() {
        if (isRepeat) {
            exoPlayer?.seekTo(0)
            exoPlayer?.play()
        } else {
            next()
        }
    }

    fun setVolume(valFloat: Float) {
        this.volume = valFloat
        exoPlayer?.volume = valFloat * MAX_VOLUME_LIMIT
    }

    fun seek(positionMs: Long) {
        exoPlayer?.seekTo(positionMs)
    }

    fun setRepeat(repeat: Boolean) {
        this.isRepeat = repeat
    }

    fun setShuffle(shuffle: Boolean) {
        this.isShuffle = shuffle
    }

    fun getCurrentPosition(): Long {
        return exoPlayer?.currentPosition ?: 0L
    }

    fun getDuration(): Long {
        return exoPlayer?.duration ?: 0L
    }
    
    fun release() {
        exoPlayer?.release()
        exoPlayer = null
    }
}
