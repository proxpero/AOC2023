import Foundation

let url = Bundle.module.url(forResource: "Input", withExtension: nil)!
let lines = try String(contentsOf: url).split(separator: "\n")

var date = Date()

let p1 = lines.reduce(into: 0) { partialResult, line in
    partialResult += Int("\(line.first(where: \.isNumber)!)\(line.reversed().first(where: \.isNumber)!)")!
}

print("part 1: \(p1), \(-date.timeIntervalSinceNow)")
date = Date()

enum Word: Int, CaseIterable {
    case one = 1, two, three, four, five, six, seven, eight, nine

    func prefix(isReversed: Bool) -> String {
        var prefix = String(describing: self.self)
        if isReversed { prefix = String(prefix.reversed()) }
        return prefix
    }
}

/**
 Look for a number at the start of the line. If none is found,
 drop the first char and recurse. If finding the second digit,
 pass in a reversed substring.
*/
func findNumber(in line: Substring, isReversed: Bool = false) -> Int {
    if let first = line.first, let value = Int(String(first)) {
        return value
    }

    for word in Word.allCases {
        if line.hasPrefix(word.prefix(isReversed: isReversed)) {
            return word.rawValue
        }
    }

    return findNumber(in: line.dropFirst(), isReversed: isReversed)
}

let p2 = lines.reduce(into: 0) { partialResult, line in
    partialResult += (
        findNumber(in: line) * 10 +
        findNumber(in: String(line.reversed())[...], isReversed: true)
    )
}

print("part 2: \(p2), time: \(-date.timeIntervalSinceNow)")

