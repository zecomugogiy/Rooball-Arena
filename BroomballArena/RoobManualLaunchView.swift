import SwiftUI

public struct RoobManualLaunchView: View {
    public let config: RoobLaunchConfig
    public let languageCode: String
    @State private var isChecking = false
    @State private var statusMessage: String?
    @State private var activeExperience: ActiveRoobWebSurface?

    public init(config: RoobLaunchConfig, languageCode: String = Locale.current.identifier) {
        self.config = config
        self.languageCode = languageCode
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Launch Check", systemImage: "network")
                .font(.headline)
                .foregroundStyle(RoobWebChrome.accent)

            Text("Runs the Roob launch check and opens the server-provided destination when available.")
                .font(.subheadline)
                .foregroundStyle(RoobWebChrome.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                Task { await checkAndOpen() }
            } label: {
                HStack {
                    if isChecking {
                        ProgressView()
                            .tint(RoobWebChrome.navy)
                    }
                    Text(isChecking ? "Checking..." : "Check and open")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(RoobWebChrome.accent)
            .foregroundStyle(RoobWebChrome.navy)
            .disabled(isChecking)

            if let statusMessage {
                Text(statusMessage)
                    .font(.footnote)
                    .foregroundStyle(RoobWebChrome.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoobWebChrome.card)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .fullScreenCover(item: $activeExperience) { item in
            NavigationStack {
                RoobWebSurface(config: item.config)
            }
        }
    }

    @MainActor
    private func checkAndOpen() async {
        isChecking = true
        statusMessage = nil
        defer { isChecking = false }

        do {
            let client = RoobLaunchClient(config: config)
            let response = try await client.checkAccess(languageCode: languageCode)

            guard response.enabled else {
                statusMessage = "Server returned false. Continuing with the local app."
                return
            }

            guard let url = response.url else {
                statusMessage = "Server returned true but did not include a URL."
                return
            }

            activeExperience = ActiveRoobWebSurface(config: config.withResolvedURL(url))
        } catch {
            statusMessage = error.localizedDescription
        }
    }
}

public struct ActiveRoobWebSurface: Identifiable {
    public let id = UUID()
    public let config: RoobLaunchConfig

    public init(config: RoobLaunchConfig) {
        self.config = config
    }
}
