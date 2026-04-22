import SwiftUI

@main
struct BroomballArenaApp: App {
    @AppStorage("app.language") private var languageRawValue = AppLanguage.english.rawValue

    var body: some Scene {
        WindowGroup {
            RoobLaunchGate(
                config: .broomballArena,
                languageCode: AppLanguage.from(languageRawValue).localeCode,
                requestReviewBeforeCheck: false
            ) {
                ContentView()
            }
        }
    }
}

private extension AppLanguage {
    var localeCode: String {
        switch self {
        case .english: return "en"
        case .french: return "fr"
        case .spanish: return "es"
        }
    }
}
