import SwiftUI
import UniformTypeIdentifiers
import WebKit

public struct RoobWebRenderer: UIViewRepresentable {
    public let config: RoobLaunchConfig
    @ObservedObject public var model: RoobWebSurfaceModel

    public init(config: RoobLaunchConfig, model: RoobWebSurfaceModel) {
        self.config = config
        self.model = model
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(model: model, sessionStore: RoobWebSessionStore(storageKey: config.resumeStorageKey))
    }

    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: RoobWebFactory.makeConfiguration())
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.keyboardDismissMode = .interactive
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        model.webView = webView

        let sessionStore = RoobWebSessionStore(storageKey: config.resumeStorageKey)
        let startURL = sessionStore.savedURL(forEntryURL: config.initialURL) ?? config.initialURL
        sessionStore.save(entryURL: config.initialURL)
        webView.load(URLRequest(url: startURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: config.requestTimeout))
        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
    }

    public final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, UIDocumentPickerDelegate {
        private let model: RoobWebSurfaceModel
        private let sessionStore: RoobWebSessionStore
        private var fileSelectionHandler: (([URL]?) -> Void)?

        init(model: RoobWebSurfaceModel, sessionStore: RoobWebSessionStore) {
            self.model = model
            self.sessionStore = sessionStore
        }

        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            Task { @MainActor in
                model.isLoading = true
                model.errorMessage = nil
                model.refreshNavigationState()
            }
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            Task { @MainActor in
                model.isLoading = false
                model.refreshNavigationState()
                sessionStore.save(url: webView.url)
            }
        }

        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            Task { @MainActor in
                model.isLoading = false
                model.errorMessage = error.localizedDescription
                model.refreshNavigationState()
            }
        }

        public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            Task { @MainActor in
                model.isLoading = false
                model.errorMessage = error.localizedDescription
                model.refreshNavigationState()
            }
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
            if navigationAction.request.url?.scheme == "about" {
                return .cancel
            }
            return .allow
        }

        public func webView(
            _ webView: WKWebView,
            createWebViewWith configuration: WKWebViewConfiguration,
            for navigationAction: WKNavigationAction,
            windowFeatures: WKWindowFeatures
        ) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }

        @available(iOS 18.4, *)
        public func webView(
            _ webView: WKWebView,
            runOpenPanelWith parameters: WKOpenPanelParameters,
            initiatedByFrame frame: WKFrameInfo,
            completionHandler: @escaping ([URL]?) -> Void
        ) {
            fileSelectionHandler?(nil)
            fileSelectionHandler = completionHandler

            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
            picker.delegate = self
            picker.allowsMultipleSelection = parameters.allowsMultipleSelection
            picker.modalPresentationStyle = .formSheet

            guard let presenter = webView.roobTopViewController() else {
                fileSelectionHandler = nil
                completionHandler(nil)
                return
            }

            presenter.present(picker, animated: true)
        }

        public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            fileSelectionHandler?(nil)
            fileSelectionHandler = nil
        }

        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let copiedURLs = urls.compactMap { copyToTemporaryUploadDirectory($0) }
            fileSelectionHandler?(copiedURLs.isEmpty ? nil : copiedURLs)
            fileSelectionHandler = nil
        }

        private func copyToTemporaryUploadDirectory(_ sourceURL: URL) -> URL? {
            let didStartAccess = sourceURL.startAccessingSecurityScopedResource()
            defer {
                if didStartAccess {
                    sourceURL.stopAccessingSecurityScopedResource()
                }
            }

            let directoryURL = FileManager.default.temporaryDirectory
                .appendingPathComponent("roob-file-uploads", isDirectory: true)

            do {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
                let destinationURL = directoryURL
                    .appendingPathComponent(UUID().uuidString)
                    .appendingPathExtension(sourceURL.pathExtension)

                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                }

                try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                return destinationURL
            } catch {
                return nil
            }
        }
    }
}

private extension WKWebView {
    func roobTopViewController() -> UIViewController? {
        var topController = window?.rootViewController

        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }

        return topController
    }
}

@MainActor
public final class RoobWebSurfaceModel: ObservableObject {
    @Published public var isLoading = false
    @Published public var canGoBack = false
    @Published public var canGoForward = false
    @Published public var errorMessage: String?
    public weak var webView: WKWebView?

    public init() {}

    public func goBack() {
        guard webView?.canGoBack == true else { return }
        webView?.goBack()
        refreshNavigationState()
    }

    public func goForward() {
        guard webView?.canGoForward == true else { return }
        webView?.goForward()
        refreshNavigationState()
    }

    public func reload() {
        webView?.reload()
    }

    public func refreshNavigationState() {
        canGoBack = webView?.canGoBack ?? false
        canGoForward = webView?.canGoForward ?? false
    }
}
