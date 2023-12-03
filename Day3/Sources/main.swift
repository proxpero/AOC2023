import Foundation

let url = Bundle.module.url(forResource: "Input", withExtension: nil)!
let lines = try String(contentsOf: url).split(separator: "\n")

struct Engine {
    enum Part {
        case digit(Character)
        case symbol(Character)
        case empty

        var digit: Character? {
            switch self {
            case .digit(let value):
                return value
            default:
                return nil
            }
        }

        var isDigit: Bool {
            digit != nil
        }

        var isGear: Bool {
            switch self {
            case .symbol(let char):
                char == "*"
            default:
                false
            }
        }
    }

    struct Address: Hashable {
        var row, col: Int
    }

    let parts: [[Part]]
    let symbolAddrs: Set<Address>

    subscript(row: Int, col: Int) -> Part {
        parts[row][col]
    }

    subscript(address: Address) -> Part {
        self[address.row, address.col]
    }

    func neighbors(at addr: Address) -> Set<Address> {
        var result: Set<Address> = []
        for r in [addr.row - 1, addr.row, addr.row + 1] where r >= 0 && r < parts[0].count {
            for c in [addr.col - 1, addr.col, addr.col + 1] where c >= 0 && r < parts.count {
                result.insert(.init(row: r, col: c))
            }
        }

        return result.subtracting([addr])
    }

    func extractNumber(at addr: Address) -> [Address] {
        var result: [Address] = []
        var candidate = Address(
            row: addr.row,
            col: addr.col - 1
        )

        while candidate.col >= 0,
              self[candidate].isDigit
        {
            result.append(candidate)
            candidate.col -= 1
        }

        result = result.reversed() + [addr]
        candidate.col =  addr.col + 1

        while candidate.col < parts[0].count,
              self[candidate].isDigit
        {
            result.append(candidate)
            candidate.col += 1
        }

        return result
    }

    func value(at addrs: [Address]) -> Int {
        Int(String(addrs.map { self[$0].digit! }))!
    }

    func sum() -> Int {
        var visited: Set<Address> = []
        var sum = 0
        for symbolAddr in symbolAddrs {
            for neighbor in neighbors(at: symbolAddr) {
                guard !visited.contains(neighbor), self[neighbor].isDigit else {
                    continue
                }

                let addrs = extractNumber(at: neighbor)
                visited.formUnion(addrs)
                sum += value(at: addrs)
            }
        }

        return sum
    }

    func ratios() -> Int {
        var visited: Set<Address> = []
        var sum = 0
        for symbolAddr in symbolAddrs where self[symbolAddr].isGear {
            var nums: [Int] = []
            for neighbor in neighbors(at: symbolAddr) {
                guard !visited.contains(neighbor), self[neighbor].isDigit else {
                    continue
                }

                let addrs = extractNumber(at: neighbor)
                visited.formUnion(addrs)
                nums.append(value(at: addrs))
            }

            if nums.count == 2 {
                sum += nums[0] * nums[1]
            }
        }

        return sum
    }
}

extension Engine {
    init(lines: [Substring]) {
        var symbolAddrs = Set<Address>()
        var parts: [[Part]] = Array(
            repeating: Array(
                repeating: .empty,
                count: lines[0].count
            ),
            count: lines.count
        )

        for (row, line) in lines.enumerated() {
            for (col, char) in line.enumerated() where char != "." {
                if char.isNumber {
                    parts[row][col] = .digit(char)
                } else {
                    parts[row][col] = .symbol(char)
                    symbolAddrs.insert(.init(row: row, col: col))
                }
            }
        }

        self = .init(
            parts: parts,
            symbolAddrs: symbolAddrs
        )
    }
}

var date = Date()

let engine = Engine(lines: lines)
print("part 1: \(engine.sum()), time: \(-date.timeIntervalSinceNow)")

date = Date()

print("part 2: \(engine.ratios()), time: \(-date.timeIntervalSinceNow)")
