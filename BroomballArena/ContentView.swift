import SwiftUI

struct ContentView: View {
    @StateObject private var matchStore = MatchStore()
    @State private var selectedSection: ArenaSection = .live
    @AppStorage("app.language") private var languageRawValue = AppLanguage.english.rawValue

    private var language: AppLanguage {
        AppLanguage.from(languageRawValue)
    }

    var body: some View {
        GeometryReader { proxy in
            if proxy.size.width >= 760 {
                iPadLayout
            } else {
                iPhoneLayout
            }
        }
        .preferredColorScheme(.dark)
    }

    private var iPadLayout: some View {
        NavigationSplitView {
            List {
                ForEach(ArenaSection.allCases) { section in
                    Button {
                        selectedSection = section
                    } label: {
                        Label(section.title(language), systemImage: section.symbol)
                            .foregroundStyle(selectedSection == section ? BrandPalette.yellow : BrandPalette.white)
                    }
                    .listRowBackground(selectedSection == section ? BrandPalette.cardSoft : Color.clear)
                }
            }
            .navigationTitle("Rooball Arena")
            .scrollContentBackground(.hidden)
            .background(BrandPalette.deepNavy)
        } detail: {
            sectionView(selectedSection)
        }
        .environmentObject(matchStore)
        .tint(BrandPalette.yellow)
    }

    private var iPhoneLayout: some View {
        TabView(selection: $selectedSection) {
            ForEach(ArenaSection.allCases) { section in
                sectionView(section)
                    .tag(section)
                    .tabItem {
                        Label(section.title(language), systemImage: section.symbol)
                    }
            }
        }
        .environmentObject(matchStore)
        .tint(BrandPalette.yellow)
    }

    @ViewBuilder
    private func sectionView(_ section: ArenaSection) -> some View {
        switch section {
        case .live:
            MatchCenterView()
        case .coach:
            TrainingView()
        case .atlas:
            CultureView()
        case .club:
            HomeView()
        case .settings:
            SettingsView()
        }
    }
}
