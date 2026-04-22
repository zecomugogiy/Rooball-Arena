import SwiftUI

struct CultureView: View {
    @AppStorage("app.language") private var languageRawValue = AppLanguage.english.rawValue
    @State private var selectedAnswer: Int?
    @State private var quizIndex = 0

    private var language: AppLanguage {
        AppLanguage.from(languageRawValue)
    }

    private var quiz: [QuizQuestion] {
        AppData.quiz(language)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    NeonHeader(kicker: kicker, title: title, detail: detail)
                    zoneAtlas
                    quizModule
                }
                .padding(20)
                .frame(maxWidth: 980)
                .frame(maxWidth: .infinity)
            }
            .background(BroomBackground())
            .navigationTitle(ArenaSection.atlas.title(language))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var zoneAtlas: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(zoneTitle)
                .font(.title2.weight(.black))
                .foregroundStyle(BrandPalette.white)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 240), spacing: 12)], spacing: 12) {
                ForEach(AppData.zones(language)) { zone in
                    GlassPanel {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Circle()
                                    .fill(zone.color)
                                    .frame(width: 16, height: 16)
                                Text(zone.name)
                                    .font(.title3.weight(.black))
                                    .foregroundStyle(BrandPalette.white)
                                Spacer()
                            }
                            Text(zone.shortRule)
                                .font(.headline)
                                .foregroundStyle(BrandPalette.yellow)
                            Text(zone.mistake)
                                .font(.subheadline)
                                .foregroundStyle(BrandPalette.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }

    private var quizModule: some View {
        let question = quiz[quizIndex]

        return GlassPanel {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(quizTitle)
                            .font(.title2.weight(.black))
                            .foregroundStyle(BrandPalette.white)
                        Text("\(quizIndex + 1) / \(quiz.count)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(BrandPalette.secondaryText)
                    }
                    Spacer()
                    Image(systemName: "checklist.checked")
                        .font(.title2)
                        .foregroundStyle(BrandPalette.yellow)
                }

                Text(question.prompt)
                    .font(.headline)
                    .foregroundStyle(BrandPalette.white)
                    .fixedSize(horizontal: false, vertical: true)

                ForEach(question.answers.indices, id: \.self) { index in
                    Button {
                        selectedAnswer = index
                    } label: {
                        HStack {
                            Image(systemName: icon(for: index, question: question))
                            Text(question.answers[index])
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(foreground(for: index, question: question))
                        .background(background(for: index, question: question))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }

                if selectedAnswer != nil {
                    Text(question.explanation)
                        .font(.footnote)
                        .foregroundStyle(BrandPalette.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Button(quizIndex == quiz.count - 1 ? restartLabel : nextLabel) {
                        if quizIndex == quiz.count - 1 {
                            quizIndex = 0
                        } else {
                            quizIndex += 1
                        }
                        selectedAnswer = nil
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(BrandPalette.yellow)
                    .foregroundStyle(BrandPalette.navy)
                }
            }
        }
    }

    private func icon(for index: Int, question: QuizQuestion) -> String {
        guard let selectedAnswer else { return "circle" }
        if index == question.correctIndex { return "checkmark.circle.fill" }
        if index == selectedAnswer { return "xmark.circle.fill" }
        return "circle"
    }

    private func foreground(for index: Int, question: QuizQuestion) -> Color {
        guard let selectedAnswer else { return BrandPalette.white }
        if index == question.correctIndex { return .green }
        if index == selectedAnswer { return .red }
        return BrandPalette.secondaryText
    }

    private func background(for index: Int, question: QuizQuestion) -> Color {
        guard let selectedAnswer else { return BrandPalette.deepNavy }
        if index == question.correctIndex { return Color.green.opacity(0.16) }
        if index == selectedAnswer { return Color.red.opacity(0.14) }
        return BrandPalette.deepNavy
    }

    private var kicker: String { language == .english ? "Interactive rule atlas" : language == .french ? "Atlas interactif" : "Atlas interactivo" }
    private var title: String { language == .english ? "Teach zones, not paragraphs." : language == .french ? "Expliquez les zones, pas des paragraphes." : "Enseña zonas, no parrafos." }
    private var detail: String { language == .english ? "The app now frames broomball as decisions on the rink: where to protect, when to restart, and what mistake to avoid." : language == .french ? "Le broomball devient une lecture de zones: quoi proteger, quand reprendre et quelle erreur eviter." : "Broomball se explica por zonas: que proteger, cuando reiniciar y que error evitar." }
    private var zoneTitle: String { language == .english ? "Rink Zones" : language == .french ? "Zones de glace" : "Zonas de pista" }
    private var quizTitle: String { language == .english ? "Captain Check" : language == .french ? "Check capitaine" : "Check capitan" }
    private var nextLabel: String { language == .english ? "Next" : language == .french ? "Suivant" : "Siguiente" }
    private var restartLabel: String { language == .english ? "Restart" : language == .french ? "Recommencer" : "Reiniciar" }
}
