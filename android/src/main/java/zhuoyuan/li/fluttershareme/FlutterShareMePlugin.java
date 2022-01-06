package zhuoyuan.li.fluttershareme;


import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.content.FileProvider;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;
import com.twitter.sdk.android.tweetcomposer.TweetComposer;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterShareMePlugin
 */
public class FlutterShareMePlugin implements MethodCallHandler, FlutterPlugin, ActivityAware {

    final private static String _methodWhatsApp = "whatsapp_share";
    final private static String _methodWhatsAppPersonal = "whatsapp_personal";
    final private static String _methodWhatsAppBusiness = "whatsapp_business_share";
    final private static String _methodFaceBook = "facebook_share";
    final private static String _methodTwitter = "twitter_share";
    final private static String _methodSystemShare = "system_share";
    final private static String _methodInstagramShare = "instagram_share";
    final private static String _methodTelegramShare = "telegram_share";
    final private static String _methodMessengerShare = "messenger_share";
    final private static String _methodLineShare = "line_share";
    final private static String _methodBeeBushShare = "beebush_share";

    private final static String INSTAGRAM_PACKAGE_NAME = "com.instagram.android";
    private final static String FACEBOOK_PACKAGE_NAME = "com.facebook.katana";
    private final static String TWITTER_PACKAGE_NAME = "com.twitter.android";

    private Activity activity;
    private static CallbackManager callbackManager;
    private MethodChannel methodChannel;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final FlutterShareMePlugin instance = new FlutterShareMePlugin();
        instance.onAttachedToEngine(registrar.messenger());
        instance.activity = registrar.activity();
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        onAttachedToEngine(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
        methodChannel = null;
        activity = null;
    }

    private void onAttachedToEngine(BinaryMessenger messenger) {
        methodChannel = new MethodChannel(messenger, "midas_share");
        methodChannel.setMethodCallHandler(this);
        callbackManager = CallbackManager.Factory.create();
    }

