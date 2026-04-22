import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: MatchStore
    @AppStorage("app.language") private var languageRawValue = AppLanguage.english.rawValue
    @AppStorage("settings.compactMode") private var compactMode = false
    @AppStorage("settings.showSourceNotes") private var showSourceNotes = true
    @State private var showingClearNotes = false
    @State private var showingClearAll = false

    private var language: AppLanguage {
        AppLanguage.from(languageRawValue)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    NeonHeader(kicker: kicker, title: title, detail: detail)
                    languagePanel
                    displayPanel
                    privacyPanel
                    storagePanel
                }
                .padding(20)
                .frame(maxWidth: 980)
                .frame(maxWidth: .infinity)
            }
            .background(BroomBackground())
            .navigationTitle(ArenaSection.settings.title(language))
            .navigationBarTitleDisplayMode(.inline)
            .alert(clearNotesTitle, isPresented: $showingClearNotes) {
                Button(cancelLabel, role: .cancel) {}
                Button(clearLabel, role: .destructive) { store.clearNotes() }
            }
            .alert(clearAllTitle, isPresented: $showingClearAll) {
                Button(cancelLabel, role: .cancel) {}
                Button(clearAllLabel, role: .destructive) { store.clearAllLocalData() }
            }
        }
    }

    private var languagePanel: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 14) {
                Label(languageTitle, systemImage: "globe")
                    .font(.title3.weight(.black))
                    .foregroundStyle(BrandPalette.white)

                Picker(languageTitle, selection: $languageRawValue) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(language.displayName).tag(language.rawValue)
                    }
                }
                .pickerStyle(.segmented)

                Text(languageDetail)
                    .font(.subheadline)
                    .foregroundStyle(BrandPalette.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var displayPanel: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 14) {
                Label(displayTitle, systemImage: "slider.horizontal.3")
                    .font(.title3.weight(.black))
                    .foregroundStyle(BrandPalette.white)

                Toggle(compactLabel, isOn: $compactMode)
                Toggle(sourceNotesLabel, isOn: $showSourceNotes)
            }
            .tint(BrandPalette.yellow)
        }
    }

    private var privacyPanel: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 14) {
                Label(privacyTitle, systemImage: "lock.shield")
                    .font(.title3.weight(.black))
                    .foregroundStyle(BrandPalette.white)

                ForEach(privacyFacts, id: \.0) { fact in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: fact.0)
                            .font(.headline)
                            .foregroundStyle(BrandPalette.navy)
                            .frame(width: 34, height: 34)
                            .background(BrandPalette.yellow)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(fact.1)
                                .font(.headline)
                                .foregroundStyle(BrandPalette.white)
                            Text(fact.2)
                                .font(.subheadline)
                                .foregroundStyle(BrandPalette.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }

    private var storagePanel: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 14) {
                Label(storageTitle, systemImage: "internaldrive")
                    .font(.title3.weight(.black))
                    .foregroundStyle(BrandPalette.white)

                MetricStrip(items: [
                    ("\(store.notes.count)", notesMetric),
                    ("\(store.state.homeScore)-\(store.state.awayScore)", liveMetric),
                    ("1", networkMetric)
                ])

                HStack(spacing: 12) {
                    Button(clearLabel) { showingClearNotes = true }
                        .buttonStyle(.bordered)
                        .disabled(store.notes.isEmpty)

                    Button(clearAllLabel, role: .destructive) { showingClearAll = true }
                        .buttonStyle(.borderedProminent)
                        .tint(BrandPalette.red)
                }
            }
        }
    }

    private var privacyFacts: [(String, String, String)] {
        switch language {
        case .english:
            return [
                ("iphone", "Local only", "Live scores, notes, settings, and language are stored on this device with UserDefaults."),
                ("network", "Launch check", "At launch the app may contact goldapp.ink to check whether a web destination should open."),
                ("person.crop.circle.badge.xmark", "No personal profile", "Rooball Arena does not ask for names, email, contacts, location, camera, or microphone.")
            ]
        case .french:
            return [
                ("iphone", "Local seulement", "Scores, notes, reglages et langue restent sur cet appareil avec UserDefaults."),
                ("network", "Verification au lancement", "Au lancement, l'app peut contacter goldapp.ink pour verifier si une destination web doit s'ouvrir."),
                ("person.crop.circle.badge.xmark", "Aucun profil personnel", "Rooball Arena ne demande pas nom, email, contacts, position, camera ou micro.")
            ]
        case .spanish:
            return [
                ("iphone", "Solo local", "Marcador, notas, ajustes e idioma se guardan en este dispositivo con UserDefaults."),
                ("network", "Chequeo al iniciar", "Al iniciar, la app puede contactar goldapp.ink para comprobar si debe abrir una web."),
                ("person.crop.circle.badge.xmark", "Sin perfil personal", "Rooball Arena no pide nombre, email, contactos, ubicacion, camara ni microfono.")
            ]
        }
    }

    private var kicker: String { language == .english ? "Privacy and setup" : language == .french ? "Vie privee et reglages" : "Privacidad y ajustes" }
    private var title: String { language == .english ? "Control language, privacy, and local data." : language == .french ? "Controlez langue, vie privee et donnees locales." : "Controla idioma, privacidad y datos locales." }
    private var detail: String { language == .english ? "Rooball Arena keeps native tools local and uses a launch check for optional web content." : language == .french ? "Rooball Arena garde les outils natifs en local et utilise une verification web au lancement." : "Rooball Arena guarda las herramientas nativas localmente y usa un chequeo web al iniciar." }
    private var languageTitle: String { language == .english ? "Language" : language == .french ? "Langue" : "Idioma" }
    private var languageDetail: String { language == .english ? "This setting updates navigation, coaching copy, club desk labels, and quiz text." : language == .french ? "Ce reglage met a jour navigation, coaching, clubs et quiz." : "Este ajuste actualiza navegacion, coaching, clubes y quiz." }
    private var displayTitle: String { language == .english ? "Display Preferences" : language == .french ? "Preferences affichage" : "Preferencias visuales" }
    private var compactLabel: String { language == .english ? "Compact match surfaces" : language == .french ? "Surfaces match compactes" : "Pantallas compactas" }
    private var sourceNotesLabel: String { language == .english ? "Show club source notes" : language == .french ? "Afficher sources clubs" : "Mostrar fuentes de clubes" }
    private var privacyTitle: String { language == .english ? "Privacy" : language == .french ? "Vie privee" : "Privacidad" }
    private var storageTitle: String { language == .english ? "Local Storage" : language == .french ? "Stockage local" : "Almacenamiento local" }
    private var notesMetric: String { language == .english ? "notes" : language == .french ? "notes" : "notas" }
    private var liveMetric: String { language == .english ? "live score" : language == .french ? "score live" : "marcador" }
    private var networkMetric: String { language == .english ? "launch check" : language == .french ? "check web" : "chequeo web" }
    private var clearLabel: String { language == .english ? "Clear notes" : language == .french ? "Effacer notes" : "Borrar notas" }
    private var clearAllLabel: String { language == .english ? "Clear all local data" : language == .french ? "Tout effacer" : "Borrar todo" }
    private var clearNotesTitle: String { language == .english ? "Clear pinned notes?" : language == .french ? "Effacer les notes?" : "Borrar notas?" }
    private var clearAllTitle: String { language == .english ? "Clear all local data?" : language == .french ? "Effacer toutes les donnees locales?" : "Borrar todos los datos locales?" }
    private var cancelLabel: String { language == .english ? "Cancel" : language == .french ? "Annuler" : "Cancelar" }
}
