import 'package:flutter/services.dart';

import 'file_type.dart';

//export file type enum
export 'package:midas_share/file_type.dart';

typedef Future<dynamic> OnCancelHandler();
typedef Future<dynamic> OnErrorHandler(dynamic error);
typedef Future<dynamic> OnSuccessHandler(dynamic postId);

class FlutterMidasShare {
  final MethodChannel _channel = const MethodChannel('midas_share');

  static const String _methodWhatsApp = 'whatsapp_share';
  static const String _methodWhatsAppPersonal = 'whatsapp_personal';
  static const String _methodWhatsAppBusiness = 'whatsapp_business_share';
  static const String _methodFaceBook = 'facebook_share';
  static const String _methodTwitter = 'twitter_share';
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
  Future<String?> shareToWhatsApp(
      {String msg = '',
      String imagePath = '',
      FileType? fileType = FileType.image}) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => imagePath);
    if (fileType == FileType.image) {
      arguments.putIfAbsent('fileType', () => 'image');
    } else {
      arguments.putIfAbsent('fileType', () => 'video');
    }

    String? result;
    try {
      result = await _channel.invokeMethod<String>(_methodWhatsApp, arguments);
    } catch (e) {
      return e.toString();
    }

    return result;
  }

  ///share to WhatsApp
  /// [phoneNumber] phone number with counry code
  /// [msg] message text you want on whatsapp
  Future<String?> shareWhatsAppPersonalMessage(
      {required String message, required String phoneNumber}) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => message);
    arguments.putIfAbsent('phoneNumber', () => phoneNumber);

    String? result;
    try {
      result = await _channel.invokeMethod<String>(
          _methodWhatsAppPersonal, arguments);
    } catch (e) {
      return e.toString();
    }

    return result;
  }

  ///share to Telegram
  /// [msg] message text you want on telegram
  Future<String?> shareToTelegram(
      {required String msg, bool openMarket = true}) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('openMarket', () => openMarket);
    String? result;
    try {
      result =
          await _channel.invokeMethod<String>(_methodTelegramShare, arguments);
    } catch (e) {
      return e.toString();
    }
    return result;
  }

  ///share to WhatsApp4Biz
  ///[imagePath] is local image
  /// For ios
  /// If include image then text params will be ingored as there is no current way in IOS share both at the same.
  Future<String?> shareToWhatsApp4Biz(
      {String msg = '', String? imagePath = ''}) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};

    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => imagePath);
    String? result;
    try {
      result = await _channel.invokeMethod<String>(
          _methodWhatsAppBusiness, arguments);
    } catch (e) {
      return 'false';
    }

    return result;
  }

  ///share to facebook
  Future<String?> shareToFacebook({
    required String msg,
    String url = '',
    OnSuccessHandler ?onSuccess,
    OnCancelHandler ?onCancel,
    OnErrorHandler ?onError,
  }) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    String? result;
    try {
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
      result = await _channel.invokeMethod<String?>(_methodFaceBook, arguments);
    } catch (e) {
      return e.toString();
    }
    return result;
  }

  ///share to twitter
  ///[msg] string that you want share.
  Future<String?> shareToTwitter({required String msg, String url = ''}) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    String? result;
    try {
      result = await _channel.invokeMethod(_methodTwitter, arguments);
    } catch (e) {
      return e.toString();
    }
    return result;
  }

  ///use system share ui
  Future<String?> shareToSystem({required String msg}) async {
    String? result;
    try {
      result =
          await _channel.invokeMethod<String>(_methodSystemShare, {'msg': msg});
    } catch (e) {
      return 'false';
    }
    return result;
  }

  ///share file to instagram
  Future<String?> shareToInstagram(
      {required String imagePath, bool openMarket = true}) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('url', () => imagePath);
    arguments.putIfAbsent('openMarket', () => openMarket);
    String? result;

    try {
      result =
          await _channel.invokeMethod<String>(_methodInstagramShare, arguments);
    } catch (e) {
      return e.toString();
    }
    return result;
  }

  Future<String?> shareToMessenger(
      {required String msg, bool openMarket = true}) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('openMarket', () => openMarket);
    String? result;
    try {
      result = await _channel.invokeMethod(_methodMessengerShare, arguments);
    } catch (e) {
      return e.toString();
    }
    return result;
  }

  Future<String?> shareToLine(
      {required String msg, bool openMarket = true}) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('openMarket', () => openMarket);
    String? result;
    try {
      result = await _channel.invokeMethod(_methodLineShare, arguments);
    } catch (e) {
      return e.toString();
    }
    return result;
  }

  Future<String?> shareToBeeBush(
      {required String url, bool openMarket = true}) async {
    final Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent('url', () => url);
    arguments.putIfAbsent('openMarket', () => openMarket);
    String? result;
    try {
      result = await _channel.invokeMethod(_methodBeeBushShare, arguments);
    } catch (e) {
      return e.toString();
    }
    return result;
  }
}
