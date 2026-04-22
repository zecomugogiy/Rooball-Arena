import Foundation
import SwiftUI

enum ArenaSection: String, CaseIterable, Identifiable {
    case live
    case coach
    case atlas
    case club
    case settings

    var id: String { rawValue }

    func title(_ language: AppLanguage) -> String {
        switch (self, language) {
        case (.live, .english): return "Live Room"
        case (.live, .french): return "Salle Live"
        case (.live, .spanish): return "Sala Live"
        case (.coach, .english): return "Coach Board"
        case (.coach, .french): return "Tableau Coach"
        case (.coach, .spanish): return "Pizarra"
        case (.atlas, .english): return "Rule Atlas"
        case (.atlas, .french): return "Atlas Regles"
        case (.atlas, .spanish): return "Atlas Reglas"
        case (.club, .english): return "Club Desk"
        case (.club, .french): return "Bureau Club"
        case (.club, .spanish): return "Mesa Club"
        case (.settings, .english): return "Settings"
        case (.settings, .french): return "Reglages"
        case (.settings, .spanish): return "Ajustes"
        }
    }

    var symbol: String {
        switch self {
        case .live: return "dot.radiowaves.left.and.right"
        case .coach: return "rectangle.and.pencil.and.ellipsis"
        case .atlas: return "map"
        case .club: return "person.3"
        case .settings: return "gearshape"
        }
    }
}

struct CaptainCall: Identifiable {
    let id = UUID()
    let title: String
    let cue: String
    let detail: String
    let symbol: String
}

struct RinkZone: Identifiable {
    let id = UUID()
    let name: String
    let shortRule: String
    let mistake: String
    let color: Color
}

struct PracticeBlock: Identifiable {
    let id = UUID()
    let title: String
    let minutes: Int
    let intensity: Int
    let detail: String
}

struct ClubCard: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let detail: String
    let symbol: String
}

struct ClubProfile: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let region: String
    let note: String
    let source: String
    let color: Color
}

struct GameEvent: Identifiable {
    let id = UUID()
    let date: String
    let time: String
    let division: String
    let home: String
    let away: String
    let venue: String
    let status: String
    let result: String?
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let prompt: String
    let answers: [String]
    let correctIndex: Int
    let explanation: String
}

struct MatchNote: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    let headline: String
    let scoreline: String
    let takeaway: String
}

struct MatchState: Codable, Equatable {
    var homeName = "Gold Line"
    var awayName = "Night Sweep"
    var homeScore = 0
    var awayScore = 0
    var period = 1
    var tempo = 50.0
    var pressure = 50.0
    var captainNote = ""
    var lastGoalHome: Bool?
}

@MainActor
final class MatchStore: ObservableObject {
    @Published var state: MatchState {
        didSet { saveState() }
    }

    @Published var notes: [MatchNote] {
        didSet { saveNotes() }
    }

    private let stateKey = "broomiq.match.state"
    private let notesKey = "broomiq.match.notes"

    init() {
        if let data = UserDefaults.standard.data(forKey: stateKey),
           let decoded = try? JSONDecoder().decode(MatchState.self, from: data) {
            state = decoded
        } else {
            state = MatchState()
        }

        if let data = UserDefaults.standard.data(forKey: notesKey),
           let decoded = try? JSONDecoder().decode([MatchNote].self, from: data) {
            notes = decoded
        } else {
            notes = []
        }
    }

    func addGoal(home: Bool) {
        if home {
            state.homeScore += 1
        } else {
            state.awayScore += 1
        }
        state.lastGoalHome = home
    }

    func undoGoal() {
        guard let home = state.lastGoalHome else { return }
        if home {
            state.homeScore = max(0, state.homeScore - 1)
        } else {
            state.awayScore = max(0, state.awayScore - 1)
        }
        state.lastGoalHome = nil
    }

    func nextPeriod() {
        state.period = min(4, state.period + 1)
    }

    func resetLive() {
        state.homeScore = 0
        state.awayScore = 0
        state.period = 1
        state.tempo = 50
        state.pressure = 50
        state.captainNote = ""
        state.lastGoalHome = nil
    }

    func pinNote(language: AppLanguage) {
        let trimmed = state.captainNote.trimmingCharacters(in: .whitespacesAndNewlines)
        let fallback: String
        switch language {
        case .english: fallback = "No captain note"
        case .french: fallback = "Aucune note capitaine"
        case .spanish: fallback = "Sin nota del capitan"
        }

        let note = MatchNote(
            id: UUID(),
            date: Date(),
            headline: leaderText(language: language),
            scoreline: "\(clean(state.homeName)) \(state.homeScore) - \(state.awayScore) \(clean(state.awayName))",
            takeaway: trimmed.isEmpty ? fallback : trimmed
        )
        notes.insert(note, at: 0)
        state.captainNote = ""
    }

    func clearNotes() {
        notes = []
    }

    func clearAllLocalData() {
        resetLive()
        notes = []
        UserDefaults.standard.removeObject(forKey: stateKey)
        UserDefaults.standard.removeObject(forKey: notesKey)
    }

    func leaderText(language: AppLanguage) -> String {
        if state.homeScore == state.awayScore {
            switch language {
            case .english: return "Level game"
            case .french: return "Match egal"
            case .spanish: return "Partido igualado"
            }
        }

        let leader = state.homeScore > state.awayScore ? clean(state.homeName) : clean(state.awayName)
        switch language {
        case .english: return "\(leader) controls the board"
        case .french: return "\(leader) controle le tableau"
        case .spanish: return "\(leader) controla el marcador"
        }
    }

    private func clean(_ name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Team" : trimmed
    }

    private func saveState() {
        guard let data = try? JSONEncoder().encode(state) else { return }
        UserDefaults.standard.set(data, forKey: stateKey)
    }

    private func saveNotes() {
        guard let data = try? JSONEncoder().encode(notes) else { return }
        UserDefaults.standard.set(data, forKey: notesKey)
    }
}
