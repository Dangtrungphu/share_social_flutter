import Flutter
import UIKit
import FBSDKShareKit
import PhotosUI
public class SwiftFlutterShareSocialPlugin: NSObject, FlutterPlugin, SharingDelegate {
    
    
    let _methodWhatsApp = "whatsapp_share";
    let _methodWhatsAppPersonal = "whatsapp_personal";
    let _methodWhatsAppBusiness = "whatsapp_business_share";
    let _methodFaceBook = "facebook_share";
    let _methodTwitter = "twitter_share";
    let _methodInstagram = "instagram_share";
    let _methodSystemShare = "system_share";
    let _methodTelegramShare = "telegram_share";
    let _methodMessengerShare = "messenger_share";
    let _methodLineShare = "line_share";
    let _methodBeeBushShare = "beebush_share";


    let id_whatsapp = "whatsapp-messenger/id310633997"
    let id_whatsapp_business = "whatsapp-business/id1386412985"
    let id_facebook = "facebook/id284882215"
    let id_twitter = "twitter/id333903271"
    let id_instagram = "instagram/id389801252"
    let id_telegram = "telegram-messenger/id686449807"
    let id_messenger = "messenger/id454638411"
    let id_line = "line/id443904275"
    let id_beebush = "bee-bush/id1450471409"
    
    var result: FlutterResult?
    var documentInteractionController: UIDocumentInteractionController?
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "share_social_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterShareSocialPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        if(call.method.elementsEqual(_methodWhatsApp)){
            let args = call.arguments as? Dictionary<String,Any>
            