    /**
     * method
     *
     * @param call   methodCall
     * @param result Result
     */
    @Override
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        String url, msg;
        boolean openMarket;
        final PackageManager pm = activity.getPackageManager();
        switch (call.method) {
            case _methodFaceBook:
                // url = call.argument("url");
                // msg = call.argument("msg");
                // shareToFacebook(msg, url, result);
                try {
                    pm.getPackageInfo(FACEBOOK_PACKAGE_NAME, PackageManager.GET_ACTIVITIES);
                    facebookShare(call.<String>argument("caption"), call.<String>argument("path"));
                    result.success(true);
                } catch (PackageManager.NameNotFoundException e) {
                    openPlayStore(FACEBOOK_PACKAGE_NAME);
                    result.success(false);
                }
                break;
            case _methodTwitter:
                url = call.argument("url");
                msg = call.argument("msg");
                shareToTwitter(url, msg, result);
                break;
            case _methodWhatsApp:
                msg = call.argument("msg");
                url = call.argument("url");
                shareWhatsApp(url, msg, result, false);
                break;
            case _methodWhatsAppBusiness:
                msg = call.argument("msg");
                url = call.argument("url");
                shareWhatsApp(url, msg, result, true);
                break;
            case _methodWhatsAppPersonal:
                msg = call.argument("msg");
                String phoneNumber = call.argument("phoneNumber");
                shareWhatsAppPersonal(msg, phoneNumber, result);
                break;
            case _methodSystemShare:
                msg = call.argument("msg");
                shareSystem(result, msg);
                break;
            case _methodInstagramShare:
                msg = call.argument("url");
                openMarket = call.argument("openMarket");
                shareInstagramStory(msg, openMarket, result);
                break;
            case _methodTelegramShare:
                msg = call.argument("msg");
                openMarket = call.argument("openMarket");
                shareToTelegram(msg, openMarket, result);
                break;
            case _methodMessengerShare:
                msg = call.argument("msg");
                openMarket = call.argument("openMarket");
                shareToMessenger(msg, openMarket, result);
                break;
            case _methodLineShare:
                msg = call.argument("msg");
                openMarket = call.argument("openMarket");
                shareToLine(msg, openMarket, result);
                break;
            case _methodBeeBushShare:
                url = call.argument("url");
                openMarket = call.argument("openMarket");
                shareToBeeBush(url, openMarket, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    /**
     * system share
     *
     * @param msg    String
     * @param result Result
     */
    private void shareSystem(Result result, String msg) {
        try {
            Intent textIntent = new Intent("android.intent.action.SEND");
            textIntent.setType("text/plain");
            textIntent.putExtra("android.intent.extra.TEXT", msg);
            activity.startActivity(Intent.createChooser(textIntent, "Share to"));
            result.success("success");
        } catch (Exception var7) {
            result.error("error", var7.toString(), "");
        }
    }

    /**
     * share to twitter
     *
     * @param url    String
     * @param msg    String
     * @param result Result
     */

    private void shareToTwitter(String url, String msg, Result result) {
        try {
            TweetComposer.Builder builder = new TweetComposer.Builder(activity)
                    .text(msg);
            if (url != null && url.length() > 0) {
                builder.url(new URL(url));
            }

            builder.show();
            result.success("success");
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
    }

    /**
     * share to Facebook
     *
     * @param url    String
     * @param msg    String
     * @param result Result
     */
    // private void shareToFacebook(String msg, String url, Result result) {
    //     try {
            
    //         final Uri uri = Uri.parse(url);
    //         final ShareLinkContent content = new ShareLinkContent.Builder().setContentUrl(uri).setQuote(msg).build();
    //         final ShareDialog shareDialog = new ShareDialog(activity);
    //         shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
    //             @Override
    //             public void onSuccess(Sharer.Result result) {
    //                 methodChannel.invokeMethod("onSuccess", null);
    //                 Log.d("SocialSharePlugin", "Sharing successfully done.");
    //             }
    
    //             @Override
    //             public void onCancel() {
    //                 methodChannel.invokeMethod("onCancel", null);
    //                 Log.d("SocialSharePlugin", "Sharing cancelled.");
    //             }
    
    //             @Override
    //             public void onError(FacebookException error) {
    //                 methodChannel.invokeMethod("onError", error.getMessage());
    //                 Log.d("SocialSharePlugin", "Sharing error occurred.");
    //             }
    //         });
    
    //         if (ShareDialog.canShow(ShareLinkContent.class)) {
    //             shareDialog.show(content);
    //             result.success("success");
    //         }
    //     } catch (Exception e) {
    //         System.out.println("---------------onError");
    //         System.out.println(e);
    //     }

    // }
    private void facebookShare(String caption, String mediaPath) {
        final File media = new File(mediaPath);
        final Uri uri = FileProvider.getUriForFile(activity, activity.getPackageName() + ".social.share.fileprovider",
                media);
        final SharePhoto photo = new SharePhoto.Builder().setImageUrl(uri).setCaption(caption).build();
        final SharePhotoContent content = new SharePhotoContent.Builder().addPhoto(photo).build();
        final ShareDialog shareDialog = new ShareDialog(activity);
        shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
            @Override
            public void onSuccess(Sharer.Result result) {
                channel.invokeMethod("onSuccess", null);
                Log.d("SocialSharePlugin", "Sharing successfully done.");
            }

            @Override
            public void onCancel() {
                channel.invokeMethod("onCancel", null);
                Log.d("SocialSharePlugin", "Sharing cancelled.");
            }

            @Override
            public void onError(FacebookException error) {
                channel.invokeMethod("onError", error.getMessage());
                Log.d("SocialSharePlugin", "Sharing error occurred.");
            }
        });

        if (ShareDialog.canShow(SharePhotoContent.class)) {
            shareDialog.show(content);
        }
    }

    private void facebookShareLink(String quote, String url) {
        final Uri uri = Uri.parse(url);
        final ShareLinkContent content = new ShareLinkContent.Builder().setContentUrl(uri).setQuote(quote).build();
        final ShareDialog shareDialog = new ShareDialog(activity);
        shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
            @Override
            public void onSuccess(Sharer.Result result) {
                channel.invokeMethod("onSuccess", null);
                Log.d("SocialSharePlugin", "Sharing successfully done.");
            }

            @Override
            public void onCancel() {
                channel.invokeMethod("onCancel", null);
                Log.d("SocialSharePlugin", "Sharing cancelled.");
            }

            @Override
            public void onError(FacebookException error) {
                channel.invokeMethod("onError", error.getMessage());
                Log.d("SocialSharePlugin", "Sharing error occurred.");
            }
        });

