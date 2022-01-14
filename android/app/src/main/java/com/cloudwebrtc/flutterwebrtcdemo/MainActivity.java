import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "flutter.native/helper";
    Intent intent;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                    if (call.method.equals("startActivity")) {
                        if (!isCameraPermissionGranted()) {
                            requestCameraPermission();
                        } else {
                            intent = new Intent(MainActivity.this, Liveness.class);
                            intent.putExtra("ACCESS_KEY", "50WNYKJBV3E4QN0BXIMJUVMKN");
                            intent.putExtra("SECRET_KEY", "YGt3cz-7nCqo8cRJLfSHkky1klCO7Ol2Ja4uqA_ozBLJC70ztLjxi4-T_z4769mS");
                            intent.putExtra("THRESHOLD", "0.75");
                            Liveness.setUpListener(new Liveness.LivenessCallback() {
                                @Override
                                public void onSuccess(boolean isLive, Bitmap bitmap, double score)
                                {
                                    Toast.makeText(MainActivity.this, String.valueOf(isLive),

                                            Toast.LENGTH_LONG).show();

                                }

                                @Override
                                public void onError(String message) {
                                    Toast.makeText(MainActivity.this, message,

                                            Toast.LENGTH_LONG).show();
                                }
                            });
                        }
                    }

                    public void onButtonPressed(View v) {
                        startActivity(intent);
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
                }
            }
        );
    }
}