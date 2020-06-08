package app.android.gallery;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.nio.ByteBuffer;

import io.flutter.plugin.common.BinaryMessenger;

public class GalleryBinaryMessenger implements BinaryMessenger {

    private static final String TAG = GalleryBinaryMessenger.class.getSimpleName();

    @Override
    public void send(@NonNull String channel, @Nullable ByteBuffer message) {
        Log.d(TAG, "send() called with: channel = [" + channel + "], message = [" + message + "]");
    }

    @Override
    public void send(@NonNull String channel, @Nullable ByteBuffer message, @Nullable BinaryReply callback) {
        Log.d(TAG, "send() called with: channel = [" + channel + "], message = [" + message + "], callback = [" + callback + "]");
    }

    @Override
    public void setMessageHandler(@NonNull String channel, @Nullable BinaryMessageHandler handler) {
        Log.d(TAG, "setMessageHandler() called with: channel = [" + channel + "], handler = [" + handler + "]");
    }
}
