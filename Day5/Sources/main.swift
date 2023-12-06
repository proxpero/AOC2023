import Foundation

let url = Bundle.module.url(forResource: "Input", withExtension: nil)!
var chunks = try String(contentsOf: url).split(separator: "\n\n")

let seeds = chunks.removeFirst()
    .split(separator: ":")[1]
    .split(separator: " ")
    .map { Int($0)! }

struct Transformer {
    let source: Range<Int>
    let destination: Range<Int>

    func destination(for source: Int) -> Int? {
        self.source.contains(source) ? destination.lowerBound + (source - self.source.lowerBound) : nil
    }
}

extension Transformer: Comparable {
    init(line: Substring) {
        let values = line.split(separator: " ").map { Int($0)! }
        self.source = values[1] ..< values[1] + values[2]
        self.destination = values[0] ..< values[0] + values[2]
    }

    static func < (lhs: Transformer, rhs: Transformer) -> Bool {
        lhs.source.lowerBound < rhs.source.lowerBound
    }
}

struct Map {
    let transformers: [Transformer]

    func destination(for source: Int) -> Int {
        for transformer in transformers {
            if source < transformer.source.lowerBound {
                return source
            }

            if let result = transformer.destination(for: source) {
                return result
            }
        }

        return source
    }
}

struct Almanac {
    let maps: [Map]

    func location(for seed: Int) -> Int {
        var source = seed
        var destination = Int.min
        for map in maps {
            destination = map.destination(for: source)
            source = destination
        }

        return destination
    }

    func lowestLocation(seeds: [Int]) -> Int {
        var result = Int.max
        for seed in seeds {
            result = min(location(for: seed), result)
        }

        return result
    }

    func lowestLocation(ranges: [Int]) -> Int {
        var ranges = ranges
        var result = Int.max
        while !ranges.isEmpty {
            let start = ranges.removeFirst()
            let length = ranges.removeFirst()
            for seed in (start ..< start + length) {
                result = min(location(for: seed), result)
            }
        }

        return result
    }
}

extension Almanac {
    init(chunks: [Substring]) {
        self.maps = chunks.reduce(into: [Map]()) { partialResult, chunk in
            let transformers = chunk
                .split(separator: "\n")
                .dropFirst()
                .map(Transformer.init)
                .sorted()
            partialResult.append(.init(transformers: transformers))
        }
    }
}

let almanac = Almanac(chunks: chunks)

var date = Date()
print("part 1: \(almanac.lowestLocation(seeds: seeds)), time: \(-date.timeIntervalSinceNow)")

date = Date()
print("part 2: \(almanac.lowestLocation(ranges: seeds)), time: \(-date.timeIntervalSinceNow)")
