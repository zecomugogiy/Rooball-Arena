import SwiftUI

enum AppData {
    static func calls(_ language: AppLanguage) -> [CaptainCall] {
        switch language {
        case .english:
            return [
                CaptainCall(title: "Freeze the middle", cue: "Bench call", detail: "Force carriers toward the boards and protect the slot before chasing.", symbol: "shield.lefthalf.filled"),
                CaptainCall(title: "Two-touch exits", cue: "Breakout", detail: "First broom cushions the ball, second broom moves it into open ice.", symbol: "arrow.up.forward"),
                CaptainCall(title: "Low release only", cue: "Safety", detail: "Shots stay below the knee line unless the lane is completely empty.", symbol: "arrow.down.to.line.compact"),
                CaptainCall(title: "Change early", cue: "Stamina", detail: "Call the bench before balance falls apart; tired feet create contact.", symbol: "figure.run")
            ]
        case .french:
            return [
                CaptainCall(title: "Fermer le centre", cue: "Appel banc", detail: "Poussez le porteur vers la bande et protegez l'enclave avant de chasser.", symbol: "shield.lefthalf.filled"),
                CaptainCall(title: "Sortie deux touches", cue: "Relance", detail: "Premier balai amortit, deuxieme balai trouve la glace libre.", symbol: "arrow.up.forward"),
                CaptainCall(title: "Tir bas seulement", cue: "Securite", detail: "Les tirs restent sous le genou sauf si le corridor est vide.", symbol: "arrow.down.to.line.compact"),
                CaptainCall(title: "Changer tot", cue: "Energie", detail: "Appelez le banc avant que l'equilibre casse; la fatigue cree le contact.", symbol: "figure.run")
            ]
        case .spanish:
            return [
                CaptainCall(title: "Cerrar el centro", cue: "Banco", detail: "Lleva al rival a la banda y protege el slot antes de perseguir.", symbol: "shield.lefthalf.filled"),
                CaptainCall(title: "Salida dos toques", cue: "Transicion", detail: "Primera escoba controla, segunda escoba mueve a hielo libre.", symbol: "arrow.up.forward"),
                CaptainCall(title: "Disparo bajo", cue: "Seguridad", detail: "El tiro queda bajo la rodilla salvo que el carril este vacio.", symbol: "arrow.down.to.line.compact"),
                CaptainCall(title: "Cambio temprano", cue: "Energia", detail: "Pide banco antes de perder equilibrio; la fatiga crea contacto.", symbol: "figure.run")
            ]
        }
    }

    static func zones(_ language: AppLanguage) -> [RinkZone] {
        switch language {
        case .english:
            return [
                RinkZone(name: "Slot", shortRule: "Protect first", mistake: "Chasing behind the net too early.", color: BrandPalette.yellow),
                RinkZone(name: "Crease", shortRule: "Agree local access", mistake: "Assuming every rink uses the same crease rule.", color: BrandPalette.red),
                RinkZone(name: "Boards", shortRule: "Angle, do not crash", mistake: "Running straight into contact.", color: BrandPalette.ice),
                RinkZone(name: "Neutral dots", shortRule: "Restart clearly", mistake: "Restarting while players are still confused.", color: BrandPalette.sky)
            ]
        case .french:
            return [
                RinkZone(name: "Enclave", shortRule: "Proteger d'abord", mistake: "Chasser derriere le filet trop tot.", color: BrandPalette.yellow),
                RinkZone(name: "Zone gardien", shortRule: "Acces local", mistake: "Croire que toutes les patinoires ont la meme regle.", color: BrandPalette.red),
                RinkZone(name: "Bandes", shortRule: "Angle, pas choc", mistake: "Courir droit dans le contact.", color: BrandPalette.ice),
                RinkZone(name: "Points neutres", shortRule: "Reprise claire", mistake: "Reprendre quand les joueurs sont confus.", color: BrandPalette.sky)
            ]
        case .spanish:
            return [
                RinkZone(name: "Slot", shortRule: "Proteger primero", mistake: "Perseguir detras de porteria demasiado pronto.", color: BrandPalette.yellow),
                RinkZone(name: "Area", shortRule: "Acordar acceso", mistake: "Pensar que todas las pistas usan la misma regla.", color: BrandPalette.red),
                RinkZone(name: "Bandas", shortRule: "Angulo, no choque", mistake: "Correr directo al contacto.", color: BrandPalette.ice),
                RinkZone(name: "Puntos neutros", shortRule: "Reinicio claro", mistake: "Reiniciar cuando aun hay confusion.", color: BrandPalette.sky)
            ]
        }
    }

