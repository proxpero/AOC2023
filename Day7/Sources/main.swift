import Foundation

let url = Bundle.module.url(forResource: "Input", withExtension: nil)!
var lines = try String(contentsOf: url).split(separator: "\n")

//lines = """
//32T3K 765
//T55J5 684
//KK677 28
//KTJJT 220
//QQQJA 483
//""".split(separator: "\n")

struct Hand: Comparable {
    enum HandType: Int {
        case highCard, onePair, twoPair, threeOfAKind, fullHouse, fourOfAKind, fiveOfAKind
    }

    let cards: [Int]
    var handType: HandType
    let bid: Int

    static func < (lhs: Hand, rhs: Hand) -> Bool {
        let left = lhs.handType.rawValue
        let right = rhs.handType.rawValue
        if left != right { return left < right }

        for (l, r) in zip(lhs.cards, rhs.cards) {
            if l != r { return l < r }
        }

        return false
    }
}

extension Hand {
    init(line: Substring, isUsingJokers: Bool = false) {
        let values = line.split(separator: " ")
        func value(for char: Character) -> Int {
            switch char {
            case "T": 10
            case "J": isUsingJokers ? 1 : 11
            case "Q": 12
            case "K": 13
            case "A": 14
            default: Int(String(char))!
            }
        }
        
        let cards = values[0].reduce(into: [Int]()) { $0.append(value(for: $1)) }
        self.cards = cards
        self.handType = isUsingJokers ? .init(withJokers: cards) : .init(cards: cards)
        self.bid = Int(String(values[1]))!
    }
}

extension Hand.HandType {
    init(cards: [Int]) {
        let dict = cards.reduce(into: [Int: Int]()) { $0[$1, default: 0] += 1 }

        if dict.count == 1 {
            self = .fiveOfAKind
        } 

        else if dict.count == 2 {
            if dict.values.sorted().last! == 4 {
                self = .fourOfAKind
            } else {
                self = .fullHouse
            }
        }

        else if dict.count == 3 {
            if dict.values.sorted().last! == 3 {
                self = .threeOfAKind
            } else {
                self = .twoPair
            }
        }
        
        else if dict.count == 4 {
            self = .onePair
        }

        else {
            self = .highCard
        }
    }

    init(withJokers cards: [Int]) {
        let bestCard = cards.bestCard
        var result: [Int] = []
        for card in cards {
            result.append(card == 1 ? bestCard : card)
        }

        self = .init(cards: result)
    }
}

extension Array<Int> {
    var bestCard: Int {
        self.filter { $0 != 1 }
            .reduce(into: [Int: Int]()) { $0[$1, default: 0] += 1 }
            .sorted { $0.value > $1.value }
            .first?.key ?? 1
    }
}

var date = Date()
let p1 = lines
    .map { Hand(line: $0, isUsingJokers: false) }
    .sorted().enumerated()
    .reduce(into: 0) { $0 += $1.element.bid * ($1.offset + 1) }

print(p1, "time: \(-date.timeIntervalSinceNow)")

date = Date()
let p2 = lines
    .map { Hand(line: $0, isUsingJokers: true) }
    .sorted().enumerated()
    .reduce(into: 0) { $0 += $1.element.bid * ($1.offset + 1) }

print(p2, "time: \(-date.timeIntervalSinceNow)")