        if (ShareDialog.canShow(ShareLinkContent.class)) {
            shareDialog.show(content);
        }
    }
    /**
     * share to whatsapp
     *
     * @param msg                String
     * @param result             Result
     * @param shareToWhatsAppBiz boolean
     */
    private void shareWhatsApp(String imagePath, String msg, Result result, boolean shareToWhatsAppBiz) {
        try {
            Intent whatsappIntent = new Intent(Intent.ACTION_SEND);
            
            whatsappIntent.setPackage(shareToWhatsAppBiz ? "com.whatsapp.w4b" : "com.whatsapp");
            whatsappIntent.putExtra(Intent.EXTRA_TEXT, msg);
            // if the url is the not empty then get url of the file and share
            if (!TextUtils.isEmpty(imagePath)) {
                whatsappIntent.setType("*/*");
                System.out.print(imagePath+"url is not empty");
                File file = new File(imagePath);
                Uri fileUri = FileProvider.getUriForFile(activity, activity.getApplicationContext().getPackageName() + ".provider", file);
                whatsappIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                whatsappIntent.putExtra(Intent.EXTRA_STREAM, fileUri);
                whatsappIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            }
            else {
                whatsappIntent.setType("text/plain");
            }
            try {
                activity.startActivity(whatsappIntent);
                result.success("true");
            } catch (Exception ex) {
                if (openMarket) {
                    this.openMarket("org.telegram.messenger");
                    result.success("false: Telegram app is not installed on your device");
                 } else {
                    result.success("false: Telegram app is not installed on your device");
                }
            }
        } catch (Exception var9) {
            result.error("error", var9.toString(), "");
        }
    }
    /**
     * share to telegram
     *
     * @param msg                String
     * @param result             Result
     */
    private void shareToTelegram(String msg, boolean openMarket, Result result) {
        try {
            Intent telegramIntent = new Intent(Intent.ACTION_SEND);
            telegramIntent.setType("text/plain");
            telegramIntent.setPackage("org.telegram.messenger");
            telegramIntent.putExtra(Intent.EXTRA_TEXT, msg);
            try {
                activity.startActivity(telegramIntent);
                result.success("true");
            } catch (Exception ex) {
                if (openMarket) {
                    this.openMarket("org.telegram.messenger");
                    result.success("false: Telegram app is not installed on your device");
                 } else {
                    result.success("false: Telegram app is not installed on your device");
                }
            }
        } catch (Exception var9) {
            result.error("error", var9.toString(), "");
        }
    }

    /**
     * share to Messenger
     *
     * @param msg                String
     * @param result             Result
     */
    private void shareToMessenger(String msg, boolean openMarket, Result result) {
        try {
            Intent messengerIntent = new Intent(Intent.ACTION_SEND);
            messengerIntent.setType("text/plain");
            messengerIntent.setPackage("com.facebook.orca");
            messengerIntent.putExtra(Intent.EXTRA_TEXT, msg);
            try {
                activity.startActivity(messengerIntent);
                result.success("true");
            } catch (Exception ex) {
                if (openMarket) {
                    this.openMarket("com.facebook.orca");
                    result.success("false: Messenger app is not installed on your device");
                 } else {
                    result.success("false: Messenger app is not installed on your device");
                }
            }
        } catch (Exception var9) {
            result.error("error", var9.toString(), "");
        }
    }

    /** 
     * share to Messenger
     *
     * @param msg                String
     * @param result             Result
     */
    private void shareToLine(String msg, boolean openMarket, Result result) {
        try {
            Intent lineIntent = new Intent(Intent.ACTION_SEND);
            lineIntent.setType("text/plain");
            lineIntent.setPackage("jp.naver.line.android");
            lineIntent.putExtra(Intent.EXTRA_TEXT, msg);
            try {
                activity.startActivity(lineIntent);
                result.success("true");
            } catch (Exception ex) {
                if (openMarket) {
                    this.openMarket("jp.naver.line.android");
                    result.success("false: LINE app is not installed on your device");
                 } else {
                    result.success("false: LINE app is not installed on your device");
                }
            }
        } catch (Exception var9) {
            result.error("error", var9.toString(), "");
        }
    }

    /** 
     * share to BeeBush
     *
     * @param url                String
     * @param result             Result
     */
    private void shareToBeeBush(String url, boolean openMarket, Result result) {
        try {
            Intent beeBushIntent = new Intent(Intent.ACTION_SEND);
            beeBushIntent.setType("text/plain");
            beeBushIntent.setPackage("com.beebush");
            beeBushIntent.putExtra(Intent.EXTRA_TEXT, url);
            try {
                activity.startActivity(beeBushIntent);
                result.success("true");
            } catch (Exception ex) {
                if (openMarket) {
                    this.openMarket("com.beebush");
                    result.success("false: BeeBush app is not installed on your device");
                 } else {
                    result.success("false: BeeBush app is not installed on your device");
                }
            }
        } catch (Exception var9) {
            result.error("error", var9.toString(), "");
        }
    }

    /**
     * share whatsapp message to personal number
     *
     * @param msg         String
     * @param phoneNumber String with country code
     * @param result
     */
    private void shareWhatsAppPersonal(String msg, String phoneNumber, Result result) {
        String url = null;
        try {
            url = "https://api.whatsapp.com/send?phone=" + phoneNumber + "&text=" + URLEncoder.encode(msg, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        Intent i = new Intent(Intent.ACTION_VIEW);
        i.setPackage("com.whatsapp");
        i.setData(Uri.parse(url));
        activity.startActivity(i);
        result.success("success");
    }

    /**
     * share to instagram
     *
     * @param url    local image path
     * @param result flutterResult
     */
    private void shareInstagramStory(String url, boolean openMarket, Result result) {
        if (instagramInstalled()) {
            File file = new File(url);
            Uri fileUri = FileProvider.getUriForFile(activity, activity.getApplicationContext().getPackageName() + ".provider", file);

            Intent instagramIntent = new Intent(Intent.ACTION_SEND);
            instagramIntent.setType("image/*");
            instagramIntent.putExtra(Intent.EXTRA_STREAM, fileUri);
            instagramIntent.setPackage(INSTAGRAM_PACKAGE_NAME);
            try {
                activity.startActivity(instagramIntent);
                result.success("Success");
            } catch (ActivityNotFoundException e) {
                e.printStackTrace();
                result.success("Failure");
            }
        } else {
            if (openMarket) {
                this.openMarket(INSTAGRAM_PACKAGE_NAME);
                result.error("Instagram not found", "Instagram is not installed on device.", "");
             } else {
                result.error("Instagram not found", "Instagram is not installed on device.", "");
            }
            
        }
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {

    }

    ///Utils methods
    private boolean instagramInstalled() {
        try {
            if (activity != null) {
                activity.getPackageManager()
                        .getApplicationInfo(INSTAGRAM_PACKAGE_NAME, 0);
                return true;
            } else {
                Log.d("App", "Instagram app is not installed on your device");
                return false;
            }
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
//        return false;
    }

    /// Mở chợ khi chưa cài app
    private void openMarket(String appId){
         if (activity != null) {
            try {
                activity.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + appId)));
            } catch (android.content.ActivityNotFoundException anfe) {
                activity.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=" + appId)));
            }
        }
    }
    private void openPlayStore(String packageName) {
        try {
            final Uri playStoreUri = Uri.parse("market://details?id=" + packageName);
            final Intent intent = new Intent(Intent.ACTION_VIEW, playStoreUri);
            activity.startActivity(intent);
        } catch (ActivityNotFoundException e) {
            final Uri playStoreUri = Uri.parse("https://play.google.com/store/apps/details?id=" + packageName);
            final Intent intent = new Intent(Intent.ACTION_VIEW, playStoreUri);
            activity.startActivity(intent);
        }
    }
}