    static func practice(_ language: AppLanguage) -> [PracticeBlock] {
        switch language {
        case .english:
            return [
                PracticeBlock(title: "Friction walk", minutes: 5, intensity: 1, detail: "Players learn tiny steps, open hips, and broom-down balance."),
                PracticeBlock(title: "Wall exits", minutes: 8, intensity: 2, detail: "Use boards as a passing partner, then exit into the middle lane."),
                PracticeBlock(title: "Slot denial", minutes: 10, intensity: 3, detail: "Two defenders protect the middle while one carrier tries to enter."),
                PracticeBlock(title: "Chaos minute", minutes: 6, intensity: 4, detail: "Short live burst with mandatory line change on the whistle.")
            ]
        case .french:
            return [
                PracticeBlock(title: "Marche friction", minutes: 5, intensity: 1, detail: "Petits pas, hanches ouvertes et balai bas pour l'equilibre."),
                PracticeBlock(title: "Sorties bande", minutes: 8, intensity: 2, detail: "La bande sert de partenaire, puis sortie vers le corridor central."),
                PracticeBlock(title: "Refus enclave", minutes: 10, intensity: 3, detail: "Deux defenseurs protegent le milieu contre un porteur."),
                PracticeBlock(title: "Minute chaos", minutes: 6, intensity: 4, detail: "Court jeu live avec changement obligatoire au sifflet.")
            ]
        case .spanish:
            return [
                PracticeBlock(title: "Caminata friccion", minutes: 5, intensity: 1, detail: "Pasos cortos, caderas abiertas y escoba baja para equilibrio."),
                PracticeBlock(title: "Salidas por banda", minutes: 8, intensity: 2, detail: "Usa la banda como pase y sale al carril central."),
                PracticeBlock(title: "Negar slot", minutes: 10, intensity: 3, detail: "Dos defensas protegen el medio contra un portador."),
                PracticeBlock(title: "Minuto caos", minutes: 6, intensity: 4, detail: "Juego corto con cambio obligatorio al silbato.")
            ]
        }
    }

    static func clubCards(_ language: AppLanguage) -> [ClubCard] {
        switch language {
        case .english:
            return [
                ClubCard(title: "Rookie night format", value: "4v4 + goalie", detail: "Smaller sides create more touches and fewer collisions.", symbol: "person.2"),
                ClubCard(title: "Fan prompt", value: "Sweep check", detail: "Ask fans to vote on the cleanest defensive sweep after each period.", symbol: "megaphone"),
                ClubCard(title: "Captain kit", value: "12 items", detail: "Helmets, shoes, brooms, ball, cones, tape, towels, roster, whistle, water, first aid, spare gloves.", symbol: "duffle.bag"),
                ClubCard(title: "Post-game note", value: "1 takeaway", detail: "Pin one teaching point before everyone leaves the rink.", symbol: "pin")
            ]
        case .french:
            return [
                ClubCard(title: "Soiree recrues", value: "4v4 + gardien", detail: "Moins de joueurs donne plus de touches et moins de collisions.", symbol: "person.2"),
                ClubCard(title: "Signal fans", value: "Balayage", detail: "Faites voter le meilleur balayage defensif apres chaque periode.", symbol: "megaphone"),
                ClubCard(title: "Kit capitaine", value: "12 items", detail: "Casques, souliers, balais, balle, cones, ruban, serviettes, roster, sifflet, eau, premiers soins, gants.", symbol: "duffle.bag"),
                ClubCard(title: "Note finale", value: "1 idee", detail: "Epinglez un point d'apprentissage avant de quitter la patinoire.", symbol: "pin")
            ]
        case .spanish:
            return [
                ClubCard(title: "Noche novatos", value: "4v4 + portero", detail: "Menos jugadores da mas toques y menos choques.", symbol: "person.2"),
                ClubCard(title: "Pregunta fan", value: "Barrido", detail: "Vota el barrido defensivo mas limpio tras cada periodo.", symbol: "megaphone"),
                ClubCard(title: "Kit capitan", value: "12 items", detail: "Cascos, zapatos, escobas, bola, conos, cinta, toallas, lista, silbato, agua, botiquin, guantes.", symbol: "duffle.bag"),
                ClubCard(title: "Nota final", value: "1 idea", detail: "Fija un aprendizaje antes de salir de la pista.", symbol: "pin")
            ]
        }
    }

