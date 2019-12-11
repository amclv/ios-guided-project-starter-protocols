import Foundation
//: We're building a dice game called _Knock Out!_. It is played using the following rules:
//: 1. Each player chooses a “knock out number” – either 6, 7, 8, or 9. More than one player can choose the same number.
//: 2. Players take turns throwing both dice, once each turn. Add the number of both dice to the player's running score.
//: 3. If a player rolls their own knock out number, they are knocked out of the game.
//: 4. Play ends when either all players have been knocked out, or if a single player scores 100 points or higher.
//:
//: Let's reuse some of the work we defined from the previous page.

protocol GeneratesRandomNumbers {
    func random() -> Int
}

protocol DiceGame {
    var dice: Dice { get set }
    var players: [Player] { get set }
    
    func play()
}

protocol DiceGameDelegate {
    // announce when the game starts
    func gameDidStart(game: DiceGame)
    // announce the number that was rolled
    func game(game: DiceGame, didStartNewTurnWithDiceRoll roll: Int)
    // annount when the game ends
    func gameDidEnd(game: DiceGame)
}

class OneThroughTen: GeneratesRandomNumbers {
    func random() -> Int {
        return Int.random(in: 1...10)
    }
}

class Dice {
    let sides: Int
    let generator: GeneratesRandomNumbers
    
    init(sides: Int, generator: GeneratesRandomNumbers) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        return Int(generator.random() % sides) + 1
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    
    func gameDidStart(game: DiceGame) {
        numberOfTurns = 0
        print("Started a new game!")
    }
    
    func game(game: DiceGame, didStartNewTurnWithDiceRoll roll: Int) {
        numberOfTurns += 1
        print("Rolled a \(roll)")
    }
    
    func gameDidEnd(game: DiceGame) {
        print("The game lasted \(numberOfTurns).")
    }
}

class Player {
    let id: Int
    let knockOutNumber: Int = Int.random(in: 6...9)
    var score: Int = 0
    var knockedOut: Bool = false
    
    init(id: Int) {
        self.id = id
    }
}

class KnockOut: DiceGame {
    
    var dice: Dice = Dice(sides: 6, generator: OneThroughTen())
    var players: [Player] = []
    
    // this is the "Tracker"
    var delegate: DiceGameDelegate?
    
    init(numberOfPlayers: Int) {
        // 20
        for i in 1...numberOfPlayers {
            let aPlayer = Player(id: i)
            players.append(aPlayer)
        }
    }
    
    func play() {
        delegate?.gameDidStart(game: self)
        var isGameEnded = false
        
        while !isGameEnded {
            for player in players where player.knockedOut == false {
                let diceRollSum = dice.roll() + dice.roll()
                
                delegate?.game(game: self, didStartNewTurnWithDiceRoll: diceRollSum)
                
                if player.knockOutNumber == diceRollSum {
                    player.knockedOut = true
                    
                    // check if all the players are knocked out, or if some are still playing
                    var activePlayers: [Player] = []
                    
                    for player in players {
                        if player.knockedOut == false {
                            activePlayers.append(player)
                        }
                    }
                    
                    if activePlayers.count == 0 {
                        // the game has ended
                        isGameEnded == true
                        print("All players have been knocked out!")
                        delegate?.gameDidEnd(game: self)
                        return
                    }
                } else {
                    player.score += diceRollSum
                    if player.score >= 100 {
                        isGameEnded = true
                        print("Player \(player.id) has won with a final score of \(player.score)")
                        delegate?.gameDidEnd(game: self)
                        return
                    }
                }
            }
        }
    }
}

let myKnockOut = KnockOut(numberOfPlayers: 15)
let tracker = DiceGameTracker()

myKnockOut.delegate = tracker
myKnockOut.play()


//: Finally, we need to test out our game. Let's create a game instance, add a tracker, and instruct the game to play.

// Make the protocol (DiceGameDelegate)
// Make the `var delegate` in the thing you want to delegate work from. (delegator) example: KnockOut class
// call the delegate.someFunction at the appropriate place
// set the `var delegate` property to an instance of something that conforms to the delegate protocol
