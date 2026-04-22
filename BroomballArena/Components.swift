import SwiftUI

struct BroomBackground: View {
    var body: some View {
        ZStack {
            BrandPalette.deepNavy.ignoresSafeArea()
            LinearGradient(
                colors: [BrandPalette.purple.opacity(0.55), .clear, BrandPalette.yellow.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
}

struct NeonHeader: View {
    let kicker: String
    let title: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(kicker.uppercased())
                .font(.caption.weight(.black))
                .foregroundStyle(BrandPalette.yellow)
            Text(title)
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundStyle(BrandPalette.white)
                .lineLimit(3)
                .minimumScaleFactor(0.68)
            Text(detail)
                .font(.callout)
                .foregroundStyle(BrandPalette.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct GlassPanel<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background(BrandPalette.card.opacity(0.92))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(BrandPalette.white.opacity(0.08), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct MetricStrip: View {
    let items: [(String, String)]

    var body: some View {
        HStack(spacing: 10) {
            ForEach(items.indices, id: \.self) { index in
                VStack(spacing: 4) {
                    Text(items[index].0)
                        .font(.title3.weight(.black))
                        .foregroundStyle(BrandPalette.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Text(items[index].1)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(BrandPalette.secondaryText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(index == 0 ? BrandPalette.yellow.opacity(0.18) : BrandPalette.cardSoft.opacity(0.72))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
    }
}

struct RinkPulseView: View {
    let tempo: Double
    let pressure: Double
    let language: AppLanguage

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height

            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [BrandPalette.cardSoft, BrandPalette.purple.opacity(0.88), BrandPalette.deepNavy],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Path { path in
                    path.addRoundedRect(in: CGRect(x: 18, y: 18, width: w - 36, height: h - 36), cornerSize: CGSize(width: 26, height: 26))
                    path.move(to: CGPoint(x: w / 2, y: 18))
                    path.addLine(to: CGPoint(x: w / 2, y: h - 18))
                    path.addEllipse(in: CGRect(x: w / 2 - 44, y: h / 2 - 44, width: 88, height: 88))
                }
                .stroke(BrandPalette.ice.opacity(0.45), lineWidth: 2)

                heatSpot(label: tempoLabel, value: Int(tempo), color: BrandPalette.yellow, darkText: true)
                    .position(x: w * 0.28, y: h * 0.42)
                heatSpot(label: pressureLabel, value: Int(pressure), color: BrandPalette.red, darkText: false)
                    .position(x: w * 0.72, y: h * 0.58)

                VStack {
                    Text(language == .english ? "Live ice read" : language == .french ? "Lecture glace" : "Lectura pista")
                        .font(.caption.weight(.black))
                        .foregroundStyle(BrandPalette.yellow)
                    Spacer()
                    HStack {
                        Image(systemName: "circle.grid.cross")
                        Text(language == .english ? "Middle lane decides the shift" : language == .french ? "Le centre decide la presence" : "El centro decide el turno")
                    }
                    .font(.caption.weight(.bold))
                    .foregroundStyle(BrandPalette.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(BrandPalette.deepNavy.opacity(0.74))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                .padding(16)
            }
        }
        .frame(height: 238)
    }

    private var tempoLabel: String {
        language == .english ? "Tempo" : language == .french ? "Tempo" : "Ritmo"
    }

    private var pressureLabel: String {
        language == .english ? "Pressure" : language == .french ? "Pression" : "Presion"
    }

    private func heatSpot(label: String, value: Int, color: Color, darkText: Bool) -> some View {
        VStack(spacing: 3) {
            Text("\(value)")
                .font(.title2.weight(.black))
                .monospacedDigit()
            Text(label)
                .font(.caption2.weight(.black))
        }
        .foregroundStyle(darkText ? BrandPalette.navy : BrandPalette.white)
        .frame(width: 74, height: 74)
        .background(color)
        .clipShape(Circle())
        .shadow(color: color.opacity(0.35), radius: 16)
    }
}

struct EmptyStateCard: View {
    let title: String
    let systemImage: String
    let detail: String

    var body: some View {
        GlassPanel {
            VStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.title)
                    .foregroundStyle(BrandPalette.yellow)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(BrandPalette.white)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(BrandPalette.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
