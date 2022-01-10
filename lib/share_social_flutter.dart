import 'package:flutter/services.dart';

import 'file_type.dart';
import 'dart:io' show Platform;

//export file type enum
export 'package:share_social_flutter/file_type.dart';

typedef Future<dynamic> OnCancelHandler();
typedef Future<dynamic> OnErrorHandler(dynamic error);
typedef Future<dynamic> OnSuccessHandler(dynamic postId);

class FlutterShareSocial {
  final MethodChannel _channel = const MethodChannel('share_social_flutter');

  static const String _methodWhatsApp = 'whatsapp_share';
  static const String _methodWhatsAppPersonal = 'whatsapp_personal';
  static const String _methodWhatsAppBusiness = 'whatsapp_business_share';
  static const String _methodFaceBook = 'facebook_share';
  static const String _methodTwitter = 'twitter_share';
  static const String _methodTwitterTweet = 'twitter_share_tweet';
  static const String _methodInstagramShare = 'instagram_share';
  static const String _methodSystemShare = 'system_share';
  static const String _methodTelegramShare = 'telegram_share';
  static const String _methodMessengerShare = 'messenger_share';
  static const String _methodLineShare = 'line_share';
  static const String _methodBeeBushShare = 'beebush_share';

  ///share to WhatsApp
  /// [imagePath] is local image
  /// [phoneNumber] enter phone number with counry code
  /// For ios
  /// If include image then text params will be ingored as there is no current way in IOS share both at the same.
  Future<String?> shareToWhatsApp({
    String msg = '',
    String imagePath = '',
    FileType? fileType = FileType.image,
    bool openMarket = true,
    OnSuccessHandler? onSuccess,
    OnCancelHandler? onCancel,
    OnErrorHandler? onError,
  }) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => imagePath);
    arguments.putIfAbsent('openMarket', () => openMarket);
    if (fileType == FileType.image) {
      arguments.putIfAbsent('fileType', () => 'image');
    } else {
      arguments.putIfAbsent('fileType', () => 'video');
    }

    String? result;
    try {
      result = await _channel.invokeMethod<String>(_methodWhatsApp, arguments);
      _channel.setMethodCallHandler((call) {
        switch (call.method) {
          case "onSuccess":
            return onSuccess!(call.arguments);
          case "onCancel":
            return onCancel!();
          case "onError":
            return onError!(call.arguments);
          default:
            throw UnsupportedError("Unknown method called");
        }
      });
    } catch (e) {
      return e.toString();
    }

    return result;
  }

  ///share to WhatsApp
  /// [phoneNumber] phone number with counry code
  /// [msg] message text you want on whatsapp
  Future<String?> shareWhatsAppPersonalMessage({
    required String message,
    required String phoneNumber,
    bool openMarket = true,
    OnSuccessHandler? onSuccess,
    OnCancelHandler? onCancel,
    OnErrorHandler? onError,
  }) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => message);
    arguments.putIfAbsent('phoneNumber', () => phoneNumber);
    arguments.putIfAbsent('openMarket', () => openMarket);

    String? result;
    try {
      result = await _channel.invokeMethod<String>(
          _methodWhatsAppPersonal, arguments);
      _channel.setMethodCallHandler((call) {
        switch (call.method) {
          case "onSuccess":
            return onSuccess!(call.arguments);
          case "onCancel":
            return onCancel!();
          case "onError":
            return onError!(call.arguments);
          default:
            throw UnsupportedError("Unknown method called");
        }
      });
    } catch (e) {
      return e.toString();
    }

    return result;
  }

  ///share to WhatsApp4Biz
  ///[imagePath] is local image
  /// For ios
  /// If include image then text params will be ingored as there is no current way in IOS share both at the same.
  Future<String?> shareToWhatsApp4Biz({
    String msg = '',
    String? imagePath = '',
    bool openMarket = true,
    OnSuccessHandler? onSuccess,
    OnCancelHandler? onCancel,
    OnErrorHandler? onError,
  }) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};

    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => imagePath);
    arguments.putIfAbsent('openMarket', () => openMarket);

    String? result;
    try {
      result = await _channel.invokeMethod<String>(
          _methodWhatsAppBusiness, arguments);
      _channel.setMethodCallHandler((call) {
        switch (call.method) {
          case "onSuccess":
            return onSuccess!(call.arguments);
          case "onCancel":
            return onCancel!();
          case "onError":
            return onError!(call.arguments);
          default:
            throw UnsupportedError("Unknown method called");
        }
      });
    } catch (e) {
      return 'false';
    }

    return result;
  }

  ///share to Telegram
  /// [msg] message text you want on telegram
  Future<String?> shareToTelegram({
    required String msg,
    bool openMarket = true,
    OnSuccessHandler? onSuccess,
    OnCancelHandler? onCancel,
    OnErrorHandler? onError,
  }) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('openMarket', () => openMarket);
    String? result;
    try {
      result =
          await _channel.invokeMethod<String>(_methodTelegramShare, arguments);
      _channel.setMethodCallHandler((call) {
        switch (call.method) {
          case "onSuccess":
            return onSuccess!(call.arguments);
          case "onCancel":
            return onCancel!();
          case "onError":
            return onError!(call.arguments);
          default:
            throw UnsupportedError("Unknown method called");
        }
      });
    } catch (e) {
      return e.toString();
    }
    return result;
  }

  ///share to facebook
  Future<String?> shareToFacebook({
    required String msg,
    String url = '',
    bool openMarket = true,
    OnSuccessHandler? onSuccess,
    OnCancelHandler? onCancel,
    OnErrorHandler? onError,
  }) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    arguments.putIfAbsent('openMarket', () => openMarket);

    String? result;
    try {
      result = await _channel.invokeMethod<String?>(_methodFaceBook, arguments);
      _channel.setMethodCallHandler((call) {
        switch (call.method) {
          case "onSuccess":
            return onSuccess!(call.arguments);
          case "onCancel":
            return onCancel!();
          case "onError":
            return onError!(call.arguments);
          default:
            throw UnsupportedError("Unknown method called");
        }
      });
    } catch (e) {
      return e.toString();
    }
    return result;
  }

  ///share to twitter
  ///[msg] string that you want share.
  ///
  ///
  ///
  Future<String?> shareToTwitter({
    required String msg,
    String url = '',
    bool openMarket = true,
    OnSuccessHandler? onSuccess,
    OnCancelHandler? onCancel,
    OnErrorHandler? onError,
  }) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    arguments.putIfAbsent('openMarket', () => openMarket);

    String? result;
    try {
      result = await _channel.invokeMethod(_methodTwitter, arguments);
      _channel.setMethodCallHandler((call) {
        switch (call.method) {
          case "onSuccess":
            return onSuccess!(call.arguments);
          case "onCancel":
            return onCancel!();
          case "onError":
            return onError!(call.arguments);
          default:
            throw UnsupportedError("Unknown method called");
        }
      });
    } catch (e) {
      return e.toString();
    }
    return result;
  }

  ///share file to instagram
  Future<String?> shareToInstagram({
    required String imagePath,
    FileType fileType = FileType.image,
    bool openMarket = true,
    OnSuccessHandler? onSuccess,
    OnCancelHandler? onCancel,
    OnErrorHandler? onError,
  }) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('url', () => imagePath);
    arguments.putIfAbsent('openMarket', () => openMarket);
    if (fileType == FileType.image) {
      arguments.putIfAbsent('fileType', () => 'image');
    } else {
      arguments.putIfAbsent('fileType', () => 'video');
    }
    String? result;

    try {
      result =
          await _channel.invokeMethod<String>(_methodInstagramShare, arguments);
      _channel.setMethodCallHandler((call) {
        switch (call.method) {
          case "onSuccess":
            return onSuccess!(call.arguments);
          case "onCancel":
            return onCancel!();
          case "onError":
            return onError!(call.arguments);
          default:
            throw UnsupportedError("Unknown method called");
        }
      });
    } catch (e) {
      return e.toString();
    }
    return result;
  }

  Future<String?> shareToMessenger({
    required String msg,
    String? url,
    bool openMarket = true,
    OnSuccessHandler? onSuccess,
    OnCancelHandler? onCancel,
    OnErrorHandler? onError,
  }) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    arguments.putIfAbsent('openMarket', () => openMarket);

    String? result;
    try {
      result = await _channel.invokeMethod(_methodMessengerShare, arguments);
      _channel.setMethodCallHandler((call) {
        switch (call.method) {
          case "onSuccess":
            return onSuccess!(call.arguments);
          case "onCancel":
            return onCancel!();
          case "onError":
            return onError!(call.arguments);
          default:
            throw UnsupportedError("Unknown method called");
        }
      });
    } catch (e) {
      return e.toString();
    }
    return result;
  }

  Future<String?> shareToLine({
    required String msg,
    bool openMarket = true,
    OnSuccessHandler? onSuccess,
    OnCancelHandler? onCancel,
    OnErrorHandler? onError,
  }) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('openMarket', () => openMarket);
    String? result;
    try {
      result = await _channel.invokeMethod(_methodLineShare, arguments);
      _channel.setMethodCallHandler((call) {
        switch (call.method) {
          case "onSuccess":
            return onSuccess!(call.arguments);
          case "onCancel":
            return onCancel!();
          case "onError":
            return onError!(call.arguments);
          default:
            throw UnsupportedError("Unknown method called");
        }
      });
    } catch (e) {
      return e.toString();
    }
    return result;
  }

  Future<String?> shareToBeeBush({
    required String url,
    bool openMarket = true,
    OnSuccessHandler? onSuccess,
    OnCancelHandler? onCancel,
    OnErrorHandler? onError,
  }) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('url', () => url);
    arguments.putIfAbsent('openMarket', () => openMarket);
    String? result;
    try {
      result = await _channel.invokeMethod(_methodBeeBushShare, arguments);
      _channel.setMethodCallHandler((call) {
        switch (call.method) {
          case "onSuccess":
            return onSuccess!(call.arguments);
          case "onCancel":
            return onCancel!();
          case "onError":
            return onError!(call.arguments);
          default:
            throw UnsupportedError("Unknown method called");
        }
      });
    } catch (e) {
      return e.toString();
    }
    return result;
  }

  ///use system share ui
  Future<String?> shareToSystem({
    required String msg,
    OnSuccessHandler? onSuccess,
    OnCancelHandler? onCancel,
    OnErrorHandler? onError,
  }) async {
    String? result;
    try {
      result =
          await _channel.invokeMethod<String>(_methodSystemShare, {'msg': msg});
      _channel.setMethodCallHandler((call) {
        switch (call.method) {
          case "onSuccess":
            return onSuccess!(call.arguments);
          case "onCancel":
            return onCancel!();
          case "onError":
            return onError!(call.arguments);
          default:
            throw UnsupportedError("Unknown method called");
        }
      });
    } catch (e) {
      return 'false';
    }
    return result;
  }
}
