import Foundation

let url = Bundle.module.url(forResource: "Input", withExtension: nil)!
var lines = try String(contentsOf: url).split(separator: "\n")

struct Race {
    let time: Int
    let distance: Int

    func distance(for holdingTime: Int) -> Int {
        holdingTime * (time - holdingTime)
    }

    var minimumTime: Int {
        (0 ..< time).first(where: { distance(for: $0) > distance })!
    }

    var maximumTime: Int {
        stride(from: time, to: 0, by: -1).first(where: { distance(for: $0) > distance })!
    }

    var rangeOfTimes: ClosedRange<Int> {
        minimumTime ... maximumTime
    }
}

extension Array<Race> {
    var numberOfWays: Int {
        self.reduce(into: 1) { partialResult, race in
            partialResult *= race.rangeOfTimes.count
        }
    }
}

var date = Date()
let p1 = {
    let values = lines.map { line in
        line.split(separator: ":")[1]
            .split(separator: " ")
            .map { Int(String($0))! }
    }

    var races: [Race] = []
    for (time, dist) in zip(values[0], values[1]) {
        races.append(.init(time: time, distance: dist))
    }

    return races
}()

print("part 1: \(p1.numberOfWays), time: \(-date.timeIntervalSinceNow)")

date = Date()
let p2 = {
    let values = lines.map { line in
        line.split(separator: ":")[1]
            .split(separator: " ")
            .joined()
    }

    return [
        Race(time: Int(values[0])!, distance: Int(values[1])!)
    ]
}()

print("part 2: \(p2.numberOfWays), time: \(-date.timeIntervalSinceNow)")
