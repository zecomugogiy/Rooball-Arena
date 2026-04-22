import SwiftUI

public struct AnalyticsSurfaceView: View {
    public let config: AnalyticsLaunchConfig
    @StateObject private var model = AnalyticsSurfaceModel()

    public init(config: AnalyticsLaunchConfig) {
        self.config = config
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                AnalyticsPresentationStyle.overlay
                    .ignoresSafeArea()

                AnalyticsContentRenderer(config: config, model: model)
                    .padding(.top, webContentTopInset(topInset: proxy.safeAreaInsets.top))
                    .ignoresSafeArea(edges: [.horizontal, .bottom])

                analyticsControls(topInset: proxy.safeAreaInsets.top, width: proxy.size.width)

                if model.isLoading {
                    ProgressView()
                        .tint(AnalyticsPresentationStyle.accent)
                        .padding(10)
                        .background(AnalyticsPresentationStyle.overlay.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .padding(.top, webContentTopInset(topInset: proxy.safeAreaInsets.top) + 16)
                }

                if let errorMessage = model.errorMessage {
                    VStack(spacing: 10) {
                        Text("Connection issue")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                        Button("Reload") {
                            model.reload()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AnalyticsPresentationStyle.accent)
                        .foregroundStyle(AnalyticsPresentationStyle.navy)
                    }
                    .padding(16)
                    .foregroundStyle(.white)
                    .background(AnalyticsPresentationStyle.overlay.opacity(0.92))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .padding(20)
                    .padding(.top, webContentTopInset(topInset: proxy.safeAreaInsets.top))
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            AnalyticsBrowserFactory.prewarm(url: config.initialURL, timeout: config.requestTimeout)
        }
    }

    private func webContentTopInset(topInset: CGFloat) -> CGFloat {
        max(topInset + 42, 86)
    }

    private func dynamicIslandClearance(width: CGFloat) -> CGFloat {
        width >= 430 ? 168 : 148
    }

    private func analyticsControls(topInset: CGFloat, width: CGFloat) -> some View {
        HStack {
            HStack(spacing: 8) {
                analyticsControlButton(systemName: "chevron.left", isEnabled: model.canGoBack) {
                    model.goBack()
                }

                analyticsControlButton(systemName: "chevron.right", isEnabled: model.canGoForward) {
                    model.goForward()
                }
            }

            Spacer(minLength: dynamicIslandClearance(width: width))

            analyticsControlButton(systemName: "arrow.clockwise", isEnabled: true) {
                model.reload()
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, max(topInset - 4, 8))
    }

    private func analyticsControlButton(
        systemName: String,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isEnabled ? .primary : .secondary.opacity(0.55))
                .frame(width: 32, height: 32)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(.white.opacity(0.18), lineWidth: 0.5)
                }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}