            if args!["url"] as! String == "" {
                // if don't pass url then pass blank so if can strat normal whatsapp
                shareWhatsApp(message: args!["msg"] as! String,imageUrl: "",type: args!["fileType"] as! String,result: result)
            }else{
                // if user pass url then use that
                shareWhatsApp(message: args!["msg"] as! String,imageUrl: args!["url"] as! String,type: args!["fileType"] as! String,result: result)
            }
            
        }
        else if(call.method.elementsEqual(_methodWhatsAppBusiness)){
            
            // There is no way to open WB in IOS.
            result(FlutterMethodNotImplemented)
            
            //            let args = call.arguments as? Dictionary<String,Any>
            //
            //            if args!["url"]as! String == "" {
            //                // if don't pass url then pass blank so if can strat normal whatsapp
            //                shareWhatsApp4Biz(message: args!["msg"] as! String, result: result)
            //            }else{
            //                // if user pass url then use that
            //                // wil open share sheet and user can select open for there.
            //                //                shareWhatsApp(message: args!["msg"] as! String,imageUrl: args!["url"] as! String,result: result)
            //            }
        }
        else if(call.method.elementsEqual(_methodWhatsAppPersonal)){
            let args = call.arguments as? Dictionary<String,Any>
            shareWhatsAppPersonal(message: args!["msg"]as! String, phoneNumber: args!["phoneNumber"]as! String, result: result)
        }
        else if(call.method.elementsEqual(_methodFaceBook)){
            let args = call.arguments as? Dictionary<String,Any>
            sharefacebook(message: args!, result: result)
            
        }else if(call.method.elementsEqual(_methodTwitter)){
            let args = call.arguments as? Dictionary<String,Any>
            shareTwitter(message: args!["msg"] as! String, url: args!["url"] as! String, result: result)
        }
        else if(call.method.elementsEqual(_methodInstagram)){
            let args = call.arguments as? Dictionary<String,Any>
            shareInstagram(args: args!)
        }
        else if(call.method.elementsEqual(_methodTelegramShare)){
            let args = call.arguments as? Dictionary<String,Any>
            shareToTelegram(message: args!["msg"] as! String, result: result )
        }
        else if(call.method.elementsEqual(_methodMessengerShare)){
            let args = call.arguments as? Dictionary<String,Any>
            shareMessenger(message: args!["msg"] as! String, url: args!["url"] as! String, result: result)
        }
        else if(call.method.elementsEqual(_methodLineShare)){
            let args = call.arguments as? Dictionary<String,Any>
            shareToLine(message: args!["msg"] as! String, result: result )
        }
        else if(call.method.elementsEqual(_methodBeeBushShare)){
            let args = call.arguments as? Dictionary<String,Any>
            shareToBeeBush(url: args!["url"] as! String, result: result )
        }
        else{
            let args = call.arguments as? Dictionary<String,Any>
            systemShare(message: args!["msg"] as! String,result: result)
        }
    }
    
    
    func shareWhatsApp(message:String, imageUrl:String,type:String,result: @escaping FlutterResult)  {
        // @ For ios
        // we can't set both if you pass image then text will ignore
        var whatsURL = ""
        if(imageUrl==""){
            whatsURL = "whatsapp://send?text=\(message)"
        }else{
            whatsURL = "whatsapp://app"
        }
        
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        let whatsAppURL  = NSURL(string: whatsURL.addingPercentEncoding(withAllowedCharacters: characterSet)!)
        if UIApplication.shared.canOpenURL(whatsAppURL! as URL)
        {
            if(imageUrl==""){
                //mean user did not pass image url  so just got with text message
                result("Sucess");
                UIApplication.shared.openURL(whatsAppURL! as URL)
                
            }
            else{
                //this is whats app work around so will open system share and exclude other share types
                let viewController = UIApplication.shared.delegate?.window??.rootViewController
                let urlData:Data
                let filePath:URL
                if(type=="image"){
                    let image = UIImage(named: imageUrl)
                    if(image==nil){
                        result("File format not supported Please check the file.")
                        return;
                    }
                    urlData=(image?.jpegData(compressionQuality: 1.0))!
                    filePath=URL(fileURLWithPath:NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai")
                }else{
                    filePath=URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("video.m4v")
                    urlData = NSData(contentsOf: URL(fileURLWithPath: imageUrl))! as Data
                }
                
                let tempFile = filePath
                do{
                    try urlData.write(to: tempFile, options: .atomic)
                    // image to be share
                    let imageToShare = [tempFile]
                    
                    let activityVC = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
                    // we want to exlude most of the things so developer can see whatsapp only on system share sheet
                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop,UIActivity.ActivityType.message, UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.postToWeibo,UIActivity.ActivityType.print,UIActivity.ActivityType.openInIBooks,UIActivity.ActivityType.postToFlickr,UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.addToReadingList,UIActivity.ActivityType.copyToPasteboard,UIActivity.ActivityType.postToFacebook]
                    
                    viewController!.present(activityVC, animated: true, completion: nil)
                    result("Sucess");
                    
                }catch{
                    print(error)
                }
            }
            
        }
        else
        {
            openMarket(id: id_whatsapp)
            result(FlutterError(code: "Not found", message: "WhatsApp is not found", details: "WhatsApp not intalled or Check url scheme."));
        }
    }
    
    
    // Send whatsapp personal message
    // @ message
    // @ phone with contry code.
    func shareWhatsAppPersonal(message:String, phoneNumber:String,result: @escaping FlutterResult)  {
        
        let whatsURL = "whatsapp://send?phone=\(phoneNumber)&text=\(message)"
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        let whatsAppURL  = NSURL(string: whatsURL.addingPercentEncoding(withAllowedCharacters: characterSet)!)
        if UIApplication.shared.canOpenURL(whatsAppURL! as URL)
        {
            UIApplication.shared.openURL(whatsAppURL! as URL)
            result("Sucess");
        }else{
            openMarket(id: id_whatsapp)
            result(FlutterError(code: "Not found", message: "WhatsApp is not found", details: "WhatsApp not intalled or Check url scheme."));
        }
    }
    
    func shareWhatsApp4Biz(message:String, result: @escaping FlutterResult)  {
        let whatsApp = "https://wa.me/?text=\(message)"
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        
        let whatsAppURL  = NSURL(string: whatsApp.addingPercentEncoding(withAllowedCharacters: characterSet)!)
        if UIApplication.shared.canOpenURL(whatsAppURL! as URL)
        {
            result("Sucess");
            UIApplication.shared.openURL(whatsAppURL! as URL)
        }
        else
        {
            openMarket(id: id_whatsapp_business)
            result(FlutterError(code: "Not found", message: "WhatsAppBusiness is not found", details: "WhatsAppBusiness not intalled or Check url scheme."));
        }
    }
    // share twitter
    // params
    // @ map conting meesage and url
    
    func sharefacebook(message:Dictionary<String,Any>, result: @escaping FlutterResult)  {
        let viewController = UIApplication.shared.delegate?.window??.rootViewController
        //let shareDialog = ShareDialog()
        let shareContent = ShareLinkContent()
        shareContent.contentURL = URL.init(string: message["url"] as! String)!
        shareContent.quote = message["msg"] as? String
        
        let shareDialog = ShareDialog(fromViewController: viewController, content: shareContent, delegate: self)
        shareDialog.mode = .automatic
        shareDialog.show()
        result("Sucess")
        
    }

    // Share Messenger
    func shareMessenger(message:String, url:String, result: @escaping FlutterResult)  {
        let shareContent = ShareLinkContent()
        // shareContent.contentURL = URL.init(string: message["url"] as! String)!
        guard let url = URL(string: url) else {
            preconditionFailure("URL is invalid")
        }

        shareContent.contentURL = url
        shareContent.quote = message
        
        let shareDialog = MessageDialog(content: shareContent, delegate: self)
        shareDialog.show()
        result("Sucess")
    }
    // func shareMessenger(message:String, url:String, result: @escaping FlutterResult)  {
    //     let urlstring = url
    //     let quote = message
    //     let twitterUrl =  "fb-messenger-share-api://share?quote=\(quote)"
        
    //     let urlTextEscaped = urlstring.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    //     let url = URL(string: urlTextEscaped ?? "")
        
    //     let urlWithLink = twitterUrl + url!.absoluteString
        
    //     let escapedShareString = urlWithLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    //     // cast to an url
    //     let urlschme = URL(string: escapedShareString)
    //     // open in safari
    //     do {
    //         if UIApplication.shared.canOpenURL(urlschme! as URL){
    //             UIApplication.shared.openURL(urlschme!)
    //             result("Sucess")
    //         }else{
    //             openMarket(id: id_messenger)
    //             result(FlutterError(code: "Not found", message: "Messenger is not found", details: "Twitter not intalled or Check url scheme."));
                
    //         }
    //     }
        
    // }

    // share twitter params
    // @ message
    // @ url
    func shareTwitter(message:String,url:String, result: @escaping FlutterResult)  {
        let urlstring = url
        let twitterUrl =  "twitter://post?message=\(message)"
        
        let urlTextEscaped = urlstring.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url = URL(string: urlTextEscaped ?? "")
        
        let urlWithLink = twitterUrl + url!.absoluteString
        
        let escapedShareString = urlWithLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        // cast to an url
        let urlschme = URL(string: escapedShareString)
        // open in safari
        do {
            if UIApplication.shared.canOpenURL(urlschme! as URL){
                UIApplication.shared.openURL(urlschme!)
                result("Sucess")
            }else{
                openMarket(id: id_twitter)
                result(FlutterError(code: "Not found", message: "Twitter is not found", details: "Twitter not intalled or Check url scheme."));
                
            }
        }
        
    }
    //share via telegram
    //@ text that you want to share.
    func shareToTelegram(message: String,result: @escaping FlutterResult )
    {
        let telegram = "tg://msg?text=\(message)"
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        let telegramURL  = NSURL(string: telegram.addingPercentEncoding(withAllowedCharacters: characterSet)!)
        if UIApplication.shared.canOpenURL(telegramURL! as URL)
        {
            result("Sucess");
            UIApplication.shared.openURL(telegramURL! as URL)
        }
        else
        {
            openMarket(id: id_telegram)
            result(FlutterError(code: "Not found", message: "telegram is not found", details: "telegram not intalled or Check url scheme."));
        }
    
    }

    func shareToLine(message: String,result: @escaping FlutterResult )
    {
        let line = "line://msg?text=\(message)"
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        let lineURL  = NSURL(string: line.addingPercentEncoding(withAllowedCharacters: characterSet)!)
        if UIApplication.shared.canOpenURL(lineURL! as URL)
        {
            result("Sucess");
            UIApplication.shared.openURL(lineURL! as URL)
        }
        else
        {
            openMarket(id: id_line)
            result(FlutterError(code: "Not found", message: "LINE is not found", details: "LINE not intalled or Check url scheme."));
        }
    
    }

    func shareToBeeBush(url: String,result: @escaping FlutterResult )
    {
        let beebush = "beebush://msg?text=\(url)"
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        let beebushURL  = NSURL(string: beebush.addingPercentEncoding(withAllowedCharacters: characterSet)!)
        if UIApplication.shared.canOpenURL(beebushURL! as URL)
        {
            result("Sucess");
            UIApplication.shared.openURL(beebushURL! as URL)
        }
        else
        {
            openMarket(id: id_beebush)
            result(FlutterError(code: "Not found", message: "BeeBush is not found", details: "BeeBush not intalled or Check url scheme."));
        }
    
    }

    //share via system native dialog
    //@ text that you want to share.
    func systemShare(message:String,result: @escaping FlutterResult)  {
        // find the root view controller
        let viewController = UIApplication.shared.delegate?.window??.rootViewController
        
        // set up activity view controller
        // Here is the message for for sharing
        let objectsToShare = [message] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        /// if want to exlude anything then will add it for future support.
        //        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popup = activityVC.popoverPresentationController {
                popup.sourceView = viewController?.view
                popup.sourceRect = CGRect(x: (viewController?.view.frame.size.width)! / 2, y: (viewController?.view.frame.size.height)! / 4, width: 0, height: 0)
            }
        }
        viewController!.present(activityVC, animated: true, completion: nil)
        result("Sucess");
        
        
    }
    
    // share image via instagram stories.
    // @ args image url
    // func shareInstagram(args:Dictionary<String,Any>)  {
    //     let imageUrl=args["url"] as! String
    //     let image = UIImage(named: imageUrl)
    //     if(image==nil){
    //         self.result!("File format not supported Please check the file.")
    //         return;
    //     }
    //     guard let instagramURL = NSURL(string: "instagram://app") else {
    //         if let result = result {
    //             self.openMarket(id: self.id_instagram)
    //             self.result?("Instagram app is not installed on your device")
    //             result(false)
    //         }
    //         return
    //     }
    //     do{
    //         try PHPhotoLibrary.shared().performChangesAndWait {

    //             let request = PHAssetChangeRequest.creationRequestForAsset(from: image!)
    //             let assetId = request.placeholderForCreatedAsset?.localIdentifier
    //             let instShareUrl:String? = "instagram://library?LocalIdentifier=" + assetId!
                
    //             //Share image
    //             if UIApplication.shared.canOpenURL(instagramURL as URL) {
    //                 if let sharingUrl = instShareUrl {
    //                     if let urlForRedirect = NSURL(string: sharingUrl) {
    //                         if #available(iOS 10.0, *) {
    //                             UIApplication.shared.open(urlForRedirect as URL, options: [:], completionHandler: nil)
    //                         }
    //                         else{
    //                             UIApplication.shared.openURL(urlForRedirect as URL)
    //                         }
    //                     }
    //                     self.result?("Success")
    //                 }
    //             } else{
    //                 self.openMarket(id: self.id_instagram)
    //                 self.result?("Instagram app is not installed on your device")
    //             }
    //         }
        
    //     } catch {
    //         print("Fail")
    //     }
    // }

    func shareInstagram(args:Dictionary<String,Any>)  {
        let fileUrl=args["url"] as! String
        let type=args["fileType"] as! String

        var image:UIImage?
        var video:URL?

        var assetId:String?

        if(type == "image") {
            image = UIImage(named: fileUrl)
        } else if(type == "video") {
            video = URL(fileURLWithPath: fileUrl)
        }
        if(image==nil && video==nil){
            self.result!("File format not supported Please check the file.")
            return;
        }

        guard let instagramURL = NSURL(string: "instagram://app") else {
            if let result = result {
                self.openMarket(id: self.id_instagram)
                self.result?("Instagram app is not installed on your device")
                result(false)
            }
            return
        }
        do{
            try PHPhotoLibrary.shared().performChanges({
                var request:PHAssetChangeRequest?
                
                if(image != nil) {
                    request = PHAssetChangeRequest.creationRequestForAsset(from: image!)
                } else if (video != nil) {
                    request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: video!)
                }

                if(request==nil){
                    self.result!("An error occured while saving the file.")
                    return;
                }
                
                assetId = request!.placeholderForCreatedAsset?.localIdentifier

            }, completionHandler: { success, error in 
                DispatchQueue.main.async {
                    guard error == nil else {
                        // handle error
                        return
                    }
                    guard let assetId = assetId else {
                        // highly unlikely that it'll be nil,
                        // but you should handle this error just in case
                        return
                    }

                    let instShareUrl:String? = "instagram://library?LocalIdentifier=" + assetId

                    //Share image
                    if UIApplication.shared.canOpenURL(instagramURL as URL) {
                        if let sharingUrl = instShareUrl {
                            if let urlForRedirect = NSURL(string: sharingUrl) {
                                if #available(iOS 10.0, *) {
                                    // UIApplication.shared.open(urlForRedirect as URL, options: [:], completionHandler: nil)
                                    UIApplication.shared.openURL(urlForRedirect as URL)
                                }
                                else{
                                    UIApplication.shared.openURL(urlForRedirect as URL)
                                }
                            }
                            self.result?("Success")
                        }
                    } else{
                        self.openMarket(id: self.id_instagram)
                        self.result?("Instagram app is not installed on your device")
                    }
                }
            })
        } catch {
            print("Fail")
        }
    }

    // Mở sotre khi app chưa được cài
    public func openMarket(id:String){
        // let url = URL(string: "itms-apps://apple.com/app/" + id)
        // UIApplication.shared.open(url)
         let urlStr = "itms-apps://itunes.apple.com/app/\(id)?mt=8"
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
        }
    }
    
    //Facebook delegate methods
    public func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print("Share: Success")
        
    }
    
    public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Share: Fail")
        
    }
    
    public func sharerDidCancel(_ sharer: Sharing) {
        print("Share: Cancel")
    }
}
