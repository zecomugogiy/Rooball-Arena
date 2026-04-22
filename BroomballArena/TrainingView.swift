import SwiftUI

struct TrainingView: View {
    @AppStorage("app.language") private var languageRawValue = AppLanguage.english.rawValue
    @State private var runners = 5.0
    @State private var blockers = 2.0
    @State private var shiftLength = 45.0
    @State private var remainingShift = 45
    @State private var timerRunning = false
    @State private var warmupReady = false
    @State private var safetyReady = false
    @State private var rolesReady = false
    @State private var captainNote = ""
    @State private var players = ["Captain", "Low broom", "Slot guard", "Wall exit", "Goalie"]
    @State private var completed: Set<UUID> = []

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var language: AppLanguage {
        AppLanguage.from(languageRawValue)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    NeonHeader(kicker: kicker, title: title, detail: detail)
                    formationLab
                    shiftConsole
                    rosterBoard
                    readinessPanel
                    practiceLadder
                }
                .padding(20)
                .frame(maxWidth: 980)
                .frame(maxWidth: .infinity)
            }
            .background(BroomBackground())
            .navigationTitle(ArenaSection.coach.title(language))
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(ticker) { _ in
                guard timerRunning, remainingShift > 0 else { return }
                remainingShift -= 1
                if remainingShift == 0 { timerRunning = false }
            }
            .onChange(of: shiftLength) { newValue in
                remainingShift = Int(newValue)
                timerRunning = false
            }
        }
    }

    private var formationLab: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(labTitle)
                            .font(.title3.weight(.black))
                            .foregroundStyle(BrandPalette.white)
                        Text(labDetail)
                            .font(.subheadline)
                            .foregroundStyle(BrandPalette.secondaryText)
                    }
                    Spacer()
                    Text("\(Int(runners))-\(Int(blockers))-G")
                        .font(.title2.weight(.black))
                        .foregroundStyle(BrandPalette.yellow)
                }

                miniFormation

                VStack(spacing: 12) {
                    sliderRow(title: runnersLabel, value: $runners, range: 3...6)
                    sliderRow(title: blockersLabel, value: $blockers, range: 1...3)
                }

                Text(systemAdvice)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(BrandPalette.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var shiftConsole: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(shiftTitle)
                            .font(.title3.weight(.black))
                            .foregroundStyle(BrandPalette.white)
                        Text(shiftDetail)
                            .font(.subheadline)
                            .foregroundStyle(BrandPalette.secondaryText)
                    }
                    Spacer()
                    Text(shiftClock)
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(remainingShift < 10 ? BrandPalette.red : BrandPalette.yellow)
                }

                Slider(value: $shiftLength, in: 30...90, step: 15)
                    .tint(BrandPalette.yellow)

                HStack(spacing: 12) {
                    Button(timerRunning ? pauseLabel : startLabel) {
                        if remainingShift == 0 { remainingShift = Int(shiftLength) }
                        timerRunning.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(BrandPalette.yellow)
                    .foregroundStyle(BrandPalette.navy)

                    Button(resetShiftLabel) {
                        timerRunning = false
                        remainingShift = Int(shiftLength)
                    }
                    .buttonStyle(.bordered)

                    Button(whistleLabel) {
                        timerRunning = false
                        remainingShift = Int(shiftLength)
                    }
                    .buttonStyle(.bordered)
                    .tint(BrandPalette.red)
                }
            }
        }
    }

    private var rosterBoard: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 14) {
                Text(rosterTitle)
                    .font(.title3.weight(.black))
                    .foregroundStyle(BrandPalette.white)

                ForEach(players.indices, id: \.self) { index in
                    HStack(spacing: 10) {
                        Text(roleLabel(index))
                            .font(.caption.weight(.black))
                            .foregroundStyle(BrandPalette.navy)
                            .frame(width: 58, height: 30)
                            .background(index == 0 ? BrandPalette.yellow : BrandPalette.ice)
                            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))

                        TextField(playerPlaceholder, text: $players[index])
                            .foregroundStyle(BrandPalette.white)
                            .textInputAutocapitalization(.words)
                            .padding(10)
                            .background(BrandPalette.deepNavy)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                }

                TextField(notePlaceholder, text: $captainNote, axis: .vertical)
                    .lineLimit(2...4)
                    .foregroundStyle(BrandPalette.white)
                    .padding(12)
                    .background(BrandPalette.deepNavy)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
    }

    private var readinessPanel: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(readinessTitle)
                            .font(.title3.weight(.black))
                            .foregroundStyle(BrandPalette.white)
                        Text("\(readinessScore)%")
                            .font(.largeTitle.weight(.black))
                            .foregroundStyle(BrandPalette.yellow)
                    }
                    Spacer()
                    Image(systemName: readinessScore == 100 ? "checkmark.seal.fill" : "gauge.with.dots.needle.50percent")
                        .font(.largeTitle)
                        .foregroundStyle(readinessScore == 100 ? BrandPalette.ice : BrandPalette.yellow)
                }

                Toggle(warmupLabel, isOn: $warmupReady)
                Toggle(safetyLabel, isOn: $safetyReady)
                Toggle(rolesLabel, isOn: $rolesReady)
            }
            .tint(BrandPalette.yellow)
        }
    }

    private var miniFormation: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(BrandPalette.deepNavy)
                ForEach(0..<Int(runners), id: \.self) { index in
                    playerDot(color: BrandPalette.yellow, label: "R", darkText: true)
                        .position(x: w * (0.18 + CGFloat(index) * 0.13), y: h * 0.38)
                }
                ForEach(0..<Int(blockers), id: \.self) { index in
                    playerDot(color: BrandPalette.ice, label: "B", darkText: true)
                        .position(x: w * (0.36 + CGFloat(index) * 0.18), y: h * 0.66)
                }
                playerDot(color: BrandPalette.red, label: "G", darkText: false)
                    .position(x: w * 0.86, y: h * 0.50)
            }
        }
        .frame(height: 190)
    }

    private func playerDot(color: Color, label: String, darkText: Bool) -> some View {
        Text(label)
            .font(.caption.weight(.black))
            .foregroundStyle(darkText ? BrandPalette.navy : BrandPalette.white)
            .frame(width: 38, height: 38)
            .background(color)
            .clipShape(Circle())
    }

    private func sliderRow(title: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(BrandPalette.white)
                Spacer()
                Text("\(Int(value.wrappedValue))")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(BrandPalette.yellow)
            }
            Slider(value: value, in: range, step: 1)
                .tint(BrandPalette.yellow)
        }
    }

    private var practiceLadder: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(ladderTitle)
                .font(.title2.weight(.black))
                .foregroundStyle(BrandPalette.white)

            ForEach(AppData.practice(language)) { block in
                Button {
                    if completed.contains(block.id) {
                        completed.remove(block.id)
                    } else {
                        completed.insert(block.id)
                    }
                } label: {
                    GlassPanel {
                        HStack(alignment: .top, spacing: 12) {
                            VStack(spacing: 4) {
                                Text("\(block.minutes)")
                                    .font(.title3.weight(.black))
                                Text("MIN")
                                    .font(.caption2.weight(.black))
                            }
                            .foregroundStyle(BrandPalette.navy)
                            .frame(width: 54, height: 54)
                            .background(completed.contains(block.id) ? BrandPalette.ice : BrandPalette.yellow)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(block.title)
                                        .font(.headline)
                                        .foregroundStyle(BrandPalette.white)
                                    Spacer()
                                    intensityDots(block.intensity)
                                }
                                Text(block.detail)
                                    .font(.subheadline)
                                    .foregroundStyle(BrandPalette.secondaryText)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func intensityDots(_ count: Int) -> some View {
        HStack(spacing: 3) {
            ForEach(1...4, id: \.self) { index in
                Circle()
                    .fill(index <= count ? BrandPalette.yellow : BrandPalette.mutedText)
                    .frame(width: 7, height: 7)
            }
        }
    }

    private var shiftClock: String {
        String(format: ":%02d", remainingShift)
    }

    private var readinessScore: Int {
        [warmupReady, safetyReady, rolesReady].filter { $0 }.count * 100 / 3
    }

    private var systemAdvice: String {
        if runners >= 6 {
            return language == .english ? "Wide runner shape: use it when the rink has space and players can change early." : language == .french ? "Forme large: utile avec espace et changements rapides." : "Forma amplia: util si hay espacio y cambios rapidos."
        }
        if blockers >= 3 {
            return language == .english ? "Heavy blocker shape: better for protecting the slot and slowing stronger teams." : language == .french ? "Bloc lourd: mieux pour proteger l'enclave et ralentir une equipe forte." : "Bloqueo pesado: mejor para proteger el slot y frenar rivales fuertes."
        }
        return language == .english ? "Balanced shape: good default for rookie nights and mixed skill benches." : language == .french ? "Forme equilibree: bon defaut pour recrues et banc mixte." : "Forma equilibrada: buena base para novatos y banco mixto."
    }

    private func roleLabel(_ index: Int) -> String {
        switch index {
        case 0: return language == .english ? "CAP" : language == .french ? "CAP" : "CAP"
        case 1: return language == .english ? "LOW" : language == .french ? "BAS" : "BAJO"
        case 2: return language == .english ? "SLOT" : language == .french ? "ZONE" : "SLOT"
        case 3: return language == .english ? "WALL" : language == .french ? "BANDE" : "BANDA"
        default: return language == .english ? "GOAL" : language == .french ? "GARD" : "PORT"
        }
    }

    private var kicker: String { language == .english ? "Tactical workshop" : language == .french ? "Atelier tactique" : "Taller tactico" }
    private var title: String { language == .english ? "Build a lineup before players hit the ice." : language == .french ? "Construisez la ligne avant la glace." : "Construye la linea antes del hielo." }
    private var detail: String { language == .english ? "A coach-first board for formation choices and a practice ladder that feels different from a rule book." : language == .french ? "Un tableau de coach pour les choix de formation et une echelle de pratique." : "Una pizarra de coach para formacion y una escalera de practica." }
    private var labTitle: String { language == .english ? "Line Shape Lab" : language == .french ? "Laboratoire ligne" : "Laboratorio linea" }
    private var labDetail: String { language == .english ? "Tune the shape for rookie nights, tournaments, or short benches." : language == .french ? "Ajustez pour recrues, tournois ou banc court." : "Ajusta para novatos, torneos o banco corto." }
    private var runnersLabel: String { language == .english ? "Runners" : language == .french ? "Coureurs" : "Corredores" }
    private var blockersLabel: String { language == .english ? "Blockers" : language == .french ? "Bloqueurs" : "Bloqueadores" }
    private var ladderTitle: String { language == .english ? "Practice Ladder" : language == .french ? "Echelle pratique" : "Escalera practica" }
    private var shiftTitle: String { language == .english ? "Shift Timer" : language == .french ? "Chrono presence" : "Temporizador" }
    private var shiftDetail: String { language == .english ? "Keep beginners fresh with repeatable bench rhythm." : language == .french ? "Gardez les debutants frais avec un rythme clair." : "Mantiene frescos a novatos con ritmo claro." }
    private var startLabel: String { language == .english ? "Start" : language == .french ? "Demarrer" : "Iniciar" }
    private var pauseLabel: String { language == .english ? "Pause" : language == .french ? "Pause" : "Pausa" }
    private var resetShiftLabel: String { language == .english ? "Reset" : language == .french ? "Reset" : "Reset" }
    private var whistleLabel: String { language == .english ? "Whistle change" : language == .french ? "Sifflet" : "Silbato" }
    private var rosterTitle: String { language == .english ? "Role Board" : language == .french ? "Tableau roles" : "Roles" }
    private var playerPlaceholder: String { language == .english ? "Player or assignment" : language == .french ? "Joueur ou mission" : "Jugador o tarea" }
    private var notePlaceholder: String { language == .english ? "Tactical note for the next rep" : language == .french ? "Note tactique pour la prochaine repetition" : "Nota tactica para la proxima repeticion" }
    private var readinessTitle: String { language == .english ? "Rink Readiness" : language == .french ? "Pret pour glace" : "Listo para pista" }
    private var warmupLabel: String { language == .english ? "Warmup lanes set" : language == .french ? "Corridors echauffement prets" : "Carriles de calentamiento listos" }
    private var safetyLabel: String { language == .english ? "Low-broom safety brief done" : language == .french ? "Brief securite balai bas fait" : "Brief de escoba baja hecho" }
    private var rolesLabel: String { language == .english ? "Captain roles assigned" : language == .french ? "Roles capitaine assignes" : "Roles asignados" }
}
