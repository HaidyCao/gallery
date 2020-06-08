package app.android.gallery;

import android.app.Application;
import android.content.ContentResolver;
import android.database.Cursor;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MediaPlugin implements FlutterPlugin {

    private static final String TAG = MediaPlugin.class.getSimpleName();
    public static final String METHOD_LOAD_MEDIAS = "loadMedias";

    private ExecutorService mLoadExecutorService = Executors.newSingleThreadExecutor();

    private Application mApplication;

    public MediaPlugin(@NonNull Application application) {
        mApplication = application;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        MethodChannel methodChannel = new MethodChannel(binding.getBinaryMessenger(), BuildConfig.APPLICATION_ID + "/media");

        methodChannel.setMethodCallHandler((call, result) -> {
            if (METHOD_LOAD_MEDIAS.equals(call.method)) {
                loadMedias(call, result);
            }
        });
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }

    private void loadMedias(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG, "loadMedias() called with: call = [" + call + "], result = [" + result + "]");
        String uri = call.argument("uri");
        Log.d(TAG, "loadMedias: isMainThread = " + (Looper.myLooper() == Looper.getMainLooper()));

        if (TextUtils.isEmpty(uri)) {
            result.error("400", "uri is empty", null);
            return;
        }

        assert uri != null;

        String[] projection;
        if (uri.startsWith(MediaStore.Images.Media.EXTERNAL_CONTENT_URI.toString())) {
            projection = new String[]{MediaStore.MediaColumns._ID, MediaStore.MediaColumns.DATA, MediaStore.MediaColumns.DISPLAY_NAME};
        } else if (uri.startsWith(MediaStore.Video.Media.EXTERNAL_CONTENT_URI.toString())
                || uri.startsWith(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI.toString())) {
            projection = new String[]{MediaStore.MediaColumns._ID, MediaStore.MediaColumns.DATA, MediaStore.MediaColumns.DISPLAY_NAME, "duration"};
        } else {
            result.error("400", "bad uri", null);
            return;
        }

        Runnable runnable = () -> {
            Handler handler = new Handler(Looper.getMainLooper());

            ContentResolver resolver = mApplication.getContentResolver();
            List<String> list = new ArrayList<>();
            try (Cursor cursor = resolver.query(Uri.parse(uri), projection, null, null, null)) {
                if (cursor == null || cursor.isClosed() || !cursor.moveToFirst()) {
                    handler.post(() -> result.success(new ArrayList<>()));
                    return;
                }

                int durationIndex = cursor.getColumnIndex("duration");
                do {
                    JSONObject json = new JSONObject();

                    try {
                        json.put("id", cursor.getLong(0));
                        json.put("path", cursor.getString(1));
                        json.put("name", cursor.getString(2));

                        if (durationIndex != -1) {
                            json.put("duration", cursor.getLong(durationIndex));
                        }

                        String value = json.toString();
                        Log.d(TAG, "loadMedias: value = " + value);
                        list.add(value);
                    } catch (JSONException e) {
                        Log.e(TAG, "loadMedias: " + e.getMessage(), e);
                    }
                } while (cursor.moveToNext());
            }
            handler.post(() -> result.success(list));
        };

        if (Looper.getMainLooper() == Looper.myLooper()) {
            mLoadExecutorService.execute(runnable);
        } else {
            runnable.run();
        }
    }


}
