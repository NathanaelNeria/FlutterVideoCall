package com.cloudwebrtc.flutterwebrtcdemo;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import org.jetbrains.annotations.NotNull;
import org.json.JSONObject;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;
import nodeflux.sdk.liveness.Liveness;

public class MainActivity extends FlutterActivity{
    private static final String CHANNEL = "activeLiveness";
    Intent intent;

    @Override
    public void configureFlutterEngine(@NonNull @NotNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if(call.method.equals("startActivity")){
                                if(!isCameraPermissionGranted()){
                                    requestCameraPermission();
                                }
                                else {
                                    intent = new Intent(MainActivity.this, Liveness.class);
                                    intent.putExtra("ACCESS_KEY", "50WNYKJBV3E4QN0BXIMJUVMKN");
                                    intent.putExtra("SECRET_KEY", "YGt3cz-7nCqo8cRJLfSHkky1klCO7Ol2Ja4uqA_ozBLJC70ztLjxi4-T_z4769mS");
                                    intent.putExtra("THRESHOLD", "0.75");
                                    startActivity(intent);
                                    Liveness.setUpListener(new Liveness.LivenessCallback() {

                                        @Override
                                        public void onSuccess(boolean isLive, Bitmap bitmap, double score, String message) {
                                            Toast.makeText(MainActivity.this, String.valueOf(isLive),

                                                    Toast.LENGTH_LONG).show();
                                        }

                                        @Override
                                        public void onSuccessWithSubmissionToken(String s, Bitmap bitmap) {

                                        }

                                        @Override
                                        public void onError(String message, JSONObject jsonObject) {
                                            Toast.makeText(MainActivity.this, message,

                                                    Toast.LENGTH_LONG).show();
                                        }
                                    });
                                }
                            }

                        }
                );
    }

    @Override
    public void startActivity(Intent intent) {
        super.startActivity(intent);
    }

    public void requestCameraPermission() {
        ActivityCompat.requestPermissions(this, new
                String[]{Manifest.permission.CAMERA}, 101);
    }
    public boolean isCameraPermissionGranted() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(Manifest.permission.CAMERA) ==

                    PackageManager.PERMISSION_GRANTED) {

                Log.v("permission", "Camera Permission is granted");
                return true;
            } else {
                Log.v("permission", "Camera Permission is revoked");
                return false;
            }
        } else {
            Log.v("permission", "Camera Permission is granted");
            return true;
        }
    }
}