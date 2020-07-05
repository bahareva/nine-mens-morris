protocol Input {
    func readCoordinates() -> String
    func readMovement() -> String
    static func readName() -> String?
    static func pickPools() -> Colors
}

enum Colors: String {
    case black = "●"
    case white = "○"
}

class Player: Input {

    let name: String
    var colorOfPools: Colors
    var poolsOnBoard: Int
    var poolsInHand: Int 

    public static func readName() -> String? {
        print("Enter name of player: ")
        let result: String? = readLine()
        return result
    }

    public static func pickPools() -> Colors {
        print("Pick your pools: 1: ○ ; 2: ● ")
        if let input = readLine() {
            if let res = Int(input) {
                if res == 1 {
                    return Colors.white
                }
                else if res == 2 {
                    return Colors.black
                }
                else {
                    print("Invalid input. Try again. ")
                    return pickPools()
                }
            }
            else {
                print("Invalid input. Try again. ")
                return pickPools()
            }
        }
        return Colors.black
    }

    public init(isFirst: Bool, colorForSecondPerson: Colors) {
        if let res = Player.readName() {
            self.name = res
        }
        else {
            self.name = ""
        }
        if isFirst {
          self.colorOfPools = Player.pickPools()
        }
        else {
            //
            self.colorOfPools = colorForSecondPerson
        }
        self.poolsOnBoard = 0
        self.poolsInHand = 9
    }

    func checkLetter(letter: Character) -> Bool{
        let letters: Array<Character> = ["A","B","C","D","E","F","G"]
        return letters.contains(letter)
    }

    func checkNumber(num: Character) -> Bool{
        let numbers: Array<Character> = ["1","2","3","4","5","6","7"]
        return numbers.contains(num)
    }

    func checkField(arr: Array<Character>) -> Bool{
        if !checkLetter(letter: arr[0]) {
            return false
        }
        else if !checkNumber(num: arr[1]) {
            return false
        } 
        return true
    }

    public func readMovement() -> String {
        print("Enter coordinates to move pool: ")
        if let input = readLine() {
            let arr = Array(input)
            if input.count != 4 {
                print("Invalid input. Try again. ")
                return readMovement()
            }
            let firstPart = [arr[0],arr[1]]
            let secondPart = [arr[2],arr[3]]
            if !checkField(arr: firstPart){
                print("Invalid input. Try again. ")
                return readMovement()
            }
            else if !checkField(arr: secondPart){
                print("Invalid input. Try again. ")
                return readMovement()
            }
            else {
                return input
            }
        }
        else {
            return ""
        }
    }

    public func readCoordinates() -> String {
        print("Enter coordinates to place pool: ")
        if let input = readLine() {
            let arr = Array(input)
            if input.count != 2 {
                print("Invalid input. Try again. ")
                return readCoordinates()
            }
            else if !checkField(arr: arr){
                print("Invalid input. Try again. ")
                return readCoordinates()
            }
            else {
                return input
            }
        }
        else {
            return ""
        }
    }
}

extension Player {
    public var fly: Bool {
        if poolsOnBoard == 3 && poolsInHand == 0 {
            return true
        }
        else {
            return false
        }
    }

    public var startMovement: Bool {
        if poolsInHand == 0 {
            return true
        }
        else {
            return false
        }
    }
}
