import Flutter
import UIKit

@objc(FlutterPasteboardPlugin)
public class FlutterPasteboardPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "pasteboard", binaryMessenger: registrar.messenger())
    let instance = FlutterPasteboardPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  // public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
  //   result("iOS " + UIDevice.current.systemVersion)
  // }
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "image":
        image(result: result)
      case "files":
        files(result: result)
      case "writeFiles":
        if let arguments = call.arguments as? [String] {
          writeFiles(arguments, result: result)
        } else {
          result(FlutterError(code: "0", message: "arguments is not String list.", details: nil))
        }
      case "writeImage":
        if let data = call.arguments as? FlutterStandardTypedData {
            writeImageToPasteboard(data.data,isgif: 0, result: result)
        }
        else  if let arguments = call.arguments as? Dictionary<String, Any> {
            if(arguments.count > 1){
                let imagedata = arguments["image"] as? FlutterStandardTypedData
                if(imagedata != nil){
                    writeImageToPasteboard(imagedata!.data,isgif: arguments["gif"] as! Int , result: result)
                }
            }
            else{
              result(FlutterError(code: "0", message: "arguments is not data", details: nil))
            }
        }
        else {
          result(FlutterError(code: "0", message: "arguments is not data", details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    private func image(result: FlutterResult) {
      var data = UIPasteboard.general.data(forPasteboardType: "com.compuserve.gif")
      // print("=========data,",data as Any)
      var isGif = 0
      if(data == nil){
        let image = UIPasteboard.general.image
        data =  image?.pngData()
        // print("=========data222,",data as Any)
      }
      else{
        isGif = 1
      }
      if(data == nil){
        result(data)
      }
      else{
        result(["data": data!,"gif":isGif])
      }
    }

    private func files(result: FlutterResult) {
      result(nil)
    }

    private func writeFiles(_ files: [String], result: FlutterResult) {
      result(nil)
    }
    
    private func writeImageToPasteboard(_ data: Data, isgif: Int, result: FlutterResult) {
       if(isgif == 1){
           UIPasteboard.general.setData(data, forPasteboardType: "com.compuserve.gif")
       }
       else{
           let image = UIImage(data: data)
           UIPasteboard.general.image = image
       }
      
      result(nil)
    }
}

