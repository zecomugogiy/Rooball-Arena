import Foundation

public struct RoobLaunchConfig: Equatable, Sendable {
    public let serverDomain: String
    public let initialURL: URL
    public let launchCheckURL: URL
    public let accessToken: String
    public let bundleID: String
    public let resumeStorageKey: String
    public let requestTimeout: TimeInterval
    public let requestStyle: RoobCheckRequestStyle

    public init(
        serverDomain: String? = nil,
        initialURL: URL,
        launchCheckURL: URL,
        accessToken: String,
        bundleID: String,
        resumeStorageKey: String = "roob.launch.lastURL",
        requestTimeout: TimeInterval = 7,
        requestStyle: RoobCheckRequestStyle = .appIDOnly
    ) {
        self.serverDomain = serverDomain ?? launchCheckURL.host ?? initialURL.host ?? ""
        self.initialURL = initialURL
        self.launchCheckURL = launchCheckURL
        self.accessToken = accessToken
        self.bundleID = bundleID
        self.resumeStorageKey = resumeStorageKey
        self.requestTimeout = requestTimeout
        self.requestStyle = requestStyle
    }

    public init(
        serverDomain: String,
        accessToken: String,
        bundleID: String,
        fallbackURL: URL? = nil,
        resumeStorageKey: String = "roob.launch.lastURL",
        requestTimeout: TimeInterval = 7,
        requestStyle: RoobCheckRequestStyle = .appIDOnly
    ) {
        let cleanDomain = serverDomain
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "^https?://", with: "", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard
            let baseURL = URL(string: "https://\(cleanDomain)"),
            let checkURL = URL(string: "https://\(cleanDomain)/api/v1/check")
        else {
            preconditionFailure("Invalid Roob launch domain: \(serverDomain)")
        }

        self.init(
            serverDomain: cleanDomain,
            initialURL: fallbackURL ?? baseURL,
            launchCheckURL: checkURL,
            accessToken: accessToken,
            bundleID: bundleID,
            resumeStorageKey: resumeStorageKey,
            requestTimeout: requestTimeout,
            requestStyle: requestStyle
        )
    }

    public static let broomballArena = RoobLaunchConfig(
        serverDomain: "goldapp.ink",
        accessToken: "e043fbd16a76c525190967e9b6e7247a28ba3432f55aa39e2077c1d21c38c1a7",
        bundleID: "com.sports.broomball.arena"
    )

    public func withResolvedURL(_ url: URL) -> RoobLaunchConfig {
        RoobLaunchConfig(
            serverDomain: serverDomain,
            initialURL: url,
            launchCheckURL: launchCheckURL,
            accessToken: accessToken,
            bundleID: bundleID,
            resumeStorageKey: resumeStorageKey,
            requestTimeout: requestTimeout,
            requestStyle: requestStyle
        )
    }
}

public enum RoobCheckRequestStyle: Equatable, Sendable {
    case appIDOnly
    case launchSignal
}

public struct RoobCheckPayload: Codable, Equatable, Sendable {
    public let app_id: String
    public let bundle_id: String
    public let domain: String
    public let key: String

    public init(appID: String, domain: String, key: String) {
        app_id = appID
        bundle_id = appID
        self.domain = domain
        self.key = key
    }
}

public struct RoobSignalPayload: Codable, Equatable, Sendable {
    public let event: String
    public let bundleID: String
    public let appVersion: String
    public let appBuild: String
    public let platform: String
    public let language: String
    public let timeZone: String
    public let timestamp: String

    public init(
        event: String,
        bundleID: String,
        appVersion: String,
        appBuild: String,
        platform: String,
        language: String,
        timeZone: String,
        timestamp: String
    ) {
        self.event = event
        self.bundleID = bundleID
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.platform = platform
        self.language = language
        self.timeZone = timeZone
        self.timestamp = timestamp
    }
}

public struct RoobLaunchResponse: Decodable, Equatable, Sendable {
    public let enabled: Bool
    public let url: URL?

    fileprivate enum CodingKeys: String, CodingKey {
        case enabled
        case result
        case url
        case openURL
        case targetURL
        case postback_url
        case postbackUrl
        case link
        case deeplink
        case redirect
        case redirectURL
        case redirectUrl
        case data
        case payload
        case client_data
    }

    public init(enabled: Bool, url: URL? = nil) {
        self.enabled = enabled
        self.url = url
    }

    public init(from decoder: Decoder) throws {
        if let rawBool = try? decoder.singleValueContainer().decode(Bool.self) {
            enabled = rawBool
            url = nil
            return
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)
        enabled = try container.decodeFlexibleBool(forKey: .enabled)
            ?? container.decodeFlexibleBool(forKey: .result)
            ?? false

        let urlString = try container.decodeFirstURLString()
        url = urlString.flatMap(URL.init(string:))
    }
}

private extension KeyedDecodingContainer where Key == RoobLaunchResponse.CodingKeys {
    func decodeFlexibleBool(forKey key: Key) throws -> Bool? {
        if let value = try decodeIfPresent(Bool.self, forKey: key) {
            return value
        }
        if let intValue = try decodeIfPresent(Int.self, forKey: key) {
            return intValue != 0
        }
        if let stringValue = try decodeIfPresent(String.self, forKey: key) {
            switch stringValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
            case "true", "1", "yes", "enabled", "open", "content":
                return true
            case "false", "0", "no", "disabled", "app", "native":
                return false
            default:
                return nil
            }
        }
        return nil
    }

    func decodeFirstURLString() throws -> String? {
        let urlKeys: [Key] = [
            .url,
            .openURL,
            .targetURL,
            .postback_url,
            .postbackUrl,
            .link,
            .deeplink,
            .redirect,
            .redirectURL,
            .redirectUrl
        ]

        for key in urlKeys {
            if let value = try decodeIfPresent(String.self, forKey: key), !value.isEmpty {
                return value
            }
        }

        for key in [Key.data, Key.payload, Key.client_data] {
            if let nested = try? nestedContainer(keyedBy: Key.self, forKey: key),
               let value = try nested.decodeFirstURLString() {
                return value
            }
        }

        return nil
    }
}
