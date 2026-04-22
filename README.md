# Rooball Arena

Rooball Arena is a SwiftUI iPhone and iPad app for broomball fans, captains, school demos, campus rec nights, and small rink organizers who need a practical offline match companion.

## Product

- Dark purple and sport-yellow visual system inspired by premium match-day apps.
- Offline match center with editable teams, goals, shots, faceoff side, period clock, undo, reset, and saved results.
- Graphic rink rules with visual labels for faceoff, crease, and low-broom safety.
- Team bench profiles that fans can favorite and organizers can use as ready-made team identities.
- Gear checklist for captains before stepping on the ice.
- Short practice plan for beginner groups: balance, passing, low shots, and bench rhythm.
- Learn section with rules, short history, privacy controls, and an interactive quiz.
- In-app language switch for English, French, and Spanish.
- iPhone and iPad target support.

## Technical Notes

- Platform: iOS 16.6+
- Framework: SwiftUI
- Persistence: UserDefaults via Codable models
- Network: none
- Account system: none
- External dependencies: none

## Release Checklist

1. Open `BroomballArena.xcodeproj` in Xcode.
2. Set the Bundle Identifier to your App Store Connect identifier if needed.
3. Select your Apple Developer Team under Signing & Capabilities.
4. Archive with a generic iOS device destination.
5. Upload through Xcode Organizer.

## Suggested App Store Metadata

Name: Rooball Arena

Subtitle: Broomball score, rules, and training

Keywords: broomball, rink, scoreboard, winter sport, training, rules, club, school, ice, timer

Category: Sports

Privacy: The app does not collect personal data. Match history is stored locally on device.
