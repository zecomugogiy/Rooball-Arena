import SwiftUI

struct MatchCenterView: View {
    @EnvironmentObject private var store: MatchStore
    @AppStorage("app.language") private var languageRawValue = AppLanguage.english.rawValue
    @State private var showingReset = false
    @FocusState private var focusedField: MatchField?

    private enum MatchField: Hashable {
        case homeName
        case awayName
        case captainNote
    }

    private var language: AppLanguage {
        AppLanguage.from(languageRawValue)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    NeonHeader(kicker: kicker, title: title, detail: detail)
                    RinkPulseView(tempo: store.state.tempo, pressure: store.state.pressure, language: language)
                    scoreConsole
                    liveRead
                    captainCalls
                }
                .padding(20)
                .frame(maxWidth: 980)
                .frame(maxWidth: .infinity)
            }
            .scrollDismissesKeyboard(.interactively)
            .simultaneousGesture(
                DragGesture(minimumDistance: 8)
                    .onChanged { _ in dismissKeyboard() }
            )
            .background(BroomBackground())
            .navigationTitle(ArenaSection.live.title(language))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(resetLabel) {
                        dismissKeyboard()
                        showingReset = true
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(doneLabel) {
                        dismissKeyboard()
                    }
                }
            }
            .alert(resetTitle, isPresented: $showingReset) {
                Button(cancelLabel, role: .cancel) {}
                Button(resetLabel, role: .destructive) {
                    dismissKeyboard()
                    store.resetLive()
                }
            }
        }
    }

    private func dismissKeyboard() {
        focusedField = nil
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    private var scoreConsole: some View {
        GlassPanel {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    teamColumn(home: true)
                    VStack(spacing: 8) {
                        Text("P\(store.state.period)")
                            .font(.caption.weight(.black))
                            .foregroundStyle(BrandPalette.yellow)
                        Text("-")
                            .font(.largeTitle.weight(.black))
                            .foregroundStyle(BrandPalette.secondaryText)
                        Button(nextPeriodLabel) { store.nextPeriod() }
                            .font(.caption.weight(.bold))
                            .buttonStyle(.bordered)
                    }
                    .frame(width: 82)
                    teamColumn(home: false)
                }

                HStack(spacing: 12) {
                    Button(undoLabel) { store.undoGoal() }
                        .buttonStyle(.bordered)
                        .disabled(store.state.lastGoalHome == nil)
                    Button(pinNoteLabel) {
                        dismissKeyboard()
                        store.pinNote(language: language)
                    }
                        .buttonStyle(.borderedProminent)
                        .tint(BrandPalette.yellow)
                        .foregroundStyle(BrandPalette.navy)
                }
            }
        }
    }

    private func teamColumn(home: Bool) -> some View {
        let nameBinding = home ? $store.state.homeName : $store.state.awayName
        let score = home ? store.state.homeScore : store.state.awayScore
        let tint = home ? BrandPalette.yellow : BrandPalette.violet

        return VStack(spacing: 10) {
            TextField(home ? homePlaceholder : awayPlaceholder, text: nameBinding)
                .focused($focusedField, equals: home ? .homeName : .awayName)
                .multilineTextAlignment(.center)
                .font(.headline.weight(.bold))
                .foregroundStyle(BrandPalette.white)
                .textInputAutocapitalization(.words)
                .padding(.vertical, 8)
                .background(BrandPalette.deepNavy)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Text("\(score)")
                .font(.system(size: 72, weight: .black, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(BrandPalette.white)
                .frame(height: 80)

            Button(goalLabel) { store.addGoal(home: home) }
                .buttonStyle(.borderedProminent)
                .tint(tint)
                .foregroundStyle(home ? BrandPalette.navy : BrandPalette.white)
        }
        .frame(maxWidth: .infinity)
    }

    private var liveRead: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 14) {
                Text(store.leaderText(language: language))
                    .font(.title3.weight(.black))
                    .foregroundStyle(BrandPalette.white)

                VStack(alignment: .leading, spacing: 10) {
                    Label(tempoLabel, systemImage: "speedometer")
                        .foregroundStyle(BrandPalette.yellow)
                    Slider(value: $store.state.tempo, in: 0...100)
                        .tint(BrandPalette.yellow)
                    Label(pressureLabel, systemImage: "flame")
                        .foregroundStyle(BrandPalette.red)
                    Slider(value: $store.state.pressure, in: 0...100)
                        .tint(BrandPalette.red)
                }

                TextField(notePlaceholder, text: $store.state.captainNote, axis: .vertical)
                    .focused($focusedField, equals: .captainNote)
                    .lineLimit(2...4)
                    .foregroundStyle(BrandPalette.white)
                    .padding(12)
                    .background(BrandPalette.deepNavy)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
    }

    private var captainCalls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(callsTitle)
                .font(.title2.weight(.black))
                .foregroundStyle(BrandPalette.white)
            ForEach(AppData.calls(language)) { call in
                GlassPanel {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: call.symbol)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(BrandPalette.navy)
                            .frame(width: 44, height: 44)
                            .background(BrandPalette.yellow)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        VStack(alignment: .leading, spacing: 5) {
                            Text(call.cue.uppercased())
                                .font(.caption2.weight(.black))
                                .foregroundStyle(BrandPalette.yellow)
                            Text(call.title)
                                .font(.headline)
                                .foregroundStyle(BrandPalette.white)
                            Text(call.detail)
                                .font(.subheadline)
                                .foregroundStyle(BrandPalette.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }

    private var kicker: String { language == .english ? "Bench command" : language == .french ? "Commande banc" : "Mando de banco" }
    private var title: String { language == .english ? "Read the ice while the game moves." : language == .french ? "Lisez la glace pendant le match." : "Lee la pista mientras corre el juego." }
    private var detail: String { language == .english ? "A live cockpit for captain calls, pressure, tempo, quick scoring, and one pinned lesson." : language == .french ? "Un cockpit live pour appels, pression, tempo, pointage rapide et une lecon epinglee." : "Un cockpit live para llamadas, presion, ritmo, marcador rapido y una leccion fijada." }
    private var homePlaceholder: String { language == .english ? "Home line" : language == .french ? "Ligne maison" : "Linea local" }
    private var awayPlaceholder: String { language == .english ? "Away line" : language == .french ? "Ligne visiteur" : "Linea visita" }
    private var goalLabel: String { language == .english ? "Goal" : language == .french ? "But" : "Gol" }
    private var undoLabel: String { language == .english ? "Undo last" : language == .french ? "Annuler" : "Deshacer" }
    private var pinNoteLabel: String { language == .english ? "Pin note" : language == .french ? "Epingler" : "Fijar nota" }
    private var nextPeriodLabel: String { language == .english ? "Next" : language == .french ? "Suite" : "Sig." }
    private var tempoLabel: String { language == .english ? "Tempo" : language == .french ? "Tempo" : "Ritmo" }
    private var pressureLabel: String { language == .english ? "Pressure" : language == .french ? "Pression" : "Presion" }
    private var notePlaceholder: String { language == .english ? "Captain note for the next huddle" : language == .french ? "Note capitaine pour le prochain caucus" : "Nota del capitan para la proxima charla" }
    private var callsTitle: String { language == .english ? "Quick Calls" : language == .french ? "Appels rapides" : "Llamadas rapidas" }
    private var resetLabel: String { language == .english ? "Reset" : language == .french ? "Reset" : "Reset" }
    private var doneLabel: String { language == .english ? "Done" : language == .french ? "Terminer" : "Listo" }
    private var resetTitle: String { language == .english ? "Reset live room?" : language == .french ? "Reinitialiser la salle live?" : "Reiniciar sala live?" }
    private var cancelLabel: String { language == .english ? "Cancel" : language == .french ? "Annuler" : "Cancelar" }
}
