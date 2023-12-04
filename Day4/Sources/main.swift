import Foundation

let url = Bundle.module.url(forResource: "Input", withExtension: nil)!
let lines = try String(contentsOf: url).split(separator: "\n")

struct Card {
    let id: Int
    let numbers: Set<Int>
    let winners: Set<Int>

    var matches: Int {
        var result = 0
        for number in numbers {
            if winners.contains(number) {
                result += 1
            }
        }

        return result
    }

    var points: Int {
        Int(pow(2.0, Double(matches - 1)))
    }

    var copies: [Int] {
        matches == 0 ? [] : Array(id + 1 ... id + matches)
    }
}

struct CardManager {
    let cards: [Card]

    init(lines: [Substring]) {
        self.cards = lines.map(Card.init)
    }

    var points: Int {
        cards.reduce(into: 0) { $0 += $1.points }
    }

    var totalCopies: Int {
        var matches = cards.reduce(into: [Int: Int]()) { $0[$1.id] = 1 }

        for card in cards {
            for copy in card.copies {
                let count = matches[card.id]!
                matches[copy]? += count
            }
        }

        return matches.values.reduce(0, +)
    }
}

extension Card {
    init(line: Substring) {
        let input = line.split(separator: ":")
        self.id = Int(String(input[0].split(separator: " ")[1]))!
        let numbers = input[1].split(separator: "|")
        self.winners = Set(numbers[0].split(separator: " ").map { Int(String($0))! })
        self.numbers = Set(numbers[1].split(separator: " ").map { Int(String($0))! })
    }
}

var date = Date()

let cards = CardManager(lines: lines)

print("part 1: \(cards.points), time: \(-date.timeIntervalSinceNow)")

date = Date()

print("part 2: \(cards.totalCopies), time: \(-date.timeIntervalSinceNow)")