    static func clubProfiles(_ language: AppLanguage) -> [ClubProfile] {
        switch language {
        case .english:
            return [
                ClubProfile(name: "Ottawa Nationals", category: "Men - Senior Nationals", region: "Canada", note: "Listed in Broomball Canada's 2026 Senior Nationals men's division.", source: "Broomball Canada", color: BrandPalette.yellow),
                ClubProfile(name: "Bruno Axemen", category: "Men / U20 Boys", region: "Canada", note: "Appears in both Senior Nationals men's and U20 boys listings.", source: "Broomball Canada", color: BrandPalette.ice),
                ClubProfile(name: "Les Boys", category: "Men - Senior Nationals", region: "Canada", note: "Senior Nationals men's team listed in the national schedule hub.", source: "Broomball Canada", color: BrandPalette.violet),
                ClubProfile(name: "Minto Selects", category: "Men - Senior Nationals", region: "Canada", note: "Senior Nationals men's team from the 2026 national competition list.", source: "Broomball Canada", color: BrandPalette.sky),
                ClubProfile(name: "Broom-Shak", category: "Mixed - Senior Nationals", region: "Canada", note: "Mixed division team with a recorded 2-1 final over Gladiateurs on Apr. 11, 2026.", source: "Broomball Canada", color: BrandPalette.yellow),
                ClubProfile(name: "Grey Bruce Storm", category: "Women - Senior Nationals", region: "Canada", note: "Women's division team with a 1-0 final over Phoenix on Apr. 11, 2026.", source: "Broomball Canada", color: BrandPalette.ice),
                ClubProfile(name: "Finch Youth Broomball", category: "Youth program", region: "Finch, Ontario", note: "Community youth broomball program focused on inclusive, affordable winter sport.", source: "Finch Youth Broomball", color: BrandPalette.orange),
                ClubProfile(name: "Nova Scotia Broomball Association", category: "Provincial sport organization", region: "Nova Scotia", note: "Provincial organization developing and promoting broomball programs at multiple skill levels.", source: "Nova Scotia Broomball Association", color: BrandPalette.red)
            ]
        case .french:
            return [
                ClubProfile(name: "Ottawa Nationals", category: "Hommes - Nationals senior", region: "Canada", note: "Equipe listee dans la division masculine des Nationals senior 2026.", source: "Broomball Canada", color: BrandPalette.yellow),
                ClubProfile(name: "Bruno Axemen", category: "Hommes / U20 garcons", region: "Canada", note: "Nom present dans les listes masculines senior et U20 garcons.", source: "Broomball Canada", color: BrandPalette.ice),
                ClubProfile(name: "Les Boys", category: "Hommes - Nationals senior", region: "Canada", note: "Equipe masculine senior listee dans le hub national.", source: "Broomball Canada", color: BrandPalette.violet),
                ClubProfile(name: "Minto Selects", category: "Hommes - Nationals senior", region: "Canada", note: "Equipe masculine senior dans la liste nationale 2026.", source: "Broomball Canada", color: BrandPalette.sky),
                ClubProfile(name: "Broom-Shak", category: "Mixte - Nationals senior", region: "Canada", note: "Equipe mixte avec une finale 2-1 contre Gladiateurs le 11 avril 2026.", source: "Broomball Canada", color: BrandPalette.yellow),
                ClubProfile(name: "Grey Bruce Storm", category: "Femmes - Nationals senior", region: "Canada", note: "Equipe feminine avec une finale 1-0 contre Phoenix le 11 avril 2026.", source: "Broomball Canada", color: BrandPalette.ice),
                ClubProfile(name: "Finch Youth Broomball", category: "Programme jeunesse", region: "Finch, Ontario", note: "Programme communautaire jeunesse axe sur un sport d'hiver inclusif et abordable.", source: "Finch Youth Broomball", color: BrandPalette.orange),
                ClubProfile(name: "Nova Scotia Broomball Association", category: "Organisation provinciale", region: "Nouvelle-Ecosse", note: "Organisation provinciale qui developpe et promeut des programmes de broomball.", source: "Nova Scotia Broomball Association", color: BrandPalette.red)
            ]
        case .spanish:
            return [
                ClubProfile(name: "Ottawa Nationals", category: "Hombres - Senior Nationals", region: "Canada", note: "Equipo listado en la division masculina senior de 2026.", source: "Broomball Canada", color: BrandPalette.yellow),
                ClubProfile(name: "Bruno Axemen", category: "Hombres / U20", region: "Canada", note: "Aparece en listas masculinas senior y U20.", source: "Broomball Canada", color: BrandPalette.ice),
                ClubProfile(name: "Les Boys", category: "Hombres - Senior Nationals", region: "Canada", note: "Equipo masculino senior listado en el hub nacional.", source: "Broomball Canada", color: BrandPalette.violet),
                ClubProfile(name: "Minto Selects", category: "Hombres - Senior Nationals", region: "Canada", note: "Equipo masculino senior en la lista nacional 2026.", source: "Broomball Canada", color: BrandPalette.sky),
                ClubProfile(name: "Broom-Shak", category: "Mixto - Senior Nationals", region: "Canada", note: "Equipo mixto con final 2-1 sobre Gladiateurs el 11 de abril de 2026.", source: "Broomball Canada", color: BrandPalette.yellow),
                ClubProfile(name: "Grey Bruce Storm", category: "Mujeres - Senior Nationals", region: "Canada", note: "Equipo femenino con final 1-0 sobre Phoenix el 11 de abril de 2026.", source: "Broomball Canada", color: BrandPalette.ice),
                ClubProfile(name: "Finch Youth Broomball", category: "Programa juvenil", region: "Finch, Ontario", note: "Programa juvenil comunitario enfocado en deporte de invierno inclusivo y accesible.", source: "Finch Youth Broomball", color: BrandPalette.orange),
                ClubProfile(name: "Nova Scotia Broomball Association", category: "Organizacion provincial", region: "Nova Scotia", note: "Organizacion provincial que desarrolla y promueve programas de broomball.", source: "Nova Scotia Broomball Association", color: BrandPalette.red)
            ]
        }
    }

