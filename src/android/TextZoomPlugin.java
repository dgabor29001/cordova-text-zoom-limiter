package org.apache.cordova.textzoomlimiter;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.webkit.WebView;
import android.webkit.WebSettings;
import android.app.Activity;
import android.util.Log;
import android.os.Build;
import android.os.Looper;

public class TextZoomPlugin extends CordovaPlugin {
    
    private static final String TAG = "TextZoomPlugin";
    
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) 
            throws JSONException {
        
        switch(action) {
            case "getTextZoom":
                getTextZoom(callbackContext);
                return true;
                
            case "setTextZoomMax":
                int maxZoom = args.getInt(0);
                setTextZoomMax(maxZoom, callbackContext);
                return true;
                
            case "setTextZoom":
                int zoom = args.getInt(0);
                setTextZoom(zoom, callbackContext);
                return true;
                
            case "getPlatformInfo":
                getPlatformInfo(callbackContext);
                return true;
                
            default:
                return false;
        }
    }
    
    private void getTextZoom(CallbackContext callbackContext) {
        cordova.getActivity().runOnUiThread(() -> {
            try {
                WebView webView = findWebView(cordova.getActivity().getWindow().getDecorView());
                
                if (webView != null) {
                    WebSettings settings = webView.getSettings();
                    int textZoom = settings.getTextZoom();
                    
                    JSONObject result = new JSONObject();
                    result.put("textZoom", textZoom);
                    result.put("percentage", textZoom + "%");
                    result.put("platform", "android");
                    
                    Log.d(TAG, "Text Zoom actual: " + textZoom + "%");
                    callbackContext.success(result);
                } else {
                    callbackContext.error("WebView no encontrada");
                }
            } catch (Exception e) {
                Log.e(TAG, "Error al obtener zoom: " + e.getMessage());
                callbackContext.error("Error: " + e.getMessage());
            }
        });
    }
    
    
    private void setTextZoomMax(int maxZoom, CallbackContext callbackContext) {
        cordova.getActivity().runOnUiThread(() -> {
            try {
                WebView webView = findWebView(cordova.getActivity().getWindow().getDecorView());
                
                if (webView != null) {
                    WebSettings settings = webView.getSettings();
                    int currentZoom = settings.getTextZoom();
                    
                    if (currentZoom > maxZoom) {
                        settings.setTextZoom(maxZoom);
                        Log.d(TAG, "Zoom limitado: " + currentZoom + "% → " + maxZoom + "%");
                    }
                    
                    JSONObject result = new JSONObject();
                    result.put("appliedZoom", Math.min(currentZoom, maxZoom));
                    result.put("previousZoom", currentZoom);
                    result.put("maxZoom", maxZoom);
                    result.put("platform", "android");
                    
                    callbackContext.success(result);
                } else {
                    callbackContext.error("WebView no encontrada");
                }
            } catch (Exception e) {
                Log.e(TAG, "Error al limitar zoom: " + e.getMessage());
                callbackContext.error("Error: " + e.getMessage());
            }
        });
    }
    
    private void setTextZoom(int zoom, CallbackContext callbackContext) {
        cordova.getActivity().runOnUiThread(() -> {
            try {
                WebView webView = findWebView(cordova.getActivity().getWindow().getDecorView());
                
                if (webView != null) {
                    WebSettings settings = webView.getSettings();
                    // Limitar a rango válido (50-200)
                    int limitedZoom = Math.max(50, Math.min(200, zoom));
                    settings.setTextZoom(limitedZoom);
                    
                    JSONObject result = new JSONObject();
                    result.put("textZoom", limitedZoom);
                    result.put("message", "Zoom establecido a: " + limitedZoom + "%");
                    result.put("platform", "android");
                    
                    Log.d(TAG, "Zoom establecido a: " + limitedZoom + "%");
                    callbackContext.success(result);
                } else {
                    callbackContext.error("WebView no encontrada");
                }
            } catch (Exception e) {
                Log.e(TAG, "Error al establecer zoom: " + e.getMessage());
                callbackContext.error("Error: " + e.getMessage());
            }
        });
    }
    
    private void getPlatformInfo(CallbackContext callbackContext) {
        try {
            JSONObject result = new JSONObject();
            result.put("platform", "android");
            result.put("version", Build.VERSION.RELEASE);
            result.put("sdkInt", Build.VERSION.SDK_INT);
            
            callbackContext.success(result);
        } catch (Exception e) {
            callbackContext.error("Error: " + e.getMessage());
        }
    }
    
    private WebView findWebView(android.view.View view) {
        if (view instanceof WebView) {
            return (WebView) view;
        }
        if (view instanceof android.view.ViewGroup) {
            android.view.ViewGroup group = (android.view.ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) {
                WebView found = findWebView(group.getChildAt(i));
                if (found != null) {
                    return found;
                }
            }
        }
        return null;
    }
}
