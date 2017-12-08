package de.lauviktor.roboremote;

/**
 * Created by Viktor on 01.10.2017.
 */
import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.SoundPool;
import android.net.Uri;

class AudioPlay {


    static boolean playbackbreak=false;
    static MediaPlayer mediaPlayer;
    private static SoundPool soundPool;
    static boolean isplayingAudio=false;
    static void playAudio(Context c, Uri id){
        mediaPlayer = MediaPlayer.create(c,id);
        soundPool = new SoundPool(4, AudioManager.STREAM_MUSIC, 100);
        if(!mediaPlayer.isPlaying())
        {
            isplayingAudio=true;
            mediaPlayer.start();
        }
    }
    static void stopAudio(){
        isplayingAudio=false;
        mediaPlayer.stop();
    }
    static void pauseAudio(){
        isplayingAudio=false;
        mediaPlayer.pause();
    }
    static void releaseAudio(){
        isplayingAudio=true;
        mediaPlayer.start();
    }
    static void playback_brake_for_tts(){
        isplayingAudio=false;
        mediaPlayer.pause();
        playbackbreak=true;
    }
    static void playback_release_from_tts(){
        isplayingAudio=true;
        mediaPlayer.start();
        playbackbreak=false;
    }
}