    static func gameEvents(_ language: AppLanguage) -> [GameEvent] {
        let venue = language == .french ? "Nationals 2026" : language == .spanish ? "Nationals 2026" : "2026 Nationals"
        let final = language == .french ? "Final" : language == .spanish ? "Final" : "Final"
        return [
            GameEvent(date: "Apr 9, 2026", time: "8:55 PM", division: "Mixed - Senior Nationals", home: "Team NB (Mixed)", away: "Vikings", venue: venue, status: final, result: "1 - 2"),
            GameEvent(date: "Apr 9, 2026", time: "8:55 PM", division: "Men - Senior Nationals", home: "Lacombe", away: "Les Mascots", venue: venue, status: final, result: "7 - 0"),
            GameEvent(date: "Apr 11, 2026", time: "11:40 AM", division: "Masters Men - Senior Nationals", home: "As/Pogos", away: "Monconseiller", venue: venue, status: final, result: "1 - 2"),
            GameEvent(date: "Apr 11, 2026", time: "12:50 PM", division: "Mixed - Senior Nationals", home: "Broom-Shak", away: "Gladiateurs", venue: venue, status: final, result: "2 - 1"),
            GameEvent(date: "Apr 11, 2026", time: "2:00 PM", division: "Women - Senior Nationals", home: "Phoenix", away: "Grey Bruce Storm", venue: venue, status: final, result: "0 - 1"),
            GameEvent(date: "Apr 11, 2026", time: "3:10 PM", division: "Men - Senior Nationals", home: "Ottawa Nationals", away: "Les Boys", venue: venue, status: final, result: "0 - 1")
        ]
    }

    static func quiz(_ language: AppLanguage) -> [QuizQuestion] {
        switch language {
        case .english:
            return [
                QuizQuestion(prompt: "A winger loses balance late in a shift. What should the captain call?", answers: ["Change early", "Swing higher", "Crowd the crease"], correctIndex: 0, explanation: "Early changes keep tired players from creating accidental contact."),
                QuizQuestion(prompt: "Why does the crease need a pre-game note?", answers: ["Rules vary locally", "It is never used", "Only fans enter it"], correctIndex: 0, explanation: "Crease access changes by rink, league, and event format."),
                QuizQuestion(prompt: "What is the safest shot cue for beginners?", answers: ["Low release", "Full baseball swing", "Blind backhand"], correctIndex: 0, explanation: "Low releases keep the broom controlled and easier to officiate.")
            ]
        case .french:
            return [
                QuizQuestion(prompt: "Un ailier perd l'equilibre en fin de presence. Quel appel?", answers: ["Changer tot", "Balai plus haut", "Bloquer la zone"], correctIndex: 0, explanation: "Changer tot evite les contacts causes par la fatigue."),
                QuizQuestion(prompt: "Pourquoi noter la zone avant le match?", answers: ["La regle varie", "Elle ne sert jamais", "Seuls les fans y entrent"], correctIndex: 0, explanation: "L'acces a la zone change selon patinoire, ligue et format."),
                QuizQuestion(prompt: "Quel signal de tir pour debutants?", answers: ["Tir bas", "Swing baseball", "Revers aveugle"], correctIndex: 0, explanation: "Le tir bas garde le balai controle et facile a arbitrer.")
            ]
        case .spanish:
            return [
                QuizQuestion(prompt: "Un ala pierde equilibrio al final del turno. Que se pide?", answers: ["Cambio temprano", "Swing alto", "Cargar el area"], correctIndex: 0, explanation: "Cambiar temprano evita contactos por fatiga."),
                QuizQuestion(prompt: "Por que hablar del area antes?", answers: ["La regla varia", "Nunca se usa", "Solo entran fans"], correctIndex: 0, explanation: "El acceso al area cambia por pista, liga y formato."),
                QuizQuestion(prompt: "Senal segura de tiro para novatos?", answers: ["Disparo bajo", "Swing de beisbol", "Reves ciego"], correctIndex: 0, explanation: "El disparo bajo mantiene control y arbitraje simple.")
            ]
        }
    }
}
