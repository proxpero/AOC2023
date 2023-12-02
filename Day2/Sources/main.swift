import Foundation

let url = Bundle.module.url(forResource: "Input", withExtension: nil)!
let lines = try String(contentsOf: url).split(separator: "\n")

var date = Date()

struct Game {
    let id: Int
    let samples: [Sample]
    
    func isPosssible(with configuration: Sample) -> Bool {
        samples.allSatisfy {
            $0.red <= configuration.red &&
            $0.green <= configuration.green &&
            $0.blue <= configuration.blue
        }
    }

    var minimum: Sample {
        var red = 0, green = 0, blue = 0
        for sample in samples {
            red = max(red, sample.red)
            green = max(green, sample.green)
            blue = max(blue, sample.blue)
        }

        return Sample(red: red, green: green, blue: blue)
    }
}

struct Sample {
    let red: Int
    let green: Int
    let blue: Int

    var power: Int { red * green * blue }
}

extension Game {
    init(line: Substring) {
        let game = line.split(separator: ":")
        let id = Int(String(game[0].split(separator: " ")[1]))!
        let samples = game[1].split(separator: ";").map(Sample.init)

        self = Game(id: id, samples: samples)
    }
}

extension Sample {
    init(input: Substring) {
        var red = 0, green = 0, blue = 0
        for color in input.split(separator: ",") {
            let value = Int(String(color.split(separator: " ")[0]))!
            if color.hasSuffix("red") { red = value }
            else if color.hasSuffix("green") { green = value }
            else if color.hasSuffix("blue") { blue = value }
        }

        self = .init(red: red, green: green, blue: blue)
    }
}

let games = lines.map(Game.init)

let p1 = games
    .filter { $0.isPosssible(with: Sample(red: 12, green: 13, blue: 14)) }
    .reduce(into: 0) { partialResult, game in
        partialResult += game.id
    }

print("part 1: \(p1), \(-date.timeIntervalSinceNow)")
date = Date()

let p2 = games.reduce(into: 0) { partialResult, game in
    partialResult += game.minimum.power
}

print("part 2: \(p2), time: \(-date.timeIntervalSinceNow)")
