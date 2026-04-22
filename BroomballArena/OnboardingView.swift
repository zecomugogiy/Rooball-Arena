import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void

    @AppStorage("app.language") private var languageRawValue = AppLanguage.english.rawValue

    private var language: AppLanguage {
        AppLanguage.from(languageRawValue)
    }

    var body: some View {
        VStack(spacing: 22) {
            NeonHeader(kicker: "Rooball Arena", title: title, detail: detail)
            Picker(languageLabel, selection: $languageRawValue) {
                ForEach(AppLanguage.allCases) { language in
                    Text(language.shortName).tag(language.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 280)

            RinkPulseView(tempo: 64, pressure: 42, language: language)

            Button(startLabel) { onFinish() }
                .buttonStyle(.borderedProminent)
                .tint(BrandPalette.yellow)
                .foregroundStyle(BrandPalette.navy)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BroomBackground())
    }

    private var title: String { language == .english ? "A fresh broomball command app." : language == .french ? "Une nouvelle app de commande broomball." : "Una nueva app de mando broomball." }
    private var detail: String { language == .english ? "Live calls, coach board, rule atlas, and club desk in one offline tool." : language == .french ? "Appels live, tableau coach, atlas de regles et bureau club hors ligne." : "Llamadas live, pizarra, atlas de reglas y mesa club offline." }
    private var languageLabel: String { language == .english ? "Language" : language == .french ? "Langue" : "Idioma" }
    private var startLabel: String { language == .english ? "Enter" : language == .french ? "Entrer" : "Entrar" }
}
