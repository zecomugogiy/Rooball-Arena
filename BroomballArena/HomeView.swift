import SwiftUI

struct HomeView: View {
    enum DeskTab: String, CaseIterable, Identifiable {
        case clubs
        case calendar
        case results
        case notes

        var id: String { rawValue }
    }

    @EnvironmentObject private var store: MatchStore
    @AppStorage("app.language") private var languageRawValue = AppLanguage.english.rawValue
    @State private var showingClear = false
    @State private var selectedTab: DeskTab = .clubs
    @State private var searchText = ""

    private var language: AppLanguage {
        AppLanguage.from(languageRawValue)
    }

    private var filteredClubs: [ClubProfile] {
        let clubs = AppData.clubProfiles(language)
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return clubs }
        return clubs.filter {
            $0.name.localizedCaseInsensitiveContains(trimmed) ||
            $0.category.localizedCaseInsensitiveContains(trimmed) ||
            $0.region.localizedCaseInsensitiveContains(trimmed)
        }
    }

    private var events: [GameEvent] {
        AppData.gameEvents(language)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    NeonHeader(kicker: kicker, title: title, detail: detail)
                    deskSummary
                    tabPicker
                    selectedContent
                }
                .padding(20)
                .frame(maxWidth: 1040)
                .frame(maxWidth: .infinity)
            }
            .background(BroomBackground())
            .navigationTitle(ArenaSection.club.title(language))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(clearLabel) { showingClear = true }
                        .disabled(store.notes.isEmpty)
                }
            }
            .alert(clearTitle, isPresented: $showingClear) {
                Button(cancelLabel, role: .cancel) {}
                Button(clearLabel, role: .destructive) { store.clearNotes() }
            }
        }
    }

    private var deskSummary: some View {
        MetricStrip(items: [
            ("\(AppData.clubProfiles(language).count)", clubsMetric),
            ("\(events.count)", gamesMetric),
            ("2026", seasonMetric)
        ])
    }

    private var tabPicker: some View {
        Picker("Club Desk", selection: $selectedTab) {
            ForEach(DeskTab.allCases) { tab in
                Text(title(for: tab)).tag(tab)
            }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    private var selectedContent: some View {
        switch selectedTab {
        case .clubs:
            clubsView
        case .calendar:
            calendarView
        case .results:
            resultsView
        case .notes:
            pinnedNotes
        }
    }

    private var clubsView: some View {
        VStack(alignment: .leading, spacing: 14) {
            TextField(searchPlaceholder, text: $searchText)
                .foregroundStyle(BrandPalette.white)
                .padding(12)
                .background(BrandPalette.card)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 260), spacing: 12)], spacing: 12) {
                ForEach(filteredClubs) { club in
                    clubCard(club)
                }
            }

            sourceNote
        }
    }

    private func clubCard(_ club: ClubProfile) -> some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 11) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(club.name)
                            .font(.title3.weight(.black))
                            .foregroundStyle(BrandPalette.white)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(club.category)
                            .font(.caption.weight(.black))
                            .foregroundStyle(BrandPalette.yellow)
                    }
                    Spacer()
                    Circle()
                        .fill(club.color)
                        .frame(width: 18, height: 18)
                }

                Label(club.region, systemImage: "mappin.and.ellipse")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(BrandPalette.secondaryText)

                Text(club.note)
                    .font(.subheadline)
                    .foregroundStyle(BrandPalette.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Text(club.source)
                    .font(.caption2.weight(.black))
                    .foregroundStyle(BrandPalette.navy)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(BrandPalette.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var calendarView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(calendarIntro)
                .font(.subheadline)
                .foregroundStyle(BrandPalette.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(groupedEventDates, id: \.self) { date in
                VStack(alignment: .leading, spacing: 10) {
                    Text(date.uppercased())
                        .font(.caption.weight(.black))
                        .foregroundStyle(BrandPalette.yellow)
                    ForEach(events.filter { $0.date == date }) { event in
                        eventRow(event, compactResult: false)
                    }
                }
            }
        }
    }

    private var resultsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(events.filter { $0.result != nil }) { event in
                eventRow(event, compactResult: true)
            }
        }
    }

    private func eventRow(_ event: GameEvent, compactResult: Bool) -> some View {
        GlassPanel {
            HStack(alignment: .top, spacing: 12) {
                VStack(spacing: 4) {
                    Text(event.time)
                        .font(.caption.weight(.black))
                        .foregroundStyle(BrandPalette.navy)
                    Text(event.status)
                        .font(.caption2.weight(.black))
                        .foregroundStyle(BrandPalette.navy)
                }
                .frame(width: 72)
                .padding(.vertical, 8)
                .background(BrandPalette.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text(event.division)
                        .font(.caption.weight(.black))
                        .foregroundStyle(BrandPalette.yellow)
                    Text("\(event.home) vs \(event.away)")
                        .font(.headline)
                        .foregroundStyle(BrandPalette.white)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(compactResult ? event.date : event.venue)
                        .font(.subheadline)
                        .foregroundStyle(BrandPalette.secondaryText)
                }

                Spacer()

                if let result = event.result {
                    Text(result)
                        .font(.title3.weight(.black))
                        .foregroundStyle(BrandPalette.white)
                        .monospacedDigit()
                }
            }
        }
    }

    private var sourceNote: some View {
        Text(sourceText)
            .font(.caption)
            .foregroundStyle(BrandPalette.mutedText)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var pinnedNotes: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(notesTitle)
                .font(.title2.weight(.black))
                .foregroundStyle(BrandPalette.white)

            if store.notes.isEmpty {
                EmptyStateCard(title: emptyTitle, systemImage: "pin.slash", detail: emptyDetail)
            } else {
                ForEach(store.notes) { note in
                    GlassPanel {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(note.headline)
                                    .font(.headline)
                                    .foregroundStyle(BrandPalette.white)
                                Spacer()
                                Text(note.date, style: .date)
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(BrandPalette.mutedText)
                            }
                            Text(note.scoreline)
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(BrandPalette.yellow)
                            Text(note.takeaway)
                                .font(.subheadline)
                                .foregroundStyle(BrandPalette.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }

    private var groupedEventDates: [String] {
        var seen: [String] = []
        for event in events where !seen.contains(event.date) {
            seen.append(event.date)
        }
        return seen
    }

    private func title(for tab: DeskTab) -> String {
        switch (tab, language) {
        case (.clubs, .english): return "Clubs"
        case (.clubs, .french): return "Clubs"
        case (.clubs, .spanish): return "Clubes"
        case (.calendar, .english): return "Calendar"
        case (.calendar, .french): return "Calendrier"
        case (.calendar, .spanish): return "Calendario"
        case (.results, .english): return "Results"
        case (.results, .french): return "Resultats"
        case (.results, .spanish): return "Resultados"
        case (.notes, .english): return "Notes"
        case (.notes, .french): return "Notes"
        case (.notes, .spanish): return "Notas"
        }
    }

    private var kicker: String { language == .english ? "Club intelligence" : language == .french ? "Intelligence club" : "Inteligencia club" }
    private var title: String { language == .english ? "Real teams, calendar, and results in one desk." : language == .french ? "Equipes reelles, calendrier et resultats." : "Equipos reales, calendario y resultados." }
    private var detail: String { language == .english ? "Browse real broomball programs and a 2026 Nationals schedule archive, then keep your own pinned notes beside them." : language == .french ? "Parcourez des programmes reels et une archive Nationals 2026, puis gardez vos notes." : "Consulta programas reales y archivo Nationals 2026, con tus notas fijadas." }
    private var clubsMetric: String { language == .english ? "clubs" : language == .french ? "clubs" : "clubes" }
    private var gamesMetric: String { language == .english ? "games" : language == .french ? "matchs" : "juegos" }
    private var seasonMetric: String { language == .english ? "season" : language == .french ? "saison" : "temporada" }
    private var searchPlaceholder: String { language == .english ? "Search clubs, divisions, regions" : language == .french ? "Chercher clubs, divisions, regions" : "Buscar clubes, divisiones, regiones" }
    private var calendarIntro: String { language == .english ? "Calendar archive uses published Broomball Canada Nationals 2026 game listings available on April 22, 2026." : language == .french ? "Archive basee sur les matchs Nationals 2026 publies par Broomball Canada disponibles le 22 avril 2026." : "Archivo basado en juegos Nationals 2026 publicados por Broomball Canada disponibles el 22 de abril de 2026." }
    private var sourceText: String { language == .english ? "Sources summarized in-app: Broomball Canada Nationals listings, Finch Youth Broomball, and Nova Scotia Broomball Association." : language == .french ? "Sources resumees: listes Nationals de Broomball Canada, Finch Youth Broomball et Nova Scotia Broomball Association." : "Fuentes resumidas: listas Nationals de Broomball Canada, Finch Youth Broomball y Nova Scotia Broomball Association." }
    private var notesTitle: String { language == .english ? "Pinned Match Notes" : language == .french ? "Notes epinglees" : "Notas fijadas" }
    private var emptyTitle: String { language == .english ? "No pinned lessons yet" : language == .french ? "Aucune lecon epinglee" : "Sin lecciones fijadas" }
    private var emptyDetail: String { language == .english ? "Pin one from Live Room after a match or practice burst." : language == .french ? "Epinglez depuis Salle Live apres un match ou exercice." : "Fija una desde Sala Live despues de un partido o practica." }
    private var clearLabel: String { language == .english ? "Clear" : language == .french ? "Effacer" : "Borrar" }
    private var clearTitle: String { language == .english ? "Clear pinned notes?" : language == .french ? "Effacer les notes?" : "Borrar notas?" }
    private var cancelLabel: String { language == .english ? "Cancel" : language == .french ? "Annuler" : "Cancelar" }
}
