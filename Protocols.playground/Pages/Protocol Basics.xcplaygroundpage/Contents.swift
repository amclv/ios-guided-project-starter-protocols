import Foundation

//: # Protocols
//: Protocols are, as per Apple's definition in the _Swift Programming Language_ book:
//:
//: "... a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality. The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements. Any type that satisfies the requirements of a protocol is said to conform to that protocol."
//:
//: The below example shows a protocol that requires conforming types have a particular property defined.

// our app needs to the user's full name.
// we can write a protocol to make sure that anything that uses the protocol has a full name.

// Anything inside of this protocol becomes the requirements for anyone to follow these rules
protocol FullyNamed {
    // get - read or look at the value
    // set - set or give it a value
    var fullName: String { get }
}

// The person struct is "Adopting" the fullyNamed Protocol
struct Person: FullyNamed {
    var fullName: String
    
}

let person = Person(fullName: "Aaron Cleveland")

struct Starship: FullyNamed, Equatable {
    
    var prefix: String?
    var name: String
    
    // Computed property - The value of the fullName will be "computed" or figured out every time you access it.
    
    // { get } only
    var fullName: String {
        // USS - Prefix
        // Enterprise - Name
        if let prefix = prefix {
            return prefix + " " + name
        } else {
            return name
        }
    }
    
    static func == (lhs: Starship, rhs: Starship) -> Bool {
        if lhs.fullName == rhs.fullName {
            return true
        } else {
            return false
        }
    }
    
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    
}

var starship = Starship(name: "Enterprise", prefix: "USS")

starship.name = "Something else"
starship.fullName

//: Protocols can also require that conforming types implement certain methods.

protocol GenerateRandomNumbers {
    // We don't give the implementation of the function in the protocol
    func random() -> Int
}

class OneThroughTen: GenerateRandomNumbers {
    func random() -> Int {
        return Int.random(in: 1...10)
    }
}

let numberGenerater = OneThroughTen()
let random = numberGenerater.random()

//: Using built-in Protocols

let enterprise = Starship(name: "Enterprise", prefix: "USS")
let firefly = Starship(name: "Serenity")

if enterprise == firefly {
    print("They are the same ship!")
} else {
    print("These ships are not the same.")
}

//: ## Protocols as Types



