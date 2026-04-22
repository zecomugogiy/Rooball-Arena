import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case french = "fr"
    case spanish = "es"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .french: return "Francais"
        case .spanish: return "Espanol"
        }
    }

    var shortName: String {
        switch self {
        case .english: return "EN"
        case .french: return "FR"
        case .spanish: return "ES"
        }
    }

    static func from(_ rawValue: String) -> AppLanguage {
        AppLanguage(rawValue: rawValue) ?? .english
    }
}

enum Copy {
    static func appName(_ language: AppLanguage) -> String { "Rooball Arena" }
    static func homeTab(_ language: AppLanguage) -> String {
        switch language {
        case .english: return "Arena"
        case .french: return "Arena"
        case .spanish: return "Arena"
        }
    }
    static func matchTab(_ language: AppLanguage) -> String {
        switch language {
        case .english: return "Match"
        case .french: return "Match"
        case .spanish: return "Partido"
        }
    }
    static func trainingTab(_ language: AppLanguage) -> String {
        switch language {
        case .english: return "Training"
        case .french: return "Entrainement"
        case .spanish: return "Entreno"
        }
    }
    static func learnTab(_ language: AppLanguage) -> String {
        switch language {
        case .english: return "Learn"
        case .french: return "Guide"
        case .spanish: return "Guia"
        }
    }
    static func tie(_ language: AppLanguage) -> String {
        switch language {
        case .english: return "Tie"
        case .french: return "Egalite"
        case .spanish: return "Empate"
        }
    }
    static func winnerPrefix(_ language: AppLanguage) -> String {
        switch language {
        case .english: return "Winner"
        case .french: return "Gagnant"
        case .spanish: return "Ganador"
        }
    }
}
