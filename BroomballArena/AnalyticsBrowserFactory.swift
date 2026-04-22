import Foundation
import WebKit

public enum AnalyticsBrowserFactory {
    public static func makeConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        return configuration
    }

    public static func prewarm(url: URL, timeout: TimeInterval = 8) {
        let webView = WKWebView(frame: .zero, configuration: makeConfiguration())
        webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeout))
    }
}
