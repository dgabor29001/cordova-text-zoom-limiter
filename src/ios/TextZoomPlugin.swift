import UIKit
import WebKit

@objc(TextZoomPlugin)
class TextZoomPlugin: CDVPlugin {
    
    override func pluginInitialize() {
        print("TextZoomPlugin initialized for iOS")
    }
    
    // MARK: - Public Methods
    
    @objc(getTextZoom:)
    func getTextZoom(command: CDVInvokedUrlCommand) {
        let webView = getWebView()
        
        if let webView = webView as? WKWebView {
            getTextZoomFromWKWebView(webView, command: command)
        } else {
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "WebView no disponible")
            self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
        }
    }
    
    @objc(setTextZoomMax:)
    func setTextZoomMax(command: CDVInvokedUrlCommand) {
        guard let maxZoom = command.arguments[0] as? Int else {
            let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Argumento inválido")
            self.commandDelegate?.send(result, callbackId: command.callbackId)
            return
        }
        
        let webView = getWebView()
        
        if let webView = webView as? WKWebView {
            setTextZoomMaxWKWebView(webView, maxZoom: maxZoom, command: command)
        } else {
            let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "WebView no disponible")
            self.commandDelegate?.send(result, callbackId: command.callbackId)
        }
    }
    
    @objc(setTextZoom:)
    func setTextZoom(command: CDVInvokedUrlCommand) {
        guard let zoom = command.arguments[0] as? Int else {
            let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Argumento inválido")
            self.commandDelegate?.send(result, callbackId: command.callbackId)
            return
        }
        
        let webView = getWebView()
        
        if let webView = webView as? WKWebView {
            setTextZoomWKWebView(webView, zoom: zoom, command: command)
        } else {
            let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "WebView no disponible")
            self.commandDelegate?.send(result, callbackId: command.callbackId)
        }
    }
    
    @objc(getPlatformInfo:)
    func getPlatformInfo(command: CDVInvokedUrlCommand) {
        let device = UIDevice.current
        
        var result: [String: Any] = [
            "platform": "ios",
            "version": device.systemVersion,
            "model": device.model
        ]
        
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result)
        self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
    }
    
    // MARK: - Private Methods
    
    private func getWebView() -> UIView? {
        return self.webViewEngine?.engineWebView
    }
    
    private func getTextZoomFromWKWebView(_ webView: WKWebView, command: CDVInvokedUrlCommand) {
        webView.evaluateJavaScript("document.documentElement.style.fontSize") { (result, error) in
            if let fontSize = result as? String {
                let zoomPercentage = self.parseZoomPercentage(fontSize)
                
                var response: [String: Any] = [
                    "textZoom": zoomPercentage,
                    "percentage": "\(zoomPercentage)%",
                    "platform": "ios"
                ]
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response)
                self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
            } else if let error = error {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription)
                self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
            }
        }
    }
    
    private func setTextZoomMaxWKWebView(_ webView: WKWebView, maxZoom: Int, command: CDVInvokedUrlCommand) {
        let maxZoomDecimal = Double(maxZoom) / 100.0
        
        webView.evaluateJavaScript("document.documentElement.style.fontSize") { (result, _) in
            let currentSize = result as? String ?? "16px"
            let currentZoom = self.parseZoomPercentage(currentSize)
            
            var appliedZoom = currentZoom
            
            if currentZoom > maxZoom {
                appliedZoom = maxZoom
                let scaledFontSize = 16 * maxZoomDecimal
                let javascript = "document.documentElement.style.fontSize = '\(scaledFontSize)px';"
                
                webView.evaluateJavaScript(javascript) { (_, _) in
                    var response: [String: Any] = [
                        "appliedZoom": appliedZoom,
                        "previousZoom": currentZoom,
                        "maxZoom": maxZoom,
                        "platform": "ios"
                    ]
                    
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response)
                    self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
                }
            } else {
                var response: [String: Any] = [
                    "appliedZoom": appliedZoom,
                    "previousZoom": currentZoom,
                    "maxZoom": maxZoom,
                    "platform": "ios"
                ]
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response)
                self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
            }
        }
    }
    
    private func setTextZoomWKWebView(_ webView: WKWebView, zoom: Int, command: CDVInvokedUrlCommand) {
        let zoomDecimal = Double(zoom) / 100.0
        let scaledFontSize = 16 * zoomDecimal
        let javascript = "document.documentElement.style.fontSize = '\(scaledFontSize)px';"
        
        webView.evaluateJavaScript(javascript) { (_, error) in
            if error == nil {
                var response: [String: Any] = [
                    "textZoom": zoom,
                    "message": "Zoom establecido a: \(zoom)%",
                    "platform": "ios"
                ]
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response)
                self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
            } else if let error = error {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription)
                self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
            }
        }
    }
    
    private func parseZoomPercentage(_ fontSize: String) -> Int {
        let cleaned = fontSize.replacingOccurrences(of: "px", with: "").trimmingCharacters(in: .whitespaces)
        if let value = Double(cleaned) {
            return Int((value / 16.0) * 100)
        }
        return 100
    }
}